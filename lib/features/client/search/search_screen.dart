import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/clock.dart';
import '../../../core/format/price.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/order_engine/order_engine.dart';
import '../../../core/theme/kafza_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/kafza_sheet.dart';
import '../client_providers.dart';
import '../client_widgets.dart';

/// C3: search products and stores, with sort and filters (CLT-04/05).
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  void _remember() {
    final q = _query.text.trim();
    if (q.isEmpty) return;
    final recent = ref.read(recentSearchesProvider);
    ref.read(recentSearchesProvider.notifier).set([q, ...recent.where((r) => r != q)].take(5).toList());
  }

  Future<void> _openFilters() async {
    final picked = await showKafzaSheet<SearchFilters>(
      context,
      (_) => _FiltersSheet(ref.read(searchFiltersProvider)),
    );
    if (picked != null) ref.read(searchFiltersProvider.notifier).set(picked);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final state = ref.watch(orderEngineProvider);
    final now = ref.read(clockProvider);
    final f = ref.watch(searchFiltersProvider);
    final setFilters = ref.read(searchFiltersProvider.notifier).set;
    final recent = ref.watch(recentSearchesProvider);
    final products = searchProducts(state, now, _query.text, f, l10n.category);
    final stores = searchStores(state, now, _query.text, f);

    Widget results(int count, Widget list) => count > 0
        ? list
        : EmptyState(
            icon: IconsaxPlusLinear.search_status,
            title: l10n.noResults,
            body: l10n.noResultsHint,
            action: f.sheetCount > 0 || f.service != null || f.category != null ? l10n.clearFilters : null,
            onAction: () => setFilters(SearchFilters(sort: f.sort)),
          );

    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(KafzaSpacing.lg, KafzaSpacing.sm, KafzaSpacing.sm, 0),
            child: Row(
              spacing: KafzaSpacing.xs,
              children: [
                Expanded(
                  child: TextField(
                    controller: _query,
                    textInputAction: TextInputAction.search,
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) => _remember(),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(IconsaxPlusLinear.search_normal_1),
                      hintText: l10n.searchHint,
                      suffixIcon: _query.text.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(IconsaxPlusLinear.close_circle),
                              tooltip: l10n.clearSearch,
                              onPressed: () => setState(_query.clear),
                            ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Badge(
                    isLabelVisible: f.sheetCount > 0,
                    label: Text('${f.sheetCount}'),
                    child: const Icon(IconsaxPlusLinear.setting_4),
                  ),
                  tooltip: l10n.filters,
                  onPressed: _openFilters,
                ),
              ],
            ),
          ),
          // Active sort and the service/category picked on the home screen.
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsetsDirectional.fromSTEB(KafzaSpacing.lg, KafzaSpacing.sm, KafzaSpacing.lg, 0),
            child: Row(
              spacing: KafzaSpacing.sm,
              children: [
                ActionChip(
                  avatar: const Icon(IconsaxPlusLinear.arrow_swap),
                  label: Text(_sortLabel(l10n, f.sort)),
                  onPressed: _openFilters,
                ),
                if (f.service case final s?)
                  InputChip(
                    label: Text(l10n.service(s)),
                    onDeleted: () => setFilters(f.copyWith(service: () => null)),
                    deleteButtonTooltipMessage: l10n.removeFilter,
                  ),
                if (f.category case final c?)
                  InputChip(
                    label: Text(l10n.category(c)),
                    onDeleted: () => setFilters(f.copyWith(category: () => null)),
                    deleteButtonTooltipMessage: l10n.removeFilter,
                  ),
              ],
            ),
          ),
          if (_query.text.isEmpty && recent.isNotEmpty)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(KafzaSpacing.lg, KafzaSpacing.md, KafzaSpacing.sm, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(l10n.recentSearches, style: text.labelLarge)),
                      TextButton(
                        onPressed: () => ref.read(recentSearchesProvider.notifier).set(const []),
                        child: Text(l10n.clear),
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: KafzaSpacing.sm,
                    children: [
                      for (final r in recent)
                        ActionChip(
                          avatar: const Icon(IconsaxPlusLinear.clock),
                          label: Text(r),
                          onPressed: () => setState(() => _query.text = r),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          TabBar(
            tabs: [
              Tab(text: l10n.tabProductsCount(products.length)),
              Tab(text: l10n.tabStoresCount(stores.length)),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                results(
                  products.length,
                  ListView.separated(
                    itemCount: products.length,
                    separatorBuilder: (_, _) => const Divider(indent: KafzaSpacing.lg, endIndent: KafzaSpacing.lg),
                    itemBuilder: (_, i) => ProductTile(products[i]),
                  ),
                ),
                results(
                  stores.length,
                  ListView.separated(
                    itemCount: stores.length,
                    separatorBuilder: (_, _) => const Divider(indent: KafzaSpacing.lg, endIndent: KafzaSpacing.lg),
                    itemBuilder: (_, i) => StoreTile(stores[i]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _sortLabel(AppLocalizations l10n, SearchSort s) => switch (s) {
      SearchSort.closest => l10n.sortClosest,
      SearchSort.rating => l10n.sortRating,
      SearchSort.price => l10n.sortPrice,
      SearchSort.prepTime => l10n.sortPrepTime,
    };

/// Sort and filters. Edits a draft; "Show results" returns it.
class _FiltersSheet extends ConsumerStatefulWidget {
  const _FiltersSheet(this.initial);

  final SearchFilters initial;

  @override
  ConsumerState<_FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends ConsumerState<_FiltersSheet> {
  late SearchFilters _f = widget.initial;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final state = ref.watch(orderEngineProvider);
    final wilayas = {for (final s in state.listedStores) s.wilaya}.toList()..sort();
    // Slider bounds from the catalogue, rounded up to the next 1 000 DZD.
    final maxPrice = ((state.listedProducts(ref.read(clockProvider)).fold(0, (m, p) => p.displayPrice > m ? p.displayPrice : m) /
                    1000)
                .ceil() *
            1000)
        .toDouble();
    final price = _f.price ?? RangeValues(0, maxPrice);

    Widget section(String title, Widget child) => Padding(
          padding: const EdgeInsetsDirectional.only(top: KafzaSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: KafzaSpacing.sm,
            children: [Text(title, style: text.titleMedium), child],
          ),
        );
    Widget choice(String label, bool selected, VoidCallback onTap, {Widget? avatar}) => ChoiceChip(
          label: Text(label),
          avatar: avatar,
          showCheckmark: false,
          selected: selected,
          onSelected: (_) => setState(onTap),
        );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: KafzaSpacing.lg),
          child: Text(l10n.filters, style: text.titleLarge),
        ),
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: KafzaSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                section(
                  l10n.sortBy,
                  Wrap(spacing: KafzaSpacing.sm, runSpacing: KafzaSpacing.sm, children: [
                    for (final s in SearchSort.values)
                      choice(_sortLabel(l10n, s), _f.sort == s, () => _f = _f.copyWith(sort: s)),
                  ]),
                ),
                section(
                  l10n.filterWilaya,
                  Wrap(spacing: KafzaSpacing.sm, runSpacing: KafzaSpacing.sm, children: [
                    choice(l10n.all, _f.wilaya == null, () => _f = _f.copyWith(wilaya: () => null)),
                    for (final w in wilayas) choice(w, _f.wilaya == w, () => _f = _f.copyWith(wilaya: () => w)),
                  ]),
                ),
                section(
                  l10n.filterAvailability,
                  Column(children: [
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.filterAvailableNow),
                      value: _f.availableNow,
                      onChanged: (v) => setState(() => _f = _f.copyWith(availableNow: v)),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.filterMadeToOrder),
                      value: _f.madeToOrder,
                      onChanged: (v) => setState(() => _f = _f.copyWith(madeToOrder: v)),
                    ),
                  ]),
                ),
                section(
                  l10n.filterMinRating,
                  Wrap(spacing: KafzaSpacing.sm, runSpacing: KafzaSpacing.sm, children: [
                    choice(l10n.all, _f.minRating == 0, () => _f = _f.copyWith(minRating: 0)),
                    for (final r in [3.0, 4.0, 4.5])
                      choice(
                        ltr('${formatNumber(context, r)}+'),
                        _f.minRating == r,
                        () => _f = _f.copyWith(minRating: r),
                        avatar: Icon(IconsaxPlusBold.star_1, color: context.kafza.warning),
                      ),
                  ]),
                ),
                section(
                  l10n.filterPrice,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.priceRange(formatPrice(context, price.start), formatPrice(context, price.end)),
                        style: text.bodyMedium,
                      ),
                      RangeSlider(
                        values: price,
                        max: maxPrice,
                        divisions: (maxPrice / 500).round(),
                        onChanged: (v) => setState(() => _f = _f.copyWith(
                              price: () => v.start == 0 && v.end == maxPrice ? null : v,
                            )),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: KafzaSpacing.lg),
              ],
            ),
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(KafzaSpacing.lg),
          child: Row(
            spacing: KafzaSpacing.md,
            children: [
              TextButton(
                onPressed: () => setState(() => _f = SearchFilters(service: _f.service, category: _f.category)),
                child: Text(l10n.reset),
              ),
              Expanded(
                child: FilledButton(onPressed: () => Navigator.pop(context, _f), child: Text(l10n.showResults)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
