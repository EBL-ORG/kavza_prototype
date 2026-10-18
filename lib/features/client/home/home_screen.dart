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
import '../../../core/models/catalog.dart';
import '../../../core/order_engine/order_engine.dart';
import '../../../core/theme/kafza_theme.dart';
import '../../../core/widgets/info_banner.dart';
import '../../../core/widgets/kafza_sheet.dart';
import '../../../core/widgets/skeleton_box.dart';
import '../client_providers.dart';
import '../client_widgets.dart';

/// C2: Kafza home (CLT-03).
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    ref.read(fakeDelayProvider)().then((_) {
      if (mounted) setState(() => _loading = false);
    });
  }

  /// Opens Search with one service or category already applied.
  void _browse({Service? service, Category? category}) {
    ref.read(searchFiltersProvider.notifier).set(SearchFilters(service: service, category: category));
    StatefulNavigationShell.of(context).goBranch(1);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final state = ref.watch(orderEngineProvider);
    // Rebuild once a minute (countdown), not on every clock tick.
    ref.watch(clockProvider.select((t) => t.millisecondsSinceEpoch ~/ 60000));
    final now = ref.read(clockProvider);
    final client = state.client(demoClientId);
    final address = client.addresses.firstWhere(
      (a) => a.id == ref.watch(addressIdProvider),
      orElse: () => client.addresses.first,
    );
    final waiting = state.waitingOrder(demoClientId);
    final listed = state.listedProducts(now);
    final newest = ([...listed]..sort((a, b) => b.createdAt.compareTo(a.createdAt))).take(8).toList();
    final popular = ([...listed]..sort((a, b) => b.sold.compareTo(a.sold))).take(8).toList();
    final nearby = ([...state.listedStores]..sort((a, b) => a.distanceKm.compareTo(b.distanceKm))).take(3);

    Widget heading(String title) => Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(KafzaSpacing.lg, KafzaSpacing.xl, KafzaSpacing.lg, KafzaSpacing.sm),
          child: Text(title, style: text.titleLarge),
        );
    const pad = EdgeInsetsDirectional.symmetric(horizontal: KafzaSpacing.lg);

    // Horizontal rows size to their content (IntrinsicHeight), so cards hold at text scale 1.3.
    Widget carousel(List<Widget> children) => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: pad,
          child: IntrinsicHeight(
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, spacing: KafzaSpacing.md, children: children),
          ),
        );

    return RefreshIndicator(
      onRefresh: () => ref.read(fakeDelayProvider)(),
      child: ListView(
        padding: const EdgeInsetsDirectional.only(top: KafzaSpacing.sm, bottom: KafzaSpacing.xl),
        children: [
          // Yassir's location header: small label with the pink chevron, the place under it.
          InkWell(
            onTap: () => showKafzaSheet<void>(context, (_) => const AddressSheet()),
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: KafzaSpacing.lg, vertical: KafzaSpacing.xs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(l10n.deliverToLabel, style: text.bodySmall!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                      Icon(IconsaxPlusLinear.arrow_down, size: 18, color: context.kafza.accent),
                    ],
                  ),
                  Text(isolate('${address.label} · ${address.commune}'), style: text.titleMedium),
                ],
              ),
            ),
          ),
          const SizedBox(height: KafzaSpacing.md),
          Padding(
            padding: pad,
            child: TextField(
              readOnly: true,
              onTap: () => StatefulNavigationShell.of(context).goBranch(1),
              decoration: InputDecoration(prefixIcon: const Icon(IconsaxPlusLinear.search_normal_1), hintText: l10n.searchHint),
            ),
          ),
          if (waiting != null) ...[
            const SizedBox(height: KafzaSpacing.md),
            Padding(
              padding: pad,
              child: InfoBanner(
                icon: IconsaxPlusLinear.timer_1,
                text: l10n.waitingBanner(formatDuration(l10n, waiting.deadline.difference(now))),
                onTap: () => context.go('/kafza/orders/${waiting.id}'),
              ),
            ),
          ],
          if (_loading)
            ..._skeleton()
          else ...[
            heading(l10n.servicesTitle),
            Padding(
              padding: pad,
              child: Row(
                spacing: KafzaSpacing.md,
                children: [
                  for (final s in Service.values)
                    Expanded(child: ServiceTile(emoji: s.name, label: l10n.service(s), onTap: () => _browse(service: s))),
                ],
              ),
            ),
            heading(l10n.categoriesTitle),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: pad,
              child: Row(
                spacing: KafzaSpacing.sm,
                children: [
                  for (final c in Category.values)
                    ActionChip(label: Text(l10n.category(c)), onPressed: () => _browse(category: c)),
                ],
              ),
            ),
            heading(l10n.nearbyStores),
            for (final s in nearby) StoreTile(s),
            heading(l10n.newProducts),
            carousel([for (final p in newest) ProductCard(p)]),
            heading(l10n.popularProducts),
            carousel([for (final p in popular) ProductCard(p)]),
          ],
        ],
      ),
    );
  }

  List<Widget> _skeleton() => [
        const SizedBox(height: KafzaSpacing.xl),
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: KafzaSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: KafzaSpacing.md,
            children: [
              const SkeletonBox(width: 120, height: 20),
              const Row(
                spacing: KafzaSpacing.md,
                children: [
                  Expanded(child: SkeletonBox(height: 88, radius: KafzaRadius.card)),
                  Expanded(child: SkeletonBox(height: 88, radius: KafzaRadius.card)),
                  Expanded(child: SkeletonBox(height: 88, radius: KafzaRadius.card)),
                ],
              ),
              const SizedBox(height: KafzaSpacing.md),
              const SkeletonBox(width: 160, height: 20),
              for (var i = 0; i < 3; i++)
                const Row(
                  spacing: KafzaSpacing.md,
                  children: [
                    SkeletonBox(width: 48, height: 48, radius: 24),
                    Expanded(child: SkeletonBox(height: 40)),
                  ],
                ),
              const SizedBox(height: KafzaSpacing.md),
              const SkeletonBox(width: 120, height: 20),
              const Row(
                spacing: KafzaSpacing.md,
                children: [SkeletonBox(width: 160, height: 120), SkeletonBox(width: 160, height: 120)],
              ),
            ],
          ),
        ),
      ];
}
