import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/clock.dart';
import '../../core/data/seed.dart';
import '../../core/format/price.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/l10n/labels.dart';
import '../../core/models/catalog.dart';
import '../../core/models/product.dart';
import '../../core/models/store.dart';
import '../../core/order_engine/order_engine.dart';
import '../../core/theme/kafza_theme.dart';
import '../../core/widgets/initial_image.dart';
import '../../core/widgets/kafza_badge.dart';
import '../../core/widgets/rating_stars.dart';
import 'client_providers.dart';

IconData serviceIcon(Service s) => switch (s) {
      Service.cooking => IconsaxPlusLinear.cake,
      Service.sewing => IconsaxPlusLinear.scissor,
      Service.crafts => IconsaxPlusLinear.brush_1,
    };

/// The one state badge a product card shows, if any.
Widget? _stateBadge(AppLocalizations l10n, Product p) {
  if (p.fewLeft) return KafzaBadge(l10n.fewLeft, tone: BadgeTone.warning);
  if (!p.canOrderNow && p.madeToOrder != null) return KafzaBadge(l10n.madeToOrderTitle);
  if (!p.canOrderNow) return KafzaBadge(l10n.currentlyUnavailable, tone: BadgeTone.neutral);
  return null;
}

TextStyle _priceStyle(BuildContext context) =>
    Theme.of(context).textTheme.labelLarge!.copyWith(fontFeatures: const [FontFeature.tabularFigures()]);

TextStyle _metaStyle(BuildContext context) =>
    Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant);

String _price(BuildContext context, Product p) {
  final l10n = AppLocalizations.of(context);
  return l10n.pricePerUnit(formatPrice(context, p.displayPrice), l10n.unit(p.unit));
}

/// Vertical card for the home carousels. Sized by its content, so it holds at text scale 1.3.
class ProductCard extends ConsumerWidget {
  const ProductCard(this.product, {super.key});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final store = ref.watch(orderEngineProvider.select((s) => s.store(product.storeId)));
    final badge = _stateBadge(l10n, product);
    return SizedBox(
      width: 160,
      child: InkWell(
        onTap: () => context.push('/product/${product.id}'),
        borderRadius: BorderRadius.circular(KafzaRadius.input),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 120, width: 160, child: InitialImage(product.title, id: product.id)),
            const SizedBox(height: KafzaSpacing.sm),
            Text(isolate(product.title), maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium),
            Text(_price(context, product), style: _priceStyle(context)),
            Text(isolate(store.name), maxLines: 1, overflow: TextOverflow.ellipsis, style: _metaStyle(context)),
            if (badge != null) ...[const SizedBox(height: KafzaSpacing.xs), badge],
          ],
        ),
      ),
    );
  }
}

/// Row for product lists (search, store page, favourites).
class ProductTile extends ConsumerWidget {
  const ProductTile(this.product, {super.key, this.showStore = true});

  final Product product;
  final bool showStore;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final store = ref.watch(orderEngineProvider.select((s) => s.store(product.storeId)));
    final badge = _stateBadge(l10n, product);
    return InkWell(
      onTap: () => context.push('/product/${product.id}'),
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: KafzaSpacing.lg, vertical: KafzaSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: KafzaSpacing.md,
          children: [
            SizedBox.square(dimension: 72, child: InitialImage(product.title, id: product.id)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  Text(isolate(product.title), style: Theme.of(context).textTheme.bodyLarge),
                  if (showStore)
                    Text(
                      l10n.storeDistance(isolate(store.name), formatNumber(context, store.distanceKm)),
                      style: _metaStyle(context),
                    ),
                  Text(_price(context, product), style: _priceStyle(context)),
                  if (badge != null) ...[const SizedBox(height: 2), badge],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Row for store lists: initial, name, commune + distance (never an address), rating.
class StoreTile extends ConsumerWidget {
  const StoreTile(this.store, {super.key});

  final Store store;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final rating = ref.watch(orderEngineProvider.select((s) => s.rating(storeId: store.id)));
    final taking = ref.watch(orderEngineProvider.select((s) => s.takingOrders(store, ref.read(clockProvider))));
    return InkWell(
      onTap: () => context.push('/store/${store.id}'),
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: KafzaSpacing.lg, vertical: KafzaSpacing.md),
        child: Row(
          spacing: KafzaSpacing.md,
          children: [
            SizedBox.square(dimension: 48, child: StoreAvatar(store)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  Text(isolate(store.name), style: Theme.of(context).textTheme.bodyLarge),
                  Text(
                    l10n.communeDistance(isolate(store.commune), formatNumber(context, store.distanceKm)),
                    style: _metaStyle(context),
                  ),
                  if (!taking)
                    KafzaBadge(l10n.notTakingOrders, tone: BadgeTone.neutral)
                  else if (rating != null)
                    RatingLabel(rating.stars, rating.count),
                ],
              ),
            ),
            const Icon(KafzaIcons.chevronEnd),
          ],
        ),
      ),
    );
  }
}

/// Yassir Cash balance as Yassir Pay's dark card, with optional round [actions] at the end.
/// When it can't cover the total it turns error-light with "Missing X" and a recharge button.
class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key, required this.balance, this.missing = 0, this.onRecharge, this.actions = const []});

  final int balance, missing;
  final VoidCallback? onRecharge;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final k = context.kafza;
    final short = missing > 0;
    final amount = Text(
      formatPrice(context, balance),
      style: text.headlineMedium!.copyWith(
        color: short ? null : scheme.onPrimary,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
    if (!short) {
      return Container(
        padding: const EdgeInsetsDirectional.fromSTEB(KafzaSpacing.lg, KafzaSpacing.lg, KafzaSpacing.md, KafzaSpacing.lg),
        decoration: BoxDecoration(color: k.ink, borderRadius: BorderRadius.circular(KafzaRadius.card)),
        child: Row(
          spacing: KafzaSpacing.sm,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: KafzaSpacing.xs,
                children: [
                  Text(l10n.yassirCash, style: text.bodySmall!.copyWith(color: k.onInkSecondary)),
                  Row(
                    spacing: KafzaSpacing.sm,
                    children: [
                      Icon(IconsaxPlusLinear.wallet, size: 20, color: k.onInkSecondary),
                      Flexible(child: amount),
                    ],
                  ),
                ],
              ),
            ),
            ...actions,
          ],
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(KafzaSpacing.lg),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        border: Border.all(color: scheme.error),
        borderRadius: BorderRadius.circular(KafzaRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: KafzaSpacing.xs,
        children: [
          Row(
            spacing: KafzaSpacing.sm,
            children: [
              Icon(IconsaxPlusLinear.wallet, color: scheme.error),
              Expanded(child: Text(l10n.yassirCash, style: text.labelLarge)),
            ],
          ),
          amount,
          Text(l10n.missingAmount(formatPrice(context, missing)), style: text.labelLarge!.copyWith(color: scheme.error)),
          const SizedBox(height: KafzaSpacing.sm),
          OutlinedButton.icon(
            onPressed: onRecharge,
            icon: const Icon(IconsaxPlusLinear.add),
            label: Text(l10n.rechargeCcp),
            style: OutlinedButton.styleFrom(backgroundColor: scheme.surface),
          ),
        ],
      ),
    );
  }
}

/// Copies a share link and confirms with a SnackBar.
void shareLink(BuildContext context, String path) {
  Clipboard.setData(ClipboardData(text: 'kafza://$path'));
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).linkCopied)));
}

/// Heart toggle for a product or store id.
class FavouriteButton extends ConsumerWidget {
  const FavouriteButton(this.id, {super.key});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final saved = ref.watch(favouritesProvider.select((f) => f.contains(id)));
    return IconButton(
      isSelected: saved,
      icon: const Icon(IconsaxPlusLinear.heart),
      selectedIcon: Icon(IconsaxPlusBold.heart, color: Theme.of(context).colorScheme.primary),
      tooltip: saved ? l10n.removeFavourite : l10n.addFavourite,
      onPressed: () => ref.read(favouritesProvider.notifier).toggle(id),
    );
  }
}

/// Picks the delivery address (the client's own, so the street shows here).
class AddressSheet extends ConsumerWidget {
  const AddressSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final addresses = ref.watch(orderEngineProvider.select((s) => s.client(demoClientId).addresses));
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: KafzaSpacing.lg),
            child: Text(l10n.chooseAddress, style: Theme.of(context).textTheme.titleMedium),
          ),
          const SizedBox(height: KafzaSpacing.sm),
          RadioGroup<String>(
            groupValue: ref.watch(addressIdProvider),
            onChanged: (id) {
              ref.read(addressIdProvider.notifier).set(id!);
              Navigator.pop(context);
            },
            child: Column(
              children: [
                for (final a in addresses)
                  RadioListTile<String>(
                    value: a.id,
                    title: Text(isolate(a.label)),
                    subtitle: Text(isolate('${a.street}, ${a.commune}')),
                  ),
              ],
            ),
          ),
          const SizedBox(height: KafzaSpacing.lg),
        ],
      ),
    );
  }
}

/// Yassir's lavender service tile: a 3D emoji (assets/emoji/[emoji].png), the name under it.
class ServiceTile extends StatelessWidget {
  const ServiceTile({super.key, required this.emoji, required this.label, required this.onTap});

  final String emoji;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.primaryContainer,
      borderRadius: BorderRadius.circular(KafzaRadius.card),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(KafzaRadius.card),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: KafzaSpacing.md, horizontal: KafzaSpacing.xs),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: KafzaSpacing.sm,
            children: [
              Image.asset('assets/emoji/$emoji.png', width: 52, height: 52, excludeFromSemantics: true),
              Text(label, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.labelLarge),
            ],
          ),
        ),
      ),
    );
  }
}
