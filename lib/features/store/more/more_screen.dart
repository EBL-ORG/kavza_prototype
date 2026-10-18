import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/format/price.dart';
import '../../../core/format/time.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/l10n/locale_provider.dart';
import '../../../core/models/notification.dart';
import '../../../core/models/store.dart';
import '../../../core/order_engine/order_engine.dart';
import '../../../core/theme/kafza_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/initial_image.dart';
import '../../../core/widgets/kafza_badge.dart';
import '../../../core/widgets/notice_banner.dart';
import '../store_providers.dart';
import '../store_widgets.dart';

/// S14: profile, notifications, reviews, strikes, Kafza Pro, help, language, log out.
class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final store = ref.watch(currentStoreProvider)!;
    final locale = ref.watch(localeProvider);
    final unread = ref.watch(orderEngineProvider
        .select((s) => s.notifications.where((n) => n.app == AppSide.store && n.to == store.id && !n.read).length));

    Widget link(IconData icon, String title, String path, {Widget? trailing}) => ListTile(
          leading: Icon(icon),
          title: Text(title),
          trailing: trailing ?? const Icon(KafzaIcons.chevronEnd),
          onTap: () => context.go(path),
        );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tabMore)),
      body: ListView(
        children: [
          ListTile(
            contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: KafzaSpacing.lg, vertical: KafzaSpacing.sm),
            leading: SizedBox.square(dimension: 48, child: StoreAvatar(store)),
            title: Text(isolate(store.name), style: text.titleMedium),
            subtitle: Text(isolate('${store.commune}, ${store.wilaya}')),
            trailing: switch (store.status) {
              StoreStatus.approved => store.pro ? KafzaBadge(l10n.badgePro, tone: BadgeTone.solid) : null,
              StoreStatus.pending => KafzaBadge(l10n.storePending, tone: BadgeTone.neutral),
              StoreStatus.rejected => KafzaBadge(l10n.storeRejected, tone: BadgeTone.warning),
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(IconsaxPlusLinear.shop),
            title: Text(l10n.storeProfile),
            trailing: const Icon(KafzaIcons.chevronEnd),
            onTap: () => context.push('/profile'),
          ),
          link(
            IconsaxPlusLinear.notification,
            l10n.notifications,
            '/more/notifications',
            trailing: unread == 0 ? null : Badge(label: Text('$unread')),
          ),
          if (store.status == StoreStatus.approved) ...[
            link(IconsaxPlusLinear.star_1, l10n.reviewsTitle, '/more/reviews'),
            link(IconsaxPlusLinear.flag, l10n.strikesTitle, '/more/strikes'),
          ],
          ListTile(
            leading: const Icon(IconsaxPlusLinear.crown_1),
            title: Text(l10n.proTitle),
            subtitle: Text(store.pro ? l10n.proActive : l10n.planFree),
            trailing: const Icon(KafzaIcons.chevronEnd),
            onTap: () => showProSheet(context),
          ),
          link(IconsaxPlusLinear.message_question, l10n.help, '/more/help'),
          ListTile(
            leading: const Icon(IconsaxPlusLinear.translate),
            title: Text(l10n.language),
            trailing: Wrap(
              spacing: KafzaSpacing.sm,
              children: [
                for (final (code, label) in [('ar', l10n.langAr), ('fr', l10n.langFr)])
                  ChoiceChip(
                    showCheckmark: false,
                    label: Text(label),
                    selected: locale.languageCode == code,
                    onSelected: (_) => ref.read(localeProvider.notifier).set(Locale(code)),
                  ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: Icon(IconsaxPlusLinear.logout, color: scheme.error),
            title: Text(l10n.logOut, style: TextStyle(color: scheme.error)),
            onTap: () => ref.read(storeSessionProvider.notifier).logOut(),
          ),
        ],
      ),
    );
  }
}

/// S14 notifications list. Opening it marks everything read.
class StoreNotificationsScreen extends ConsumerStatefulWidget {
  const StoreNotificationsScreen({super.key});

  @override
  ConsumerState<StoreNotificationsScreen> createState() => _StoreNotificationsScreenState();
}

class _StoreNotificationsScreenState extends ConsumerState<StoreNotificationsScreen> {
  // Unread dots stay for this visit; the engine marks them read once the frame is built.
  late final _unread = {
    for (final n in ref.read(orderEngineProvider).notifications)
      if (n.app == AppSide.store && n.to == ref.read(storeSessionProvider) && !n.read) n.time,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final id = ref.read(storeSessionProvider);
      if (mounted && id != null) ref.read(orderEngineProvider.notifier).markNotificationsRead(AppSide.store, id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final id = ref.watch(currentStoreProvider.select((s) => s?.id));
    final state = ref.watch(orderEngineProvider);
    final mine = state.notifications.where((n) => n.app == AppSide.store && n.to == id).toList();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.notifications)),
      body: mine.isEmpty
          ? EmptyState(icon: IconsaxPlusLinear.notification, title: l10n.noNotifications, body: l10n.noNotificationsHint)
          : ListView.separated(
              itemCount: mine.length,
              separatorBuilder: (_, _) => const Divider(indent: KafzaSpacing.lg, endIndent: KafzaSpacing.lg),
              itemBuilder: (context, i) {
                final n = mine[i];
                final (icon, title, body) = noticeText(l10n, n, state);
                final unread = _unread.contains(n.time);
                return ListTile(
                  leading: Icon(icon, color: unread ? scheme.primary : scheme.onSurfaceVariant),
                  title: Text(title, style: unread ? text.labelLarge : text.bodyLarge),
                  subtitle: Text([if (body.isNotEmpty) body, formatDateTime(l10n, n.time)].join('\n')),
                  isThreeLine: body.isNotEmpty,
                  onTap: () => context.go(noticeRoute(n)),
                );
              },
            ),
    );
  }
}

/// S14 help: what store owners ask most.
class StoreHelpScreen extends StatelessWidget {
  const StoreHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.help)),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: KafzaSpacing.sm).aboveGestureBar(context),
        children: [
          for (final (q, a) in [
            (l10n.storeFaqPaidQ, l10n.storeFaqPaidA),
            (l10n.storeFaqAcceptQ, l10n.storeFaqAcceptA),
            (l10n.storeFaqStrikesQ, l10n.strikesHow),
            (l10n.storeFaqWithdrawQ, l10n.storeFaqWithdrawA(formatPrice(context, minWithdrawal))),
            (l10n.storeFaqContactQ, l10n.storeFaqContactA),
          ])
            ExpansionTile(
              title: Text(q, style: text.bodyLarge),
              childrenPadding: const EdgeInsetsDirectional.fromSTEB(KafzaSpacing.lg, 0, KafzaSpacing.lg, KafzaSpacing.lg),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(a, style: text.bodyMedium)],
            ),
          Padding(
            padding: const EdgeInsets.all(KafzaSpacing.lg),
            child: Text(l10n.storeSupportLine, style: text.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ),
        ],
      ),
    );
  }
}
