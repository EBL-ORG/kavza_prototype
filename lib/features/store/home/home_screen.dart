import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/clock.dart';
import '../../../core/format/price.dart';
import '../../../core/format/time.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/models/order.dart';
import '../../../core/models/product.dart';
import '../../../core/order_engine/order_engine.dart';
import '../../../core/theme/kafza_theme.dart';
import '../../../core/widgets/kafza_logo.dart';
import '../../../core/widgets/info_banner.dart';
import '../../../core/widgets/kafza_badge.dart';
import '../store_providers.dart';
import '../store_widgets.dart';

/// S5: store status, orders waiting for an answer, balance, low stock, strike warning.
class StoreHomeScreen extends ConsumerWidget {
  const StoreHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final store = ref.watch(currentStoreProvider)!;
    final state = ref.watch(orderEngineProvider);
    ref.watch(clockProvider.select((t) => t.millisecondsSinceEpoch ~/ 60000));
    final now = ref.read(clockProvider);
    final mine = state.orders.where((o) => o.storeId == store.id).toList();
    final waiting = mine.where((o) => o.status == OrderStatus.placed).toList()
      ..sort((a, b) => a.deadline.compareTo(b.deadline));
    final today = mine.where((o) => DateUtils.isSameDay(o.placedAt, now)).length;
    final lowStock = state.products
        .where((p) => p.storeId == store.id && p.status == ProductStatus.live && p.readyMade != null)
        .where((p) => p.readyMade!.available <= p.readyMade!.lowStockAlert)
        .toList();
    final strikes = state.strikes.where((s) => s.storeId == store.id).length % strikesBeforeSuspension;
    final suspended = store.suspendedAt(now);

    final (statusLabel, statusTone) = suspended
        ? (l10n.storeSuspended, BadgeTone.warning)
        : store.paused
        ? (l10n.productPaused, BadgeTone.neutral)
        : (l10n.storeOpen, BadgeTone.success);

    Widget heading(String title) => Padding(
      padding: const EdgeInsetsDirectional.only(top: KafzaSpacing.xl, bottom: KafzaSpacing.md),
      child: Text(title, style: text.titleMedium),
    );

    // The balance reads as Yassir Pay's dark card; the other figure stays a plain card.
    Widget figure(String label, String value, VoidCallback onTap, {bool wallet = false}) => Expanded(
      child: Card(
        color: wallet ? context.kafza.ink : null,
        shape: wallet ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(KafzaRadius.card)) : null,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(KafzaSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: KafzaSpacing.xs,
              children: [
                Text(
                  label,
                  style: text.bodySmall!.copyWith(
                    color: wallet ? context.kafza.onInkSecondary : scheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  value,
                  style: text.titleLarge!.copyWith(color: wallet ? scheme.onPrimary : null, fontFeatures: tabular),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const KafzaLogo()),
      body: ListView(
        padding: const EdgeInsets.all(KafzaSpacing.lg),
        children: [
          Row(
            spacing: KafzaSpacing.sm,
            children: [
              Flexible(child: Text(isolate(store.name), style: text.titleLarge)),
              KafzaBadge(
                statusLabel,
                tone: statusTone,
                icon: suspended || store.paused ? null : IconsaxPlusBold.record_circle,
              ),
            ],
          ),
          if (suspended) ...[
            const SizedBox(height: KafzaSpacing.md),
            InfoBanner(
              icon: IconsaxPlusLinear.forbidden_2,
              text: l10n.suspendedBanner(formatDateTime(l10n, store.suspendedUntil!)),
              warning: true,
              onTap: () => context.go('/more/strikes'),
            ),
          ] else if (store.paused) ...[
            const SizedBox(height: KafzaSpacing.md),
            InfoBanner(
              icon: IconsaxPlusLinear.pause_circle,
              text: l10n.productsPausedBanner,
              warning: true,
              onTap: () => context.push('/profile'),
            ),
          ],
          if (!suspended && strikes > 0) ...[
            const SizedBox(height: KafzaSpacing.md),
            InfoBanner(
              icon: IconsaxPlusLinear.flag,
              text: l10n.strikeStanding(strikes, strikesBeforeSuspension),
              warning: strikes == strikesBeforeSuspension - 1,
              onTap: () => context.go('/more/strikes'),
            ),
          ],
          const SizedBox(height: KafzaSpacing.lg),
          Row(
            spacing: KafzaSpacing.md,
            children: [
              figure(
                l10n.availableBalance,
                formatPrice(context, store.balance),
                () => StatefulNavigationShell.of(context).goBranch(3),
                wallet: true,
              ),
              figure(
                l10n.todayOrders,
                formatNumber(context, today),
                () => StatefulNavigationShell.of(context).goBranch(1),
              ),
            ],
          ),
          heading(l10n.needsAnswer(waiting.length)),
          if (waiting.isEmpty)
            Text(l10n.needsAnswerEmpty, style: text.bodyMedium!.copyWith(color: scheme.onSurfaceVariant))
          else
            for (final o in waiting)
              Padding(
                padding: const EdgeInsetsDirectional.only(bottom: KafzaSpacing.md),
                child: StoreOrderCard(o),
              ),
          if (lowStock.isNotEmpty) ...[
            heading(l10n.lowStockTitle),
            for (final p in lowStock)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(IconsaxPlusLinear.box, color: context.kafza.warning),
                title: Text(isolate(p.title)),
                trailing: KafzaBadge(
                  p.readyMade!.available <= 0 ? l10n.outOfStock : l10n.lowStock(p.readyMade!.available),
                  tone: BadgeTone.warning,
                ),
                onTap: () => StatefulNavigationShell.of(context).goBranch(2),
              ),
          ],
        ],
      ),
    );
  }
}
