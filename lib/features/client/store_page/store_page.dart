import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../core/data/clock.dart';
import '../../../core/format/price.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/models/catalog.dart';
import '../../../core/models/order.dart';
import '../../../core/models/product.dart';
import '../../../core/order_engine/order_engine.dart';
import '../../../core/theme/kafza_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/info_banner.dart';
import '../../../core/widgets/initial_image.dart';
import '../../../core/widgets/kafza_badge.dart';
import '../../../core/widgets/kafza_sheet.dart';
import '../../../core/widgets/rating_stars.dart';
import '../client_providers.dart';
import '../client_widgets.dart';
import '../ordering/order_sheet.dart';

/// Leaving the store empties its basket: true when the client confirms.
Future<bool> confirmLeaveStore(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  return showKafzaDialog(
    context,
    title: l10n.leaveStoreTitle,
    body: l10n.leaveStoreBody,
    cancel: l10n.stayInStore,
    confirm: l10n.leaveStoreConfirm,
    destructive: true,
  );
}

/// C4: store page. Commune and approximate distance only, never an address (CLT-07).
/// In-stock products have a quick add into the store basket, shown in a bar at the bottom.
class StorePage extends ConsumerWidget {
  const StorePage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final secondary = Theme.of(context).colorScheme.onSurfaceVariant;
    final state = ref.watch(orderEngineProvider);
    final now = ref.read(clockProvider);
    final store = state.store(id);
    final taking = state.takingOrders(store, now);
    final rating = state.rating(storeId: id);
    final products = state.listedProducts(now).where((p) => p.storeId == id).toList();
    final reviews = state.reviews.where((r) => r.storeId == id).toList()..sort((a, b) => b.time.compareTo(a.time));
    final byService = [
      for (final s in Service.values)
        if (state.rating(storeId: id, service: s) case final r?) (s, r),
    ];
    final basket = ref.watch(basketProvider);
    final items = basket?.storeId == id ? basket!.items : const <OrderDraft>[];

    Future<void> quickAdd(String productId) async {
      final r = await showOrderSheet(context, productId, OrderType.readyMade);
      if (r == null || !context.mounted) return;
      try {
        ref.read(basketProvider.notifier).put(id, r.draft);
      } on OrderException catch (e) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l10n.orderError(e.error))));
        return;
      }
      if (r.buyNow) context.push('/order');
    }

    // Quick add for what can be ordered now; the badge shows what's already in the basket.
    Widget? addButton(Product p) {
      if (!p.canOrderNow) return null;
      final inBasket = items.where((d) => d.productId == p.id).firstOrNull;
      final scheme = Theme.of(context).colorScheme;
      return Padding(
        padding: const EdgeInsetsDirectional.only(top: KafzaSpacing.md),
        child: Badge(
          isLabelVisible: inBasket != null,
          label: Text(formatNumber(context, inBasket?.qty ?? 0)),
          backgroundColor: scheme.primary,
          textColor: scheme.onPrimary,
          child: IconButton.filledTonal(
            icon: const Icon(IconsaxPlusLinear.add),
            tooltip: inBasket == null ? l10n.addToBasket : l10n.inBasket(l10n.qty(p.unit, inBasket.qty)),
            onPressed: () => quickAdd(p.id),
          ),
        ),
      );
    }

    final header = Padding(
      padding: const EdgeInsets.all(KafzaSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            spacing: KafzaSpacing.lg,
            children: [
              SizedBox.square(dimension: 72, child: StoreAvatar(store)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: KafzaSpacing.xs,
                  children: [
                    Wrap(
                      spacing: KafzaSpacing.sm,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(isolate(store.name), style: text.titleLarge),
                        if (store.pro) KafzaBadge(l10n.badgePro),
                      ],
                    ),
                    Text(
                      l10n.communeDistance(isolate(store.commune), formatNumber(context, store.distanceKm)),
                      style: text.bodyMedium!.copyWith(color: secondary),
                    ),
                    if (rating != null) RatingLabel(rating.stars, rating.count),
                  ],
                ),
              ),
            ],
          ),
          if (!taking) ...[
            const SizedBox(height: KafzaSpacing.lg),
            InfoBanner(icon: IconsaxPlusLinear.pause_circle, text: l10n.notTakingOrders, warning: true),
          ],
          if (store.description.isNotEmpty) ...[
            const SizedBox(height: KafzaSpacing.lg),
            Text(isolate(store.description), style: text.bodyMedium),
          ],
          const SizedBox(height: KafzaSpacing.lg),
          Wrap(
            spacing: KafzaSpacing.lg,
            runSpacing: KafzaSpacing.sm,
            children: [
              _Stat(IconsaxPlusLinear.verify, l10n.reliability(ltr('${store.reliability}%'))),
              for (final (s, r) in byService)
                _Stat(serviceIcon(s), l10n.serviceRating(l10n.service(s), formatNumber(context, r.stars, decimals: 1))),
            ],
          ),
        ],
      ),
    );

    final page = DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomNavigationBar: items.isEmpty
            ? null
            : _BasketBar(
                count: items.length,
                total: draftsAmounts(state, items).total,
                onTap: () => context.push('/order'),
              ),
        appBar: AppBar(
          actions: [
            FavouriteButton(id),
            IconButton(icon: const Icon(IconsaxPlusLinear.share), tooltip: l10n.share, onPressed: () => shareLink(context, 'store/$id')),
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (_, _) => [
            SliverToBoxAdapter(child: header),
            SliverAppBar(
              pinned: true,
              primary: false,
              automaticallyImplyLeading: false,
              toolbarHeight: 0,
              bottom: TabBar(
                tabs: [Tab(text: l10n.tabProductsCount(taking ? products.length : 0)), Tab(text: l10n.tabReviewsCount(reviews.length))],
              ),
            ),
          ],
          body: TabBarView(
            children: [
              if (!taking)
                EmptyState(icon: IconsaxPlusLinear.shop, title: l10n.notTakingOrders, body: l10n.pausedStoreHint)
              else if (products.isEmpty)
                EmptyState(icon: IconsaxPlusLinear.box, title: l10n.noProducts, body: l10n.noProductsHint)
              else
                ListView.separated(
                  itemCount: products.length,
                  separatorBuilder: (_, _) => const Divider(indent: KafzaSpacing.lg, endIndent: KafzaSpacing.lg),
                  itemBuilder: (_, i) => ProductTile(products[i], inStore: true, trailing: addButton(products[i])),
                ),
              if (reviews.isEmpty)
                EmptyState(icon: IconsaxPlusLinear.message_edit, title: l10n.noReviews, body: l10n.noReviewsHint)
              else
                ListView.separated(
                  padding: const EdgeInsets.all(KafzaSpacing.lg).aboveGestureBar(context),
                  itemCount: reviews.length,
                  separatorBuilder: (_, _) => const Divider(height: KafzaSpacing.xl),
                  itemBuilder: (context, i) {
                    final r = reviews[i];
                    final titles = [for (final p in state.products) if (r.productIds.contains(p.id)) isolate(p.title)];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: KafzaSpacing.xs,
                      children: [
                        Row(
                          children: [
                            RatingStars(r.stars),
                            const Spacer(),
                            Text(
                              DateFormat.yMMMd(l10n.localeName).format(r.time),
                              style: text.bodySmall!.copyWith(color: secondary),
                            ),
                          ],
                        ),
                        if (titles.isNotEmpty)
                          Text(titles.join(l10n.listSeparator), style: text.bodySmall!.copyWith(color: secondary)),
                        if (r.comment.isNotEmpty) Text(isolate(r.comment), style: text.bodyMedium),
                      ],
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );

    // Leaving with a full basket asks first; the basket is emptied only if the client confirms.
    return PopScope(
      canPop: items.isEmpty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop || !await confirmLeaveStore(context) || !context.mounted) return;
        ref.read(basketProvider.notifier).clear();
        context.pop();
      },
      child: page,
    );
  }
}

/// The store basket in one tap: item count, View basket, the total to pay (delivery included).
class _BasketBar extends StatelessWidget {
  const _BasketBar({required this.count, required this.total, required this.onTap});

  final int count, total;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant))),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(KafzaSpacing.lg),
          child: FilledButton(
            onPressed: onTap,
            child: Row(
              spacing: KafzaSpacing.md,
              children: [
                Text(l10n.basketItems(count)),
                Expanded(child: Text(l10n.viewBasket, textAlign: TextAlign.center)),
                Text(formatPrice(context, total), style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()])),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.icon, this.label);

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        spacing: KafzaSpacing.xs,
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      );
}
