import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/clock.dart';
import '../../../core/data/seed.dart';
import '../../../core/format/price.dart';
import '../../../core/format/time.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/models/order.dart';
import '../../../core/models/product.dart';
import '../../../core/order_engine/order_engine.dart';
import '../../../core/theme/kafza_theme.dart';
import '../../../core/widgets/info_banner.dart';
import '../../../core/widgets/initial_image.dart';
import '../../../core/widgets/kafza_badge.dart';
import '../../../core/widgets/kafza_sheet.dart';
import '../../../core/widgets/kafza_button.dart';
import '../../../core/widgets/order_widgets.dart';
import '../client_providers.dart';
import '../client_widgets.dart';
import 'order_sheet.dart';

/// "Taille : M · 40 parts" lines for a draft's picks.
List<String> draftOptionLines(AppLocalizations l10n, Product p, OrderDraft d) => [
      for (final g in p.madeToOrder?.optionGroups ?? const <OptionGroup>[])
        if (d.type == OrderType.madeToOrder && (d.picks[g.id] ?? const []).any((v) => v.isNotEmpty))
          l10n.labelValue(
            isolate(g.name),
            g.type == OptionType.text
                ? isolate(d.picks[g.id]!.single)
                : g.choices.where((c) => d.picks[g.id]!.contains(c.id)).map((c) => isolate(c.name)).join(l10n.listSeparator),
          ),
    ];

/// C7: order summary (CLT-18…22). Cancel goes back to the product; nothing is created.
class SummaryScreen extends ConsumerWidget {
  const SummaryScreen({super.key, required this.draft});

  final OrderDraft draft;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final secondary = Theme.of(context).colorScheme.onSurfaceVariant;
    final state = ref.watch(orderEngineProvider);
    final p = state.product(draft.productId);
    final store = state.store(p.storeId);
    final client = state.client(demoClientId);
    final addressId = ref.watch(addressIdProvider);
    final address = client.addresses.firstWhere((a) => a.id == addressId, orElse: () => client.addresses.first);
    final amounts = draftAmounts(p, draft);
    final fee = deliveryFee(store.distanceKm);
    final total = amounts.items + amounts.options + (p.freeDelivery ? 0 : fee);
    final missing = total - client.balance;

    Future<void> place() async {
      final engine = ref.read(orderEngineProvider.notifier);
      final waiting = ref.read(orderEngineProvider).waitingOrder(demoClientId);
      if (waiting != null) {
        final replace = await showKafzaDialog(
          context,
          title: l10n.waitingTitle,
          body: l10n.waitingBody,
          cancel: l10n.keepIt,
          confirm: l10n.cancelAndPlace,
          content: _WaitingCard(waiting),
        );
        if (!replace) return;
        try {
          engine.cancelByClient(waiting.id);
        } on OrderException {
          // The store answered meanwhile: it no longer waits, so placing is fine.
        }
      }
      try {
        final o = await engine.placeOrder(
          clientId: demoClientId,
          productId: p.id,
          type: draft.type,
          qty: draft.qty,
          addressId: address.id,
          picks: draft.picks,
          deliveryDate: draft.date,
        );
        if (context.mounted) context.go('/kafza/orders/${o.id}/placed');
      } on OrderException catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l10n.orderError(e.error))));
      }
    }

    Widget row(IconData icon, String label, String value) => Padding(
          padding: const EdgeInsetsDirectional.only(bottom: KafzaSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: KafzaSpacing.md,
            children: [
              Icon(icon, size: 20, color: secondary),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: text.bodySmall!.copyWith(color: secondary)),
                    Text(value, style: text.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
        );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.summaryTitle)),
      body: ListView(
        padding: const EdgeInsets.all(KafzaSpacing.lg),
        children: [
          Row(
            spacing: KafzaSpacing.md,
            children: [
              SizedBox.square(dimension: 64, child: InitialImage(p.title, id: p.id)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    Text(isolate(p.title), style: text.titleMedium),
                    Text(
                      l10n.storeDistance(isolate(store.name), formatNumber(context, store.distanceKm)),
                      style: text.bodySmall!.copyWith(color: secondary),
                    ),
                    KafzaBadge(draft.type == OrderType.readyMade ? l10n.readyMadeTitle : l10n.madeToOrderTitle),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: KafzaSpacing.xl),
          row(IconsaxPlusLinear.bag_2, l10n.quantity, l10n.qty(p.unit, draft.qty)),
          for (final line in draftOptionLines(l10n, p, draft)) row(IconsaxPlusLinear.setting_4, l10n.optionsLine, line),
          if (draft.date case final d?) row(IconsaxPlusLinear.calendar_1, l10n.deliveryDate, formatDay(l10n, d)),
          row(IconsaxPlusLinear.location, l10n.chooseAddress, isolate('${address.label} · ${address.street}, ${address.commune}')),
          const SizedBox(height: KafzaSpacing.sm),
          PriceBreakdown(
            itemsLabel: itemsLabel(context, p, draft.type, draft.qty),
            items: amounts.items,
            options: amounts.options,
            deliveryFee: fee,
            freeDelivery: p.freeDelivery,
          ),
          const SizedBox(height: KafzaSpacing.xl),
          BalanceCard(
            balance: client.balance,
            missing: missing,
            onRecharge: () => context.push('/recharge', extra: missing),
          ),
          const SizedBox(height: KafzaSpacing.md),
          InfoBanner(icon: IconsaxPlusLinear.lock_circle, text: l10n.summaryMoneyNote),
        ],
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant))),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(KafzaSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: KafzaSpacing.xs,
              children: [
                KafzaButton(l10n.placeOrder, onPressed: missing > 0 ? null : place),
                TextButton(onPressed: () => context.pop(), child: Text(l10n.cancel)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The waiting order, live countdown included, shown in the replace-or-keep dialog.
class _WaitingCard extends ConsumerWidget {
  const _WaitingCard(this.order);

  final Order order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    ref.watch(clockProvider.select((t) => t.millisecondsSinceEpoch ~/ 60000));
    final now = ref.read(clockProvider);
    final store = ref.watch(orderEngineProvider.select((s) => s.store(order.storeId)));
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(KafzaSpacing.md),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(KafzaRadius.input),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: KafzaSpacing.xs,
        children: [
          Text(isolate(order.productTitle), style: text.labelLarge),
          Text('${isolate(store.name)} · ${formatPrice(context, order.total)}', style: text.bodySmall),
          CountdownChip(deadline: order.deadline, window: acceptanceWindow(order.type), now: now),
        ],
      ),
    );
  }
}

/// Mock Yassir recharge page: amount presets, confirm, processing, success, back.
class RechargeScreen extends ConsumerStatefulWidget {
  const RechargeScreen({super.key, required this.missing});

  /// What the order still needs; the first preset covers it.
  final int missing;

  @override
  ConsumerState<RechargeScreen> createState() => _RechargeScreenState();
}

class _RechargeScreenState extends ConsumerState<RechargeScreen> {
  late final _presets = {if (widget.missing > 0) widget.missing, 2000, 5000, 10000}.toList()..sort();
  late int _amount = widget.missing > 0 ? widget.missing : _presets.first;
  bool _done = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final balance = ref.watch(orderEngineProvider.select((s) => s.client(demoClientId).balance));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.rechargeCcp)),
      body: ListView(
        padding: const EdgeInsets.all(KafzaSpacing.lg),
        children: [
          if (_done) ...[
            const SizedBox(height: KafzaSpacing.xxl),
            Icon(IconsaxPlusBold.tick_circle, size: 64, color: context.kafza.success),
            const SizedBox(height: KafzaSpacing.lg),
            Text(l10n.rechargeDone(formatPrice(context, _amount)), style: text.titleLarge, textAlign: TextAlign.center),
            const SizedBox(height: KafzaSpacing.sm),
            Text(
              l10n.newBalance(formatPrice(context, balance)),
              style: text.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ] else ...[
            BalanceCard(balance: balance),
            const SizedBox(height: KafzaSpacing.xl),
            Text(l10n.rechargeAmount, style: text.titleMedium),
            const SizedBox(height: KafzaSpacing.sm),
            Wrap(
              spacing: KafzaSpacing.sm,
              runSpacing: KafzaSpacing.sm,
              children: [
                for (final a in _presets)
                  ChoiceChip(
                    label: Text(formatPrice(context, a)),
                    selected: a == _amount,
                    onSelected: (_) => setState(() => _amount = a),
                  ),
              ],
            ),
            if (widget.missing > 0) ...[
              const SizedBox(height: KafzaSpacing.sm),
              Text(
                l10n.missingAmount(formatPrice(context, widget.missing)),
                style: text.bodySmall!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ],
            const SizedBox(height: KafzaSpacing.xl),
            InfoBanner(icon: IconsaxPlusLinear.bank, text: l10n.rechargeMockNote),
          ],
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(KafzaSpacing.lg),
          child: _done
              ? FilledButton(
                  onPressed: () => context.pop(),
                  child: Text(widget.missing > 0 ? l10n.backToOrder : l10n.ok),
                )
              : KafzaButton(
                  l10n.rechargeConfirm(formatPrice(context, _amount)),
                  onPressed: () async {
                    await ref.read(orderEngineProvider.notifier).recharge(demoClientId, _amount);
                    if (mounted) setState(() => _done = true);
                  },
                ),
        ),
      ),
    );
  }
}
