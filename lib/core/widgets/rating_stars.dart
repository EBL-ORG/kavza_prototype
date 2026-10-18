import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../format/price.dart';
import '../l10n/app_localizations.dart';
import '../theme/kafza_theme.dart';

/// Compact rating: star, average, (count).
class RatingLabel extends StatelessWidget {
  const RatingLabel(this.stars, this.count, {super.key});

  final double stars;
  final int count;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final average = formatNumber(context, stars, decimals: 1);
    return Semantics(
      label: AppLocalizations.of(context).ratingSemantics(average, count),
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: KafzaSpacing.xs,
        children: [
          Icon(IconsaxPlusBold.star_1, size: 18, color: context.kafza.warning),
          Text(average, style: text.labelLarge),
          Text(
            ltr('($count)'),
            style: text.bodySmall!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

/// Five stars for one review.
class RatingStars extends StatelessWidget {
  const RatingStars(this.value, {super.key, this.size = 16});

  final int value;
  final double size;

  @override
  Widget build(BuildContext context) => Semantics(
        label: AppLocalizations.of(context).starsSemantics(value),
        excludeSemantics: true,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 1; i <= 5; i++)
              Icon(
                i <= value ? IconsaxPlusBold.star_1 : IconsaxPlusLinear.star_1,
                size: size,
                color: i <= value ? context.kafza.warning : Theme.of(context).colorScheme.outline,
              ),
          ],
        ),
      );
}

/// Tappable stars (1–5) for writing a review.
class RatingInput extends StatelessWidget {
  const RatingInput({super.key, required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 1; i <= 5; i++)
          IconButton(
            iconSize: 36,
            tooltip: l10n.starsSemantics(i),
            isSelected: i <= value,
            icon: Icon(IconsaxPlusLinear.star_1, color: Theme.of(context).colorScheme.onSurfaceVariant),
            selectedIcon: Icon(IconsaxPlusBold.star_1, color: context.kafza.warning),
            onPressed: () => onChanged(i),
          ),
      ],
    );
  }
}
