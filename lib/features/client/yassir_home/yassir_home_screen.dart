import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/seed.dart';
import '../../../core/format/price.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/order_engine/order_engine.dart';
import '../../../core/theme/kafza_theme.dart';
import '../../../core/widgets/initial_image.dart';
import '../../../core/widgets/kafza_badge.dart';
import '../client_widgets.dart';

/// C1: mock Yassir home, the way into Kafza. Mirrors the real Yassir home: location and
/// avatar, the dark wallet card, the welcome line, then the service tiles.
class YassirHomeScreen extends ConsumerWidget {
  const YassirHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final k = context.kafza;
    final client = ref.watch(
      orderEngineProvider.select((s) => s.client(demoClientId)),
    );
    final firstName = client.name.split(' ').first;

    void notInDemo() => ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.yassirNotInDemo)));

    Widget round(
      IconData icon,
      String tooltip,
      Color bg,
      Color fg,
      VoidCallback onTap,
    ) => IconButton.filled(
      icon: Icon(icon),
      tooltip: tooltip,
      onPressed: onTap,
      style: IconButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        fixedSize: const Size.square(44),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(KafzaSpacing.lg),
          children: [
            Row(
              spacing: KafzaSpacing.md,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: notInDemo,
                    borderRadius: BorderRadius.circular(KafzaRadius.input),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: KafzaSpacing.xs,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  l10n.yassirLocation,
                                  style: text.labelLarge,
                                ),
                              ),
                              Icon(
                                KafzaIcons.chevronEnd,
                                size: 20,
                                color: k.accent,
                              ),
                            ],
                          ),
                          Text(
                            isolate(client.addresses.first.label),
                            style: text.bodyMedium!.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox.square(
                  dimension: 44,
                  child: InitialImage(client.name, id: client.id, radius: 22),
                ),
              ],
            ),
            const SizedBox(height: KafzaSpacing.lg),
            BalanceCard(
              balance: client.balance,
              actions: [
                round(
                  IconsaxPlusLinear.send_2,
                  l10n.yassirSend,
                  scheme.onPrimary,
                  k.ink,
                  notInDemo,
                ),
                round(
                  IconsaxPlusLinear.add,
                  l10n.yassirTopUp,
                  scheme.primary,
                  scheme.onPrimary,
                  () => context.push('/recharge'),
                ),
              ],
            ),
            const SizedBox(height: KafzaSpacing.xl),
            Text(
              l10n.yassirHello(isolate(firstName)),
              style: text.headlineMedium,
            ),
            Text(
              l10n.yassirWhatToday,
              style: text.bodyLarge!.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: KafzaSpacing.lg),
            // Kavza: the one tile this demo is about, first and in brand purple.
            Material(
              color: scheme.primary,
              borderRadius: BorderRadius.circular(KafzaRadius.card),
              child: InkWell(
                onTap: () => context.go('/kafza'),
                borderRadius: BorderRadius.circular(KafzaRadius.card),
                child: Padding(
                  padding: const EdgeInsets.all(KafzaSpacing.lg),
                  child: Row(
                    spacing: KafzaSpacing.lg,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: KafzaSpacing.xs,
                          children: [
                            Row(
                              spacing: KafzaSpacing.sm,
                              children: [
                                // White word logo: the purple one vanishes on purple.
                                Image.asset(
                                  'assets/logo/word logo white.png',
                                  height: 40,
                                  semanticLabel: l10n.kafza,
                                ),
                                KafzaBadge(
                                  l10n.badgeNew,
                                  tone: BadgeTone.success,
                                ),
                              ],
                            ),
                            Text(
                              l10n.kafzaTileHint,
                              style: text.bodyMedium!.copyWith(
                                color: k.primaryTint,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(KafzaIcons.chevronEnd, color: scheme.onPrimary),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: KafzaSpacing.md),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: KafzaSpacing.md,
              crossAxisSpacing: KafzaSpacing.md,
              childAspectRatio: 1.35,
              children: [
                ServiceTile(
                  emoji: 'ride',
                  label: l10n.yassirRide,
                  onTap: notInDemo,
                ),
                ServiceTile(
                  emoji: 'food',
                  label: l10n.yassirFood,
                  onTap: notInDemo,
                ),
                ServiceTile(
                  emoji: 'market',
                  label: l10n.yassirMarket,
                  onTap: notInDemo,
                ),
                ServiceTile(
                  emoji: 'parcel',
                  label: l10n.yassirParcel,
                  onTap: notInDemo,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
