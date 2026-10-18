import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../format/price.dart';
import '../format/time.dart';
import '../l10n/app_localizations.dart';
import '../l10n/labels.dart';
import '../models/product.dart';
import '../models/store.dart';
import '../theme/kafza_theme.dart';
import 'initial_image.dart';
import 'kafza_badge.dart';
import 'rating_stars.dart';

/// Product content as the client sees it (C5). Also the store editor's preview (S9), so it
/// reads nothing from providers. The caller adds the app bar, scrolling and the order buttons.
class ProductDetailView extends StatelessWidget {
  const ProductDetailView({
    super.key,
    required this.product,
    required this.store,
    this.rating,
    this.storeRating,
    this.onStoreTap,
  });

  final Product product;
  final Store store;
  final ({double stars, int count})? rating, storeRating;
  final VoidCallback? onStoreTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final secondary = Theme.of(context).colorScheme.onSurfaceVariant;
    final p = product;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Carousel(title: p.title, id: p.id, photos: p.photos < 1 ? 1 : p.photos),
        Padding(
          padding: const EdgeInsets.all(KafzaSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(isolate(p.title), style: text.titleLarge),
              if (rating case final r?) ...[
                const SizedBox(height: KafzaSpacing.xs),
                Align(alignment: AlignmentDirectional.centerStart, child: RatingLabel(r.stars, r.count)),
              ],
              const SizedBox(height: KafzaSpacing.md),
              _StoreRow(store: store, rating: storeRating, onTap: onStoreTap),
              if (p.freeDelivery) ...[
                const SizedBox(height: KafzaSpacing.md),
                _Line(IconsaxPlusLinear.truck, l10n.freeDelivery),
              ],
              if (p.description.isNotEmpty) ...[
                const SizedBox(height: KafzaSpacing.lg),
                Text(isolate(p.description), style: text.bodyLarge),
              ],
              if (p.category.isFood && p.ingredients.isNotEmpty) ...[
                const SizedBox(height: KafzaSpacing.xl),
                Text(l10n.ingredients, style: text.titleMedium),
                const SizedBox(height: KafzaSpacing.xs),
                Text(isolate(p.ingredients), style: text.bodyMedium!.copyWith(color: secondary)),
              ],
              if (p.readyMade case final rm?) ...[
                const SizedBox(height: KafzaSpacing.xl),
                _Block(
                  title: l10n.readyMadeTitle,
                  price: l10n.pricePerUnit(formatPrice(context, rm.price), l10n.unit(p.unit)),
                  lines: [
                    if (p.fewLeft)
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: KafzaBadge(l10n.fewLeft, tone: BadgeTone.warning),
                      )
                    else
                      _Line(
                        IconsaxPlusLinear.box,
                        p.canOrderNow ? l10n.inStock(l10n.qty(p.unit, rm.available)) : l10n.outOfStock,
                      ),
                    _Line(IconsaxPlusLinear.clock, l10n.readyIn(formatDuration(l10n, rm.prepTime))),
                  ],
                ),
              ],
              if (p.madeToOrder case final m?) ...[
                const SizedBox(height: KafzaSpacing.md),
                _Block(
                  title: l10n.madeToOrderTitle,
                  price: l10n.pricePerUnit(formatPrice(context, m.price), l10n.unit(p.unit)),
                  lines: [
                    if (m.minQty != 1 || m.step != 1 || m.maxQty != null)
                      _Line(
                        IconsaxPlusLinear.weight,
                        [
                          if (m.minQty != 1 || m.step != 1) l10n.ruleMin(l10n.qty(p.unit, m.minQty)),
                          if (m.step != 1) l10n.ruleStep(l10n.qty(p.unit, m.step)),
                          if (m.maxQty case final max?) l10n.ruleMax(l10n.qty(p.unit, max)),
                        ].join(l10n.listSeparator),
                      ),
                    _Line(IconsaxPlusLinear.calendar_1, l10n.ruleLead(formatDuration(l10n, m.leadTime))),
                    _Line(
                      IconsaxPlusLinear.calendar_2,
                      m.availableDays.length == 7
                          ? l10n.ruleEveryDay
                          : l10n.ruleDays(formatWeekdays(l10n, m.availableDays)),
                    ),
                    _Line(IconsaxPlusLinear.clock, l10n.preparedIn(formatDuration(l10n, m.prepTime))),
                    if (m.optionGroups.isNotEmpty)
                      _Line(
                        IconsaxPlusLinear.setting_4,
                        l10n.ruleOptions(m.optionGroups.map((g) => isolate(g.name)).join(l10n.listSeparator)),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Carousel extends StatefulWidget {
  const _Carousel({required this.title, required this.id, required this.photos});

  final String title, id;
  final int photos;

  @override
  State<_Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<_Carousel> {
  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      label: AppLocalizations.of(context).photoOf(_page + 1, widget.photos),
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: Stack(
          children: [
            // PageView follows Directionality, so swiping mirrors in Arabic.
            PageView.builder(
              controller: _controller,
              itemCount: widget.photos,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (_, i) => InitialImage(widget.title, id: widget.id, page: i, radius: 0),
            ),
            if (widget.photos > 1)
              PositionedDirectional(
                start: 0,
                end: 0,
                bottom: KafzaSpacing.md,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: KafzaSpacing.xs,
                  children: [
                    for (var i = 0; i < widget.photos; i++)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOutCubic,
                        width: i == _page ? 20 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == _page ? scheme.primary : scheme.onSurfaceVariant.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StoreRow extends StatelessWidget {
  const _StoreRow({required this.store, this.rating, this.onTap});

  final Store store;
  final ({double stars, int count})? rating;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return Material(
      color: context.kafza.muted,
      borderRadius: BorderRadius.circular(KafzaRadius.input),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(KafzaRadius.input),
        child: Padding(
          padding: const EdgeInsets.all(KafzaSpacing.md),
          child: Row(
            spacing: KafzaSpacing.md,
            children: [
              SizedBox.square(dimension: 40, child: StoreAvatar(store)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(isolate(store.name), style: text.labelLarge),
                    Text(
                      l10n.communeDistance(isolate(store.commune), formatNumber(context, store.distanceKm)),
                      style: text.bodySmall!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              if (rating case final r?) RatingLabel(r.stars, r.count),
              if (onTap != null) const Icon(KafzaIcons.chevronEnd),
            ],
          ),
        ),
      ),
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({required this.title, required this.price, required this.lines});

  final String title, price;
  final List<Widget> lines;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(KafzaSpacing.lg),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(KafzaRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: KafzaSpacing.sm,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            spacing: KafzaSpacing.sm,
            children: [
              Expanded(child: Text(title, style: text.titleMedium)),
              Text(
                price,
                style: text.titleMedium!.copyWith(
                  fontWeight: FontWeight.w700,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          ...lines,
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line(this.icon, this.text);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: KafzaSpacing.sm,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.onSurfaceVariant),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      );
}
