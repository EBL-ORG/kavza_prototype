import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/format/price.dart';
import '../../../core/format/time.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/order_engine/order_engine.dart';
import '../../../core/theme/kafza_theme.dart';
import '../../../core/widgets/info_banner.dart';

/// C8: order placed (CLT-22). Sits on top of the order's tracking page, so Back lands there.
class PlacedScreen extends ConsumerWidget {
  const PlacedScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final o = ref.watch(orderEngineProvider.select((s) => s.order(id)));
    final store = ref.watch(orderEngineProvider.select((s) => s.store(o.storeId)));
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: ListView(
        padding: const EdgeInsets.all(KafzaSpacing.lg),
        children: [
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(color: scheme.primaryContainer, shape: BoxShape.circle),
              child: Icon(IconsaxPlusLinear.tick_circle, size: 44, color: scheme.primary),
            ),
          ),
          const SizedBox(height: KafzaSpacing.xl),
          Text(l10n.placedTitle, style: text.headlineMedium, textAlign: TextAlign.center),
          const SizedBox(height: KafzaSpacing.xs),
          Text(
            l10n.orderNumber(ltr(o.id)),
            style: text.bodyLarge!.copyWith(color: scheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: KafzaSpacing.xl),
          Text(
            l10n.placedDeadline(
              isolate(store.name),
              formatDuration(l10n, acceptanceWindow(o.type)),
              formatDateTime(l10n, o.deadline),
            ),
            style: text.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: KafzaSpacing.lg),
          InfoBanner(icon: IconsaxPlusLinear.wallet, text: l10n.placedMoneyNote),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(KafzaSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: KafzaSpacing.sm,
            children: [
              FilledButton(onPressed: () => context.go('/kafza/orders/$id'), child: Text(l10n.trackOrder)),
              OutlinedButton(onPressed: () => context.go('/kafza'), child: Text(l10n.backToKafza)),
            ],
          ),
        ),
      ),
    );
  }
}
