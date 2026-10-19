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
import '../../../core/widgets/quantity_stepper.dart';
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

/// C7: order summary (CLT-18…22). Without [draft] it checks out the store basket, whose
/// quantities can still change here. Cancel goes back; nothing is created.
class SummaryScreen extends ConsumerWidget {
  const SummaryScreen({super.key, this.draft});

  /// A made-to-order draft: it is ordered on its own, never from the basket.
  final OrderDraft? draft;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final secondary = Theme.of(context).colorScheme.onSurfaceVariant;
    final state = ref.watch(orderEngineProvider);
    final basket = ref.watch(basketProvider);
    final items = draft != null ? [draft!] : basket?.items ?? const <OrderDraft>[];
    // The last line was just removed and the screen is closing.
    if (items.isEmpty) return Scaffold(appBar: AppBar(title: Text(l10n.summaryTitle)));
    final fromBasket = draft == null;
    final store = state.store(state.product(items.first.productId).storeId);
    final client = state.client(demoClientId);
    final addressId = ref.watch(addressIdProvider);
    final address = client.addresses.firstWhere((a) => a.id == addressId, orElse: () => client.addresses.first);
    final amounts = draftsAmounts(state, items);
    final missing = amounts.total - client.balance;
    final now = ref.read(clockProvider);

    // What changed since the product went in the basket: the store paused it, or stock fell.
    String? problem(Product p, OrderDraft d) {
      if (d.type != OrderType.readyMade) return null;
      final available = p.readyMade?.available ?? 0;
      if (p.status != ProductStatus.live || !state.takingOrders(store, now) || available < 1) {
        return l10n.lineUnavailable;
      }
      if (d.qty > available) return l10n.lineOnlyLeft(l10n.qty(p.unit, available));
      return null;
    }

    final blocked = items.any((d) => problem(state.product(d.productId), d) != null);

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
        final o = await engine.placeOrder(clientId: demoClientId, addressId: address.id, items: items);
        if (!context.mounted) return;
        if (fromBasket) ref.read(basketProvider.notifier).clear();
        context.go('/kafza/orders/${o.id}/placed');
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
          Wrap(
            spacing: KafzaSpacing.sm,
            runSpacing: KafzaSpacing.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                l10n.storeDistance(isolate(store.name), formatNumber(context, store.distanceKm)),
                style: text.bodyMedium!.copyWith(color: secondary),
              ),
              KafzaBadge(items.first.type == OrderType.readyMade ? l10n.readyMadeTitle : l10n.madeToOrderTitle),
            ],
          ),
          for (final d in items) ...[
            const SizedBox(height: KafzaSpacing.lg),
            _DraftLine(
              draft: d,
              problem: problem(state.product(d.productId), d),
              onQty: fromBasket
                  ? (v) => ref
                      .read(basketProvider.notifier)
                      .put(store.id, OrderDraft(productId: d.productId, type: d.type, qty: v))
                  : null,
              onRemove: fromBasket
                  ? () {
                      ref.read(basketProvider.notifier).remove(d.productId);
                      if (items.length == 1) context.pop();
                    }
                  : null,
            ),
          ],
          const SizedBox(height: KafzaSpacing.xl),
          if (draft case final d?) ...[
            for (final line in draftOptionLines(l10n, state.product(d.productId), d))
              row(IconsaxPlusLinear.setting_4, l10n.optionsLine, line),
            if (d.date case final day?) row(IconsaxPlusLinear.calendar_1, l10n.deliveryDate, formatDay(l10n, day)),
          ],
          row(IconsaxPlusLinear.location, l10n.chooseAddress, isolate('${address.label} · ${address.street}, ${address.commune}')),
          const SizedBox(height: KafzaSpacing.sm),
          PriceBreakdown(
            itemsLabel: items.length == 1
                ? itemsLabel(context, state.product(items.single.productId), items.single.type, items.single.qty)
                : l10n.itemsTotal,
            items: amounts.items,
            options: amounts.options,
            deliveryFee: amounts.fee,
            freeDelivery: amounts.free,
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
                KafzaButton(l10n.placeOrder, onPressed: missing > 0 || blocked ? null : place),
                TextButton(onPressed: () => context.pop(), child: Text(l10n.cancel)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// One product of the summary: picture, title, unit price, line total, and why it can't be
/// ordered any more. Basket lines also get a stepper and Remove.
class _DraftLine extends ConsumerWidget {
  const _DraftLine({required this.draft, this.problem, this.onQty, this.onRemove});

  final OrderDraft draft;
  final String? problem;
  final ValueChanged<num>? onQty;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final p = ref.watch(orderEngineProvider.select((s) => s.product(draft.productId)));
    final a = draftAmounts(p, draft);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: KafzaSpacing.xs,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    itemsLabel(context, p, draft.type, draft.qty),
                    style: text.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
                  ),
                  if (problem != null) Text(problem!, style: text.bodySmall!.copyWith(color: scheme.error)),
                ],
              ),
            ),
            Text(
              formatPrice(context, a.items + a.options),
              style: text.labelLarge!.copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
            ),
          ],
        ),
        if (onQty != null)
          Row(
            children: [
              QuantityStepper(
                value: draft.qty,
                max: p.readyMade?.available ?? 0,
                label: l10n.qty(p.unit, draft.qty),
                onChanged: onQty!,
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(IconsaxPlusLinear.trash),
                tooltip: l10n.removeFromBasket,
                color: scheme.error,
                onPressed: onRemove,
              ),
            ],
          ),
      ],
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
          Text(AppLocalizations.of(context).orderTitle(order), style: text.labelLarge),
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
