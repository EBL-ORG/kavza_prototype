import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../data/clock.dart';

/// A 390×844 phone screen with a status bar showing the simulated clock.
/// The child sees a 390-wide MediaQuery, so it lays out like on a real phone.
class PhoneFrame extends ConsumerWidget {
  const PhoneFrame({super.key, required this.child});

  final Widget child;

  static const screen = Size(390, 844);
  static const _statusBar = 32.0;
  static const _bezel = 10.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final now = ref.watch(clockProvider);
    final iconColor = scheme.onSurface;

    return Container(
      width: screen.width + 2 * _bezel,
      height: screen.height + 2 * _bezel,
      padding: const EdgeInsets.all(_bezel),
      decoration: BoxDecoration(
        color: scheme.onSurface,
        borderRadius: BorderRadius.circular(48),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(38),
        child: ColoredBox(
          color: scheme.surface,
          child: Column(
            children: [
              SizedBox(
                height: _statusBar,
                child: Padding(
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Text(
                        DateFormat.Hm().format(now),
                        textDirection: TextDirection.ltr,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                      const Spacer(),
                      Icon(IconsaxPlusBold.wifi, size: 16, color: iconColor),
                      const SizedBox(width: 4),
                      Icon(IconsaxPlusBold.battery_full, size: 16, color: iconColor),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    size: Size(screen.width, screen.height - _statusBar),
                    padding: EdgeInsets.zero,
                    viewPadding: EdgeInsets.zero,
                    viewInsets: EdgeInsets.zero,
                  ),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
