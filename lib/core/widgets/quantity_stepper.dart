import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../l10n/app_localizations.dart';
import '../theme/kafza_theme.dart';

/// − value +. Never goes below [min], above [max] or off [step] (decimals work: 0.5 kg).
/// The Row follows Directionality, so it mirrors in Arabic.
class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.value,
    required this.label,
    required this.onChanged,
    this.min = 1,
    this.max,
    this.step = 1,
  });

  final num value, min, step;
  final num? max;

  /// The formatted value ("1,5 kg").
  final String label;
  final ValueChanged<num> onChanged;

  /// 1.0 → 1, so whole quantities stay ints.
  static num _clean(num v) => v == v.roundToDouble() ? v.round() : v;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const eps = 1e-9;
    final down = value - step, up = value + step;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.outlined(
          tooltip: l10n.decrease,
          icon: const Icon(IconsaxPlusLinear.minus),
          onPressed: down >= min - eps ? () => onChanged(_clean(down)) : null,
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 88),
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: KafzaSpacing.sm),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
            ),
          ),
        ),
        IconButton.outlined(
          tooltip: l10n.increase,
          icon: const Icon(IconsaxPlusLinear.add),
          onPressed: max == null || up <= max! + eps ? () => onChanged(_clean(up)) : null,
        ),
      ],
    );
  }
}
