import 'package:flutter/material.dart';

import '../theme/kafza_theme.dart';

enum BadgeTone { primary, solid, neutral, warning, success }

/// Small pill label: "New", "Pro", "Ready-made", "Made to order", "Only a few left".
class KafzaBadge extends StatelessWidget {
  const KafzaBadge(this.label, {super.key, this.tone = BadgeTone.primary, this.icon});

  final String label;
  final BadgeTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final k = context.kafza;
    // Success text stays `text` colour: #12A150 is too light for small text (DESIGN.md).
    final (bg, fg) = switch (tone) {
      BadgeTone.primary => (scheme.primaryContainer, scheme.primary),
      BadgeTone.solid => (scheme.primary, scheme.onPrimary),
      BadgeTone.neutral => (k.muted, scheme.onSurfaceVariant),
      BadgeTone.warning => (k.warningLight, k.warning),
      BadgeTone.success => (k.successLight, scheme.onSurface),
    };
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: KafzaSpacing.sm, vertical: 2),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: KafzaSpacing.xs,
        children: [
          if (icon != null) Icon(icon, size: 14, color: tone == BadgeTone.success ? k.success : fg),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall!.copyWith(color: fg, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
