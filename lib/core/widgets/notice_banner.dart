import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/app_state.dart';
import '../data/clock.dart';
import '../format/price.dart';
import '../l10n/app_localizations.dart';
import '../l10n/labels.dart';
import '../models/notification.dart';
import '../models/order.dart';
import '../order_engine/order_engine.dart';
import '../theme/kafza_theme.dart';

/// Icon, title and one line for a notification, built in the app language.
(IconData, String, String) noticeText(AppLocalizations l10n, AppNotification n, AppState s) {
  final order = n.orderId == null ? null : s.orders.where((o) => o.id == n.orderId).firstOrNull;
  final about = order == null ? '' : '${l10n.orderTitle(order)} · ${ltr(order.id)}';
  return switch (n.kind) {
    NoticeKind.order when n.app == AppSide.store && n.status == OrderStatus.placed =>
      (IconsaxPlusLinear.receipt_text, l10n.noticeNewOrder, about),
    NoticeKind.order => (IconsaxPlusLinear.receipt_text, l10n.status(n.status!), about),
    NoticeKind.lowStock => (
        IconsaxPlusLinear.box,
        l10n.noticeLowStock,
        isolate(s.products.where((p) => p.id == n.productId).firstOrNull?.title ?? ''),
      ),
    NoticeKind.review => (IconsaxPlusLinear.star_1, l10n.noticeReview, about),
    NoticeKind.strike => (IconsaxPlusLinear.flag, l10n.noticeStrike, about),
    NoticeKind.suspended => (IconsaxPlusLinear.forbidden_2, l10n.noticeSuspended, l10n.noticeSuspendedBody),
    NoticeKind.storeApproved => (IconsaxPlusLinear.verify, l10n.storeApproved, ''),
    NoticeKind.storeRejected => (IconsaxPlusLinear.danger, l10n.storeRejectedNotice, ''),
  };
}

/// New notifications for [to] slide in at the top for 4 s; a tap calls [onTap]. Sits above
/// the app's router, so it shows on every screen of that app.
class NoticeBanner extends ConsumerStatefulWidget {
  const NoticeBanner({super.key, required this.app, required this.to, required this.onTap, required this.child});

  final AppSide app;

  /// Client or store id; null shows nothing (store app logged out).
  final String? to;
  final ValueChanged<AppNotification> onTap;
  final Widget child;

  @override
  ConsumerState<NoticeBanner> createState() => _NoticeBannerState();
}

class _NoticeBannerState extends ConsumerState<NoticeBanner> {
  AppNotification? _notice;
  bool _visible = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    ref.listenManual(
      orderEngineProvider.select((s) => s.notifications.where((n) => n.app == widget.app).firstOrNull),
      (previous, next) {
        // Only one stamped right now: a demo reset brings back old seeded notifications.
        if (next == null || identical(next, previous) || next.read || next.to != widget.to) return;
        if (next.time.isBefore(ref.read(clockProvider))) return;
        _timer?.cancel();
        _timer = Timer(const Duration(seconds: 4), () => setState(() => _visible = false));
        setState(() {
          _notice = next;
          _visible = true;
        });
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final n = _notice;
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final (icon, title, body) = n == null ? (null, '', '') : noticeText(l10n, n, ref.read(orderEngineProvider));
    return Stack(
      children: [
        widget.child,
        if (n != null)
          PositionedDirectional(
            top: 0,
            start: 0,
            end: 0,
            child: SafeArea(
              child: AnimatedSlide(
                offset: _visible ? Offset.zero : const Offset(0, -1.5),
                duration: MediaQuery.disableAnimationsOf(context) ? Duration.zero : const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                child: Padding(
                  padding: const EdgeInsets.all(KafzaSpacing.sm),
                  child: Semantics(
                    liveRegion: true,
                    child: Material(
                      elevation: 3,
                      color: scheme.surface,
                      borderRadius: BorderRadius.circular(KafzaRadius.card),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(KafzaRadius.card),
                        onTap: () {
                          setState(() => _visible = false);
                          widget.onTap(n);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(KafzaSpacing.md),
                          child: Row(
                            spacing: KafzaSpacing.md,
                            children: [
                              Icon(icon, color: scheme.primary),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(title, style: text.labelLarge),
                                    if (body.isNotEmpty)
                                      Text(
                                        body,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: text.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
                                      ),
                                  ],
                                ),
                              ),
                              Icon(KafzaIcons.chevronEnd, color: scheme.onSurfaceVariant),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
