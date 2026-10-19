import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/clock.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/models/order.dart';
import '../../../core/models/product.dart';
import '../../../core/order_engine/order_engine.dart';
import '../../../core/theme/kafza_theme.dart';
import '../../../core/widgets/product_detail_view.dart';
import '../client_providers.dart';
import '../client_widgets.dart';
import '../ordering/order_sheet.dart';

/// C5: product page (CLT-09…12).
class ProductPage extends ConsumerWidget {
  const ProductPage({super.key, required this.id, this.fromStore = false});

  final String id;

  /// Opened from its store's page, which sits right under it.
  final bool fromStore;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final state = ref.watch(orderEngineProvider);
    // Watching keeps the store basket alive while this page is open.
    ref.watch(basketProvider);
    final p = state.product(id);
    final store = state.store(p.storeId);
    final storeOpen = state.takingOrders(store, ref.read(clockProvider));
    final open = p.status == ProductStatus.live && storeOpen;
    final canNow = open && p.canOrderNow;
    final canMade = open && p.madeToOrder != null;

    void toStore() => fromStore ? context.pop() : context.push('/store/${store.id}');

    // Order sheet (C6) → summary (C7). Ready-made goes through the store basket.
    Future<void> order(OrderType type) async {
      final r = await showOrderSheet(context, id, type);
      if (r == null || !context.mounted) return;
      if (type == OrderType.madeToOrder) {
        context.push('/order', extra: r.draft);
        return;
      }
      try {
        ref.read(basketProvider.notifier).put(store.id, r.draft);
      } on OrderException catch (e) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l10n.orderError(e.error))));
        return;
      }
      r.buyNow ? context.push('/order') : toStore();
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          FavouriteButton(id),
          IconButton(
            icon: const Icon(IconsaxPlusLinear.share),
            tooltip: l10n.share,
            onPressed: () => shareLink(context, 'product/$id'),
          ),
        ],
      ),
      body: ListView(
        children: [
          ProductDetailView(
            product: p,
            store: store,
            rating: state.rating(productId: id),
            storeRating: state.rating(storeId: store.id),
            onStoreTap: toStore,
          ),
        ],
      ),
      // Sticky action bar. "Order now" is the primary when stock allows; otherwise
      // "Order made for me" is. Neither → a disabled bar that says why.
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(border: Border(top: BorderSide(color: scheme.outlineVariant))),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(KafzaSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: KafzaSpacing.sm,
              children: [
                if (canNow) FilledButton(onPressed: () => order(OrderType.readyMade), child: Text(l10n.orderNow)),
                if (canMade)
                  canNow
                      ? OutlinedButton(
                          onPressed: () => order(OrderType.madeToOrder),
                          child: Text(l10n.orderMadeForMe),
                        )
                      : FilledButton(onPressed: () => order(OrderType.madeToOrder), child: Text(l10n.orderMadeForMe)),
                if (!canNow && !canMade) ...[
                  Text(
                    !storeOpen
                        ? l10n.notTakingOrders
                        : open
                            ? l10n.outOfStockHint
                            : l10n.productPausedHint,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: scheme.onSurfaceVariant),
                  ),
                  FilledButton(onPressed: null, child: Text(l10n.currentlyUnavailable)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
