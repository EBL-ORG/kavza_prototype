import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/models/order.dart';
import '../../../core/order_engine/order_engine.dart';
import '../../../core/theme/kafza_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../store_providers.dart';
import '../store_widgets.dart';

const _inProgress = {OrderStatus.accepted, OrderStatus.inPreparation, OrderStatus.ready, OrderStatus.pickedUp};

/// S6: New / In progress / History (STR-27).
class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final id = ref.watch(currentStoreProvider.select((s) => s?.id));
    final mine = ref.watch(orderEngineProvider.select((s) => s.orders.where((o) => o.storeId == id).toList()));
    final fresh = mine.where((o) => o.status == OrderStatus.placed).toList();
    final inProgress = mine.where((o) => _inProgress.contains(o.status)).toList();
    final history = mine.where((o) => o.status != OrderStatus.placed && !_inProgress.contains(o.status)).toList();

    Widget list(List<Order> orders, String empty, String hint) => orders.isEmpty
        ? EmptyState(icon: IconsaxPlusLinear.receipt_text, title: empty, body: hint)
        : ListView.separated(
            padding: const EdgeInsets.all(KafzaSpacing.lg),
            itemCount: orders.length,
            separatorBuilder: (_, _) => const SizedBox(height: KafzaSpacing.md),
            itemBuilder: (_, i) => StoreOrderCard(orders[i]),
          );

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.tabOrders),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.ordersNew(fresh.length)),
              Tab(text: l10n.ordersInProgress(inProgress.length)),
              Tab(text: l10n.ordersHistory),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            list(fresh, l10n.noNewOrders, l10n.noNewOrdersHint),
            list(inProgress, l10n.noOrdersInProgress, l10n.noOrdersInProgressHint),
            list(history, l10n.noOrderHistory, l10n.noOrderHistoryHint),
          ],
        ),
      ),
    );
  }
}
