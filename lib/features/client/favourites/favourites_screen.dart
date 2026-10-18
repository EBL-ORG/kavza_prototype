import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/clock.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/order_engine/order_engine.dart';
import '../../../core/theme/kafza_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../client_providers.dart';
import '../client_widgets.dart';

/// C11: saved products and stores (CLT-08). Paused products stay hidden, like in every list.
class FavouritesScreen extends ConsumerWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(orderEngineProvider);
    final saved = ref.watch(favouritesProvider);
    final products = state.listedProducts(ref.read(clockProvider)).where((p) => saved.contains(p.id)).toList();
    final stores = state.listedStores.where((s) => saved.contains(s.id)).toList();

    Widget list(List<Widget> tiles) => tiles.isEmpty
        ? EmptyState(
            icon: IconsaxPlusLinear.heart,
            title: l10n.emptyFavourites,
            body: l10n.emptyFavouritesHint,
            action: l10n.browse,
            onAction: () => StatefulNavigationShell.of(context).goBranch(0),
          )
        : ListView.separated(
            itemCount: tiles.length,
            separatorBuilder: (_, _) => const Divider(indent: KafzaSpacing.lg, endIndent: KafzaSpacing.lg),
            itemBuilder: (_, i) => tiles[i],
          );

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabs: [Tab(text: l10n.tabProductsCount(products.length)), Tab(text: l10n.tabStoresCount(stores.length))],
          ),
          Expanded(
            child: TabBarView(
              children: [
                list([for (final p in products) ProductTile(p)]),
                list([for (final s in stores) StoreTile(s)]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
