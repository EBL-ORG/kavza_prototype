import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
import '../../../core/widgets/kafza_sheet.dart';
import '../../../core/widgets/kafza_text_field.dart';
import '../../../core/widgets/order_widgets.dart';
import '../../../core/widgets/rating_stars.dart';
import 'orders_screen.dart';

void _snack(BuildContext context, String message) => ScaffoldMessenger.of(context)
  ..hideCurrentSnackBar()
  ..showSnackBar(SnackBar(content: Text(message)));

/// C10: order tracking (CLT-26…31).
class TrackingScreen extends ConsumerWidget {
  const TrackingScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final secondary = Theme.of(context).colorScheme.onSurfaceVariant;
    final state = ref.watch(orderEngineProvider);
    ref.watch(clockProvider.select((t) => t.millisecondsSinceEpoch ~/ 60000));
    final now = ref.read(clockProvider);
    final o = state.order(id);
    final store = state.store(o.storeId);
    final review = state.reviews.where((r) => r.orderId == id).firstOrNull;
    final deliveredAt = o.timeOf(OrderStatus.delivered);
    final canReport = o.status == OrderStatus.delivered && now.difference(deliveredAt!) <= disputeWindow;
    final (moneyIcon, money) = moneyLine(context, o);
    final optionsTotal = o.options.fold(0, (s, x) => s + x.price);

    Future<void> cancel() async {
      final ok = await showKafzaDialog(
        context,
        title: l10n.cancelOrderTitle,
        body: l10n.cancelOrderBody,
        cancel: l10n.keepIt,
        confirm: l10n.cancelOrder,
        destructive: true,
      );
      if (!ok || !context.mounted) return;
      try {
        ref.read(orderEngineProvider.notifier).cancelByClient(id);
        _snack(context, l10n.orderCancelled);
      } on OrderException catch (e) {
        _snack(context, l10n.orderError(e.error));
      }
    }

    Widget heading(String title) => Padding(
          padding: const EdgeInsetsDirectional.only(top: KafzaSpacing.xl, bottom: KafzaSpacing.md),
          child: Text(title, style: text.titleMedium),
        );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.orderNumber(ltr(o.id)))),
      body: ListView(
        padding: const EdgeInsets.all(KafzaSpacing.lg).aboveGestureBar(context),
        children: [
          Text(isolate(o.productTitle), style: text.titleLarge),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: InkWell(
              onTap: () => context.push('/store/${store.id}'),
              child: Text(
                l10n.storeDistance(isolate(store.name), formatNumber(context, store.distanceKm)),
                style: text.bodyMedium!.copyWith(color: secondary),
              ),
            ),
          ),
          const SizedBox(height: KafzaSpacing.sm),
          Align(alignment: AlignmentDirectional.centerStart, child: StatusChip(o.status)),
          if (o.status == OrderStatus.placed) ...[
            const SizedBox(height: KafzaSpacing.lg),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(KafzaSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: KafzaSpacing.sm,
                  children: [
                    CountdownChip(deadline: o.deadline, window: acceptanceWindow(o.type), now: now),
                    Text(l10n.waitingForStore(formatDateTime(l10n, o.deadline)), style: text.bodyMedium),
                    const SizedBox(height: KafzaSpacing.xs),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: cancel,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.error,
                          side: BorderSide(color: Theme.of(context).colorScheme.error),
                        ),
                        child: Text(l10n.cancelOrder),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: KafzaSpacing.lg),
          InfoBanner(icon: moneyIcon, text: money, warning: o.status == OrderStatus.disputed),
          if (o.status == OrderStatus.pickedUp) ...[
            const SizedBox(height: KafzaSpacing.md),
            Card(
              child: ListTile(
                contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: KafzaSpacing.lg, vertical: KafzaSpacing.xs),
                leading: Icon(IconsaxPlusLinear.truck_fast, color: Theme.of(context).colorScheme.primary, size: 32),
                title: Text(l10n.courierTitle),
                subtitle: Text(l10n.courierBody(isolate(o.address.label))),
              ),
            ),
          ],
          if (o.status == OrderStatus.delivered || o.status == OrderStatus.disputed) ...[
            heading(l10n.yourReview),
            if (review != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: KafzaSpacing.xs,
                children: [
                  RatingStars(review.stars, size: 20),
                  if (review.comment.isNotEmpty) Text(isolate(review.comment), style: text.bodyMedium),
                ],
              )
            else
              FilledButton(
                onPressed: () => showKafzaSheet<void>(context, (_) => _ReviewSheet(id)),
                child: Text(l10n.leaveReview),
              ),
            if (canReport) ...[
              const SizedBox(height: KafzaSpacing.sm),
              OutlinedButton(
                onPressed: () => showKafzaSheet<void>(context, (_) => _DisputeSheet(id)),
                child: Text(l10n.reportProblem),
              ),
              const SizedBox(height: KafzaSpacing.xs),
              Text(
                l10n.reportUntil(formatDateTime(l10n, deliveredAt.add(disputeWindow))),
                style: text.bodySmall!.copyWith(color: secondary),
                textAlign: TextAlign.center,
              ),
            ],
          ],
          heading(l10n.orderStatusTitle),
          StatusTimeline(o),
          heading(l10n.orderDetailsTitle),
          Text(l10n.qty(o.unit, o.qty), style: text.bodyMedium),
          for (final x in o.options) Text(l10n.labelValue(isolate(x.group), isolate(x.value)), style: text.bodyMedium),
          if (o.deliveryDate case final d?) Text(l10n.deliveryOn(formatDay(l10n, d)), style: text.bodyMedium),
          Text(isolate('${o.address.label} · ${o.address.street}, ${o.address.commune}'), style: text.bodyMedium),
          const SizedBox(height: KafzaSpacing.lg),
          PriceBreakdown(
            itemsLabel: l10n.itemsTotal,
            items: o.itemTotal - optionsTotal,
            options: optionsTotal,
            deliveryFee: o.deliveryFee,
            freeDelivery: o.freeDelivery,
          ),
        ],
      ),
    );
  }
}

/// Stars + optional comment, once per delivered order.
class _ReviewSheet extends ConsumerStatefulWidget {
  const _ReviewSheet(this.orderId);

  final String orderId;

  @override
  ConsumerState<_ReviewSheet> createState() => _ReviewSheetState();
}

class _ReviewSheetState extends ConsumerState<_ReviewSheet> {
  int _stars = 0;
  String _comment = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ok = _stars > 0 && contactCheck(_comment) == null;
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.fromSTEB(KafzaSpacing.lg, 0, KafzaSpacing.lg, KafzaSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: KafzaSpacing.lg,
          children: [
            Text(l10n.leaveReview, style: Theme.of(context).textTheme.titleLarge),
            RatingInput(value: _stars, onChanged: (v) => setState(() => _stars = v)),
            KafzaTextField(
              label: l10n.reviewComment,
              value: _comment,
              maxLength: 300,
              maxLines: 4,
              onChanged: (v) => setState(() => _comment = v),
            ),
            FilledButton(
              onPressed: ok
                  ? () {
                      try {
                        ref.read(orderEngineProvider.notifier).addReview(widget.orderId, _stars, _comment);
                        _snack(context, l10n.reviewThanks);
                        Navigator.pop(context);
                      } on OrderException catch (e) {
                        _snack(context, l10n.orderError(e.error));
                      }
                    }
                  : null,
              child: Text(l10n.sendReview),
            ),
          ],
        ),
      ),
    );
  }
}

enum _Problem { damaged, wrongItem, missingItems, notAsDescribed, other }

/// Report a problem within 48 h of delivery: reason, description, photos (placeholder).
class _DisputeSheet extends ConsumerStatefulWidget {
  const _DisputeSheet(this.orderId);

  final String orderId;

  @override
  ConsumerState<_DisputeSheet> createState() => _DisputeSheetState();
}

class _DisputeSheetState extends ConsumerState<_DisputeSheet> {
  _Problem? _reason;
  String _details = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    String label(_Problem p) => switch (p) {
          _Problem.damaged => l10n.problemDamaged,
          _Problem.wrongItem => l10n.problemWrongItem,
          _Problem.missingItems => l10n.problemMissingItems,
          _Problem.notAsDescribed => l10n.problemNotAsDescribed,
          _Problem.other => l10n.problemOther,
        };
    final ok = _reason != null && _details.trim().isNotEmpty && contactCheck(_details) == null;
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.fromSTEB(KafzaSpacing.lg, 0, KafzaSpacing.lg, KafzaSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.reportProblem, style: text.titleLarge),
            const SizedBox(height: KafzaSpacing.lg),
            Text(l10n.problemReason, style: text.titleMedium),
            RadioGroup<_Problem>(
              groupValue: _reason,
              onChanged: (v) => setState(() => _reason = v),
              child: Column(
                children: [
                  for (final p in _Problem.values)
                    RadioListTile<_Problem>(value: p, title: Text(label(p)), contentPadding: EdgeInsets.zero),
                ],
              ),
            ),
            const SizedBox(height: KafzaSpacing.md),
            KafzaTextField(
              label: l10n.problemDetails,
              value: _details,
              maxLength: 500,
              maxLines: 4,
              onChanged: (v) => setState(() => _details = v),
            ),
            const SizedBox(height: KafzaSpacing.md),
            // ponytail: photos are a placeholder; the prototype has no camera roll.
            Container(
              height: 72,
              decoration: BoxDecoration(
                color: context.kafza.muted,
                borderRadius: BorderRadius.circular(KafzaRadius.input),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: KafzaSpacing.sm,
                children: [
                  Icon(IconsaxPlusLinear.gallery_add, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  Flexible(child: Text(l10n.problemPhotos, style: text.bodyMedium)),
                ],
              ),
            ),
            const SizedBox(height: KafzaSpacing.xl),
            FilledButton(
              onPressed: ok
                  ? () {
                      try {
                        ref
                            .read(orderEngineProvider.notifier)
                            .openDispute(widget.orderId, l10n.labelValue(label(_reason!), _details.trim()));
                        _snack(context, l10n.problemSent);
                        Navigator.pop(context);
                      } on OrderException catch (e) {
                        _snack(context, l10n.orderError(e.error));
                      }
                    }
                  : null,
              child: Text(l10n.sendReport),
            ),
          ],
        ),
      ),
    );
  }
}
