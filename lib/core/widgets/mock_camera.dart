import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../l10n/app_localizations.dart';
import '../theme/kafza_theme.dart';

/// Live camera stand-in (STR-02/03): a viewfinder with a card rectangle or a face oval, and a
/// shutter. There is deliberately no gallery button: documents and the selfie must be live.
/// The parent owns [captured].
class MockCamera extends StatelessWidget {
  const MockCamera({super.key, required this.face, required this.captured, required this.onChanged});

  final bool face, captured;

  /// true after the shutter, false on Retake.
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final frame = BorderSide(color: scheme.surface, width: 2);

    final viewfinder = captured
        ? ColoredBox(
            color: context.kafza.muted,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: KafzaSpacing.sm,
              children: [
                Icon(face ? IconsaxPlusLinear.user : IconsaxPlusLinear.personalcard, size: 56, color: scheme.onSurfaceVariant),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: KafzaSpacing.xs,
                  children: [
                    Icon(IconsaxPlusBold.tick_circle, size: 20, color: context.kafza.success),
                    Text(l10n.photoTaken, style: text.labelLarge),
                  ],
                ),
              ],
            ),
          )
        : ColoredBox(
            // The viewfinder is dark like a real camera; `onSurface` is the darkest token.
            color: scheme.onSurface,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: KafzaSpacing.md,
              children: [
                Container(
                  width: face ? 150 : 240,
                  height: face ? 190 : 150,
                  decoration: ShapeDecoration(
                    shape: face
                        ? OvalBorder(side: frame)
                        : RoundedRectangleBorder(borderRadius: BorderRadius.circular(KafzaRadius.input), side: frame),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: KafzaSpacing.lg),
                  child: Text(
                    face ? l10n.cameraFaceHint : l10n.cameraCardHint,
                    textAlign: TextAlign.center,
                    style: text.bodyMedium!.copyWith(color: scheme.surface),
                  ),
                ),
              ],
            ),
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: KafzaSpacing.md,
      children: [
        Semantics(
          label: captured ? l10n.photoTaken : (face ? l10n.cameraFaceHint : l10n.cameraCardHint),
          excludeSemantics: true,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(KafzaRadius.card),
            child: SizedBox(height: 280, child: viewfinder),
          ),
        ),
        Center(
          child: captured
              ? TextButton.icon(
                  onPressed: () => onChanged(false),
                  icon: const Icon(IconsaxPlusLinear.refresh),
                  label: Text(l10n.retake),
                )
              : IconButton.filled(
                  iconSize: 32,
                  padding: const EdgeInsets.all(KafzaSpacing.md),
                  tooltip: l10n.takePhoto,
                  icon: const Icon(IconsaxPlusLinear.camera),
                  onPressed: () => onChanged(true),
                ),
        ),
      ],
    );
  }
}
