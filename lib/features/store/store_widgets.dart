import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/clock.dart';
import '../../core/format/price.dart';
import '../../core/format/time.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/l10n/labels.dart';
import '../../core/models/notification.dart';
import '../../core/models/order.dart';
import '../../core/order_engine/order_engine.dart';
import '../../core/theme/kafza_theme.dart';
import '../../core/widgets/initial_image.dart';
import '../../core/widgets/kafza_badge.dart';
import '../../core/widgets/kafza_button.dart';
import '../../core/widgets/kafza_sheet.dart';
import '../../core/widgets/order_widgets.dart';
import 'store_providers.dart';

void snack(BuildContext context, String message) => ScaffoldMessenger.of(context)
  ..hideCurrentSnackBar()
  ..showSnackBar(SnackBar(content: Text(message)));

/// Where a store notification leads (banner and S14 list).
String noticeRoute(AppNotification n) => switch (n.kind) {
      NoticeKind.order => '/orders/${n.orderId}',
      NoticeKind.lowStock => '/products',
      NoticeKind.review => '/more/reviews',
      NoticeKind.strike || NoticeKind.suspended => '/more/strikes',
      _ => '/home',
    };

const tabular = [FontFeature.tabularFigures()];

/// S5 / S6 card. The client appears only as a commune (privacy, brief §2).
class StoreOrderCard extends ConsumerWidget {
  const StoreOrderCard(this.order, {super.key});

  final Order order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final secondary = text.bodySmall!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant);
    final o = order;
    final placed = o.status == OrderStatus.placed;
    if (placed) ref.watch(clockProvider.select((t) => t.millisecondsSinceEpoch ~/ 60000));
    final details = [
      l10n.qty(o.unit, o.qty),
      for (final x in o.options) isolate(x.value),
      if (o.deliveryDate case final d?) l10n.deliveryOn(formatDay(l10n, d)),
    ].join(' · ');

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go('/orders/${o.id}'),
        child: Padding(
          padding: const EdgeInsets.all(KafzaSpacing.lg),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: KafzaSpacing.md,
            children: [
              SizedBox.square(dimension: 48, child: InitialImage(o.productTitle, id: o.productId)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: KafzaSpacing.sm,
                      children: [
                        Expanded(child: Text(isolate(o.productTitle), style: text.bodyLarge)),
                        Text(formatPrice(context, o.total), style: text.labelLarge!.copyWith(fontFeatures: tabular)),
                      ],
                    ),
                    Text(details, style: text.bodyMedium),
                    Text(l10n.clientIn(isolate(o.address.commune), ltr(o.id)), style: secondary),
                    const SizedBox(height: KafzaSpacing.xs),
                    Wrap(
                      spacing: KafzaSpacing.xs,
                      runSpacing: KafzaSpacing.xs,
                      children: [
                        if (placed)
                          CountdownChip(
                            deadline: o.deadline,
                            window: acceptanceWindow(o.type),
                            now: ref.read(clockProvider),
                          )
                        else
                          StatusChip(o.status),
                        KafzaBadge(
                          o.type == OrderType.readyMade ? l10n.readyMadeTitle : l10n.madeToOrderTitle,
                          tone: BadgeTone.neutral,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Item total · commission · delivery fee (free delivery only) · net earnings (PAY-08).
class EarningsBreakdown extends StatelessWidget {
  const EarningsBreakdown(this.order, {super.key});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    Widget line(String label, String amount, {bool bold = false}) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: KafzaSpacing.md,
          children: [
            Expanded(child: Text(label, style: bold ? text.titleMedium : text.bodyMedium)),
            Text(
              amount,
              style: (bold ? text.titleMedium!.copyWith(fontWeight: FontWeight.w700) : text.bodyMedium!)
                  .copyWith(fontFeatures: tabular),
            ),
          ],
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: KafzaSpacing.sm,
      children: [
        line(l10n.itemsTotal, formatPrice(context, order.itemTotal)),
        line(l10n.commissionLine, formatPrice(context, -order.commission)),
        if (order.freeDelivery) line(l10n.deliveryDeductedLine, formatPrice(context, -order.deliveryFee)),
        const Divider(),
        line(l10n.netEarnings, formatPrice(context, order.earnings), bold: true),
      ],
    );
  }
}

/// Digits only, always LTR: prices, phone, card and CCP numbers. These aren't free text, so
/// no contactCheck (a CCP number would read as a phone number).
class NumberField extends StatelessWidget {
  const NumberField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.maxLength = 7,
    this.prefix,
    this.suffix,
    this.helper,
    this.error,
    this.autofocus = false,
  });

  final String label, value;
  final ValueChanged<String> onChanged;
  final int maxLength;
  final String? prefix, suffix, helper, error;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    // The digits run LTR but the decoration follows the locale, so in Arabic the prefix
    // slot is on the right. Swap the slots to keep "+213 555…" and "2400 … د.ج" in order.
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return TextFormField(
      initialValue: value,
      onChanged: onChanged,
      autofocus: autofocus,
      keyboardType: TextInputType.number,
      textDirection: TextDirection.ltr,
      style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(maxLength)],
      decoration: InputDecoration(
        labelText: label,
        prefixText: rtl ? suffix : prefix,
        suffixText: rtl ? prefix : suffix,
        helperText: helper,
        helperMaxLines: 3,
        errorText: error,
        errorMaxLines: 3,
      ),
    );
  }
}

/// Primary action pinned under a long page, with a top border (DESIGN.md › Layout).
class BottomBar extends StatelessWidget {
  const BottomBar({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant))),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(KafzaSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: KafzaSpacing.sm,
              children: children,
            ),
          ),
        ),
      );
}

/// Kafza Pro: Free vs Pro, paid from the store balance.
Future<void> showProSheet(BuildContext context) => showKafzaSheet<void>(context, (_) => const _ProSheet());

class _ProSheet extends ConsumerWidget {
  const _ProSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final store = ref.watch(currentStoreProvider);
    if (store == null) return const SizedBox.shrink();
    final short = store.balance < proPrice;

    Widget plan(String title, String price, List<String> lines, {bool pro = false}) => Container(
          padding: const EdgeInsets.all(KafzaSpacing.lg),
          decoration: BoxDecoration(
            color: pro ? scheme.primaryContainer : null,
            border: Border.all(color: pro ? scheme.primary : scheme.outlineVariant),
            borderRadius: BorderRadius.circular(KafzaRadius.card),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: KafzaSpacing.xs,
            children: [
              Row(
                spacing: KafzaSpacing.sm,
                children: [
                  Expanded(child: Text(title, style: text.titleMedium)),
                  Text(price, style: text.labelLarge!.copyWith(fontFeatures: const [FontFeature.tabularFigures()])),
                ],
              ),
              for (final line in lines)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: KafzaSpacing.sm,
                  children: [
                    Icon(IconsaxPlusLinear.tick_circle, size: 20, color: pro ? scheme.primary : scheme.onSurfaceVariant),
                    Expanded(child: Text(line, style: text.bodyMedium)),
                  ],
                ),
            ],
          ),
        );

    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.fromSTEB(KafzaSpacing.lg, 0, KafzaSpacing.lg, KafzaSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: KafzaSpacing.md,
        children: [
          Text(l10n.proTitle, style: text.titleLarge),
          Text(l10n.proBody, style: text.bodyMedium!.copyWith(color: scheme.onSurfaceVariant)),
          plan(l10n.planFree, l10n.planFreePrice, [l10n.planFreeLine]),
          plan(l10n.badgePro, l10n.perMonth(formatPrice(context, proPrice)), [l10n.planProLine1, l10n.planProLine2],
              pro: true),
          if (store.pro)
            Text(l10n.proActive, style: text.labelLarge, textAlign: TextAlign.center)
          else ...[
            Text(
              short
                  ? l10n.proShort(formatPrice(context, store.balance))
                  : l10n.proFromBalance(formatPrice(context, store.balance)),
              style: text.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            KafzaButton(
              l10n.getPro,
              onPressed: short
                  ? null
                  : () async {
                      try {
                        await ref.read(orderEngineProvider.notifier).subscribePro(store.id);
                        if (context.mounted) Navigator.pop(context);
                      } on OrderException catch (e) {
                        if (context.mounted) snack(context, l10n.orderError(e.error));
                      }
                    },
            ),
          ],
        ],
      ),
    );
  }
}
