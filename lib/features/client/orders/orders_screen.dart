import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/seed.dart';
import '../../../core/format/price.dart';
import '../../../core/format/time.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/models/order.dart';
import '../../../core/order_engine/order_engine.dart';
import '../../../core/theme/kafza_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/initial_image.dart';
import '../../../core/widgets/order_widgets.dart';

const _current = {
  OrderStatus.placed,
  OrderStatus.accepted,
  OrderStatus.inPreparation,
  OrderStatus.ready,
  OrderStatus.pickedUp,
};

/// Where the client's money is, in one line (DESIGN.md › Money line).
(IconData, String) moneyLine(BuildContext context, Order o) {
  final l10n = AppLocalizations.of(context);
  final total = formatPrice(context, o.total);
  if (o.status == OrderStatus.disputed) return (IconsaxPlusLinear.judge, l10n.moneyUnderReview(total));
  return switch (o.money) {
    Money.inWallet when o.status == OrderStatus.placed => (IconsaxPlusLinear.wallet, l10n.moneyInWallet(total)),
    Money.inWallet => (IconsaxPlusLinear.wallet, l10n.moneyNothingTaken),
    Money.held => (IconsaxPlusLinear.lock, l10n.moneyHeld(total)),
    Money.paid => (IconsaxPlusLinear.tick_circle, l10n.moneyPaid(total)),
    Money.refunded => (KafzaIcons.undo, l10n.moneyRefunded(formatPrice(context, o.refund))),
  };
}

/// C9: my orders, Current / Past (CLT-29).
class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final mine = ref.watch(orderEngineProvider.select((s) => s.orders.where((o) => o.clientId == demoClientId).toList()));
    final current = mine.where((o) => _current.contains(o.status)).toList();
    final past = mine.where((o) => !_current.contains(o.status)).toList();

    Widget list(List<Order> orders, String empty) => orders.isEmpty
        ? EmptyState(
            icon: IconsaxPlusLinear.receipt_text,
            title: empty,
            body: l10n.noOrdersHint,
            action: l10n.browse,
            onAction: () => StatefulNavigationShell.of(context).goBranch(0),
          )
        : ListView.separated(
            padding: const EdgeInsets.all(KafzaSpacing.lg),
            itemCount: orders.length,
            separatorBuilder: (_, _) => const SizedBox(height: KafzaSpacing.md),
            itemBuilder: (_, i) => _OrderCard(orders[i]),
          );

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(tabs: [Tab(text: l10n.ordersCurrent(current.length)), Tab(text: l10n.ordersPast(past.length))]),
          Expanded(
            child: TabBarView(children: [list(current, l10n.noCurrentOrders), list(past, l10n.noPastOrders)]),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends ConsumerWidget {
  const _OrderCard(this.order);

  final Order order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final secondary = Theme.of(context).colorScheme.onSurfaceVariant;
    final store = ref.watch(orderEngineProvider.select((s) => s.store(order.storeId)));
    final (icon, money) = moneyLine(context, order);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go('/kafza/orders/${order.id}'),
        child: Padding(
          padding: const EdgeInsets.all(KafzaSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: KafzaSpacing.md,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: KafzaSpacing.md,
                children: [
                  SizedBox.square(dimension: 48, child: InitialImage(order.productTitle, id: order.productId)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 2,
                      children: [
                        Text(isolate(order.productTitle), style: text.bodyLarge),
                        Text(
                          '${isolate(store.name)} · ${formatDateTime(l10n, order.placedAt)}',
                          style: text.bodySmall!.copyWith(color: secondary),
                        ),
                        const SizedBox(height: KafzaSpacing.xs),
                        StatusChip(order.status),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                spacing: KafzaSpacing.sm,
                children: [
                  Icon(icon, size: 18, color: secondary),
                  Expanded(child: Text(money, style: text.bodyMedium)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
