import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/contact_check.dart';
import '../../../core/data/clock.dart';
import '../../../core/format/price.dart';
import '../../../core/format/time.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/models/order.dart';
import '../../../core/order_engine/order_engine.dart';
import '../../../core/theme/kafza_theme.dart';
import '../../../core/widgets/info_banner.dart';
import '../../../core/widgets/kafza_badge.dart';
import '../../../core/widgets/kafza_button.dart';
import '../../../core/widgets/kafza_sheet.dart';
import '../../../core/widgets/kafza_text_field.dart';
import '../../../core/widgets/order_widgets.dart';
import '../store_widgets.dart';

/// Where the money is, from the store's side (DESIGN.md › Money line). Warning tone = a problem.
(IconData, String, bool) _moneyLine(BuildContext context, Order o) {
  final l10n = AppLocalizations.of(context);
  final total = formatPrice(context, o.total), earnings = formatPrice(context, o.earnings);
  return switch (o.status) {
    OrderStatus.placed => (IconsaxPlusLinear.wallet, l10n.storeMoneyPlaced(total), false),
    OrderStatus.delivered => (IconsaxPlusLinear.tick_circle, l10n.storeMoneyPaid(earnings), false),
    OrderStatus.disputed => (IconsaxPlusLinear.judge, l10n.storeMoneyDisputed, true),
    OrderStatus.paymentFailed => (IconsaxPlusLinear.money_forbidden, l10n.storePaymentFailed, true),
    OrderStatus.declined => (IconsaxPlusLinear.forbidden_2, l10n.storeMoneyDeclined, false),
    OrderStatus.expired => (IconsaxPlusLinear.timer_pause, l10n.storeMoneyExpired, false),
    OrderStatus.cancelledByClient => (KafzaIcons.undo, l10n.storeMoneyCancelledByClient, false),
    OrderStatus.cancelledAfterAcceptance => (IconsaxPlusLinear.flag, l10n.storeMoneyCancelled(total), true),
    OrderStatus.deliveryFailed when o.money == Money.paid =>
      (IconsaxPlusLinear.danger, l10n.storeDeliveryFailedPaid(earnings), true),
    OrderStatus.deliveryFailed => (IconsaxPlusLinear.danger, l10n.storeDeliveryFailedRefund, true),
    _ => (IconsaxPlusLinear.lock, l10n.storeMoneyHeld(total), false),
  };
}

/// S7: one order, and the store's next step (STR-28…31).
class StoreOrderScreen extends ConsumerStatefulWidget {
  const StoreOrderScreen({super.key, required this.id});

  final String id;

  @override
  ConsumerState<StoreOrderScreen> createState() => _StoreOrderScreenState();
}

class _StoreOrderScreenState extends ConsumerState<StoreOrderScreen> {
  bool _accepting = false;

  OrderEngine get _engine => ref.read(orderEngineProvider.notifier);

  /// The result shows in the money line: "payment secured" or "payment failed".
  Future<void> _accept() async {
    setState(() => _accepting = true);
    try {
      await _engine.accept(widget.id);
    } finally {
      if (mounted) setState(() => _accepting = false);
    }
  }

  Future<void> _withReason({required bool cancel}) async {
    final l10n = AppLocalizations.of(context);
    final reason = await showKafzaSheet<String>(context, (_) => _ReasonSheet(orderId: widget.id, cancel: cancel));
    if (reason == null || !mounted) return;
    try {
      cancel ? _engine.cancelAfterAcceptance(widget.id, reason) : _engine.decline(widget.id, reason);
      snack(context, cancel ? l10n.orderCancelledStrike : l10n.orderDeclined);
    } on OrderException catch (e) {
      snack(context, l10n.orderError(e.error));
    }
  }

  Future<void> _markReady() async {
    final l10n = AppLocalizations.of(context);
    final ok = await showKafzaDialog(
      context,
      title: l10n.markReadyTitle,
      body: l10n.markReadyBody,
      cancel: l10n.cancel,
      confirm: l10n.ready,
    );
    if (ok) _engine.markReady(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    // A demo reset removes orders placed during the demo.
    final o = ref.watch(orderEngineProvider.select((s) => s.orders.where((o) => o.id == widget.id).firstOrNull));
    if (o == null) return const Scaffold();
    ref.watch(clockProvider.select((t) => t.millisecondsSinceEpoch ~/ 60000));
    final now = ref.read(clockProvider);
    final (moneyIcon, money, problem) = _moneyLine(context, o);
    final cancellable = o.status == OrderStatus.accepted || o.status == OrderStatus.inPreparation;
    final destructive = TextButton.styleFrom(foregroundColor: scheme.error);

    Widget heading(String title) => Padding(
          padding: const EdgeInsetsDirectional.only(top: KafzaSpacing.xl, bottom: KafzaSpacing.md),
          child: Text(title, style: text.titleMedium),
        );

    final actions = switch (o.status) {
      OrderStatus.placed => [
          KafzaButton(l10n.accept, onPressed: _accept),
          if (_accepting)
            Text(l10n.securingPayment, style: text.bodySmall, textAlign: TextAlign.center)
          else
            OutlinedButton(onPressed: () => _withReason(cancel: false), child: Text(l10n.decline)),
        ],
      OrderStatus.accepted => [FilledButton(onPressed: () => _engine.startPreparation(widget.id), child: Text(l10n.startPreparation))],
      OrderStatus.inPreparation => [FilledButton(onPressed: _markReady, child: Text(l10n.markReady))],
      _ => <Widget>[],
    };

    return Scaffold(
      appBar: AppBar(title: Text(l10n.orderNumber(ltr(o.id)))),
      body: ListView(
        padding: actions.isEmpty
            ? const EdgeInsets.all(KafzaSpacing.lg).aboveGestureBar(context)
            : const EdgeInsets.all(KafzaSpacing.lg),
        children: [
          Text(isolate(o.productTitle), style: text.titleLarge),
          Text(
            l10n.clientIn(isolate(o.address.commune), formatDateTime(l10n, o.placedAt)),
            style: text.bodyMedium!.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: KafzaSpacing.sm),
          Wrap(
            spacing: KafzaSpacing.xs,
            runSpacing: KafzaSpacing.xs,
            children: [
              if (o.status == OrderStatus.placed)
                CountdownChip(deadline: o.deadline, window: acceptanceWindow(o.type), now: now)
              else
                StatusChip(o.status),
              KafzaBadge(o.type == OrderType.readyMade ? l10n.readyMadeTitle : l10n.madeToOrderTitle, tone: BadgeTone.neutral),
            ],
          ),
          const SizedBox(height: KafzaSpacing.lg),
          InfoBanner(icon: moneyIcon, text: money, warning: problem),
          if (o.status == OrderStatus.placed) ...[
            const SizedBox(height: KafzaSpacing.sm),
            Text(l10n.answerBefore(formatDateTime(l10n, o.deadline)), style: text.bodyMedium),
          ],
          if (o.status == OrderStatus.ready || o.status == OrderStatus.pickedUp) ...[
            const SizedBox(height: KafzaSpacing.md),
            Card(
              child: ListTile(
                contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: KafzaSpacing.lg, vertical: KafzaSpacing.xs),
                leading: Icon(IconsaxPlusLinear.truck_fast, color: scheme.primary, size: 32),
                title: Text(o.status == OrderStatus.ready ? l10n.waitingCourier : l10n.courierOnTheWay),
                subtitle: Text(o.status == OrderStatus.ready ? l10n.waitingCourierBody : l10n.courierOnTheWayBody),
              ),
            ),
          ],
          heading(l10n.orderDetailsTitle),
          Text(l10n.qty(o.unit, o.qty), style: text.bodyMedium),
          for (final x in o.options) Text(l10n.labelValue(isolate(x.group), isolate(x.value)), style: text.bodyMedium),
          if (o.deliveryDate case final d?) Text(l10n.deliveryOn(formatDay(l10n, d)), style: text.bodyMedium),
          Text(l10n.deliveredToCommune(isolate(o.address.commune)), style: text.bodyMedium),
          heading(l10n.yourEarnings),
          EarningsBreakdown(o),
          const SizedBox(height: KafzaSpacing.sm),
          Text(
            l10n.clientPays(formatPrice(context, o.total)),
            style: text.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
          ),
          heading(l10n.orderStatusTitle),
          StatusTimeline(o),
          if (cancellable) ...[
            const Divider(),
            const SizedBox(height: KafzaSpacing.sm),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton(style: destructive, onPressed: () => _withReason(cancel: true), child: Text(l10n.cancelOrder)),
            ),
          ],
        ],
      ),
      bottomNavigationBar: actions.isEmpty ? null : BottomBar(children: actions),
    );
  }
}

enum _Reason { outOfStock, noTime, dateUnavailable, other }

/// Decline (no strike) or cancel after acceptance (refund + strike). Pops with the reason.
class _ReasonSheet extends ConsumerStatefulWidget {
  const _ReasonSheet({required this.orderId, required this.cancel});

  final String orderId;
  final bool cancel;

  @override
  ConsumerState<_ReasonSheet> createState() => _ReasonSheetState();
}

class _ReasonSheetState extends ConsumerState<_ReasonSheet> {
  _Reason? _reason;
  String _details = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final state = ref.watch(orderEngineProvider);
    final storeId = state.order(widget.orderId).storeId;
    final strikes = state.strikes.where((s) => s.storeId == storeId).length % strikesBeforeSuspension;
    String label(_Reason r) => switch (r) {
          _Reason.outOfStock => l10n.reasonOutOfStock,
          _Reason.noTime => l10n.reasonNoTime,
          _Reason.dateUnavailable => l10n.reasonDate,
          _Reason.other => l10n.reasonOther,
        };
    final other = _reason == _Reason.other;
    final ok = _reason != null && (!other || (_details.trim().isNotEmpty && contactCheck(_details) == null));
    final reason = _reason == null ? '' : (other ? _details.trim() : label(_reason!));

    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.fromSTEB(KafzaSpacing.lg, 0, KafzaSpacing.lg, KafzaSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.cancel ? l10n.cancelOrderStoreTitle : l10n.declineTitle, style: text.titleLarge),
            const SizedBox(height: KafzaSpacing.md),
            if (widget.cancel)
              InfoBanner(
                icon: IconsaxPlusLinear.flag,
                text: l10n.cancelStrikeWarning(strikes + 1, strikesBeforeSuspension),
                warning: true,
              )
            else
              Text(l10n.declineBody, style: text.bodyMedium!.copyWith(color: scheme.onSurfaceVariant)),
            const SizedBox(height: KafzaSpacing.lg),
            Text(l10n.reasonTitle, style: text.titleMedium),
            RadioGroup<_Reason>(
              groupValue: _reason,
              onChanged: (v) => setState(() => _reason = v),
              child: Column(
                children: [
                  for (final r in _Reason.values)
                    RadioListTile<_Reason>(value: r, title: Text(label(r)), contentPadding: EdgeInsets.zero),
                ],
              ),
            ),
            if (other) ...[
              const SizedBox(height: KafzaSpacing.sm),
              KafzaTextField(
                label: l10n.reasonDetails,
                helper: l10n.reasonDetailsHelper,
                value: _details,
                maxLength: 200,
                maxLines: 3,
                onChanged: (v) => setState(() => _details = v),
              ),
            ],
            const SizedBox(height: KafzaSpacing.xl),
            if (widget.cancel)
              OutlinedButton(
                style: OutlinedButton.styleFrom(foregroundColor: scheme.error, side: BorderSide(color: scheme.error)),
                onPressed: ok ? () => Navigator.pop(context, reason) : null,
                child: Text(l10n.cancelWithStrike),
              )
            else
              FilledButton(onPressed: ok ? () => Navigator.pop(context, reason) : null, child: Text(l10n.decline)),
          ],
        ),
      ),
    );
  }
}
