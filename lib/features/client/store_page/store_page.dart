import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../core/data/clock.dart';
import '../../../core/format/price.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/models/catalog.dart';
import '../../../core/order_engine/order_engine.dart';
import '../../../core/theme/kafza_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/info_banner.dart';
import '../../../core/widgets/initial_image.dart';
import '../../../core/widgets/kafza_badge.dart';
import '../../../core/widgets/rating_stars.dart';
import '../client_widgets.dart';

/// C4: store page. Commune and approximate distance only, never an address (CLT-07).
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

    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
                  itemBuilder: (_, i) => ProductTile(products[i], showStore: false),
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
                    final product = state.products.where((p) => p.id == r.productId).firstOrNull;
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
                        if (product != null) Text(isolate(product.title), style: text.bodySmall!.copyWith(color: secondary)),
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
