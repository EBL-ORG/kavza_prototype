import 'package:flutter/material.dart';

import '../theme/kafza_theme.dart';

/// Inline notice on primary-light (info) or warning-light (warning). Tappable when [onTap] is set.
class InfoBanner extends StatelessWidget {
  const InfoBanner({super.key, required this.icon, required this.text, this.warning = false, this.onTap});

  final IconData icon;
  final String text;
  final bool warning;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fg = warning ? context.kafza.warning : scheme.primary;
    return Material(
      color: warning ? context.kafza.warningLight : scheme.primaryContainer,
      borderRadius: BorderRadius.circular(KafzaRadius.card),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(KafzaRadius.card),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: KafzaSpacing.lg, vertical: KafzaSpacing.md),
            child: Row(
              spacing: KafzaSpacing.md,
              children: [
                Icon(icon, color: fg, size: 20),
                Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
                if (onTap != null) Icon(KafzaIcons.chevronEnd, color: fg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
