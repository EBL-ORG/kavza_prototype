import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../format/price.dart';
import '../format/time.dart';
import '../l10n/app_localizations.dart';
import '../l10n/labels.dart';
import '../models/order.dart';
import '../theme/kafza_theme.dart';
import 'initial_image.dart';
import 'kafza_badge.dart';

/// One style per order status (DESIGN.md › Chips).
class StatusChip extends StatelessWidget {
  const StatusChip(this.status, {super.key});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final label = AppLocalizations.of(context).status(status);
    return switch (status) {
      OrderStatus.placed || OrderStatus.inPreparation || OrderStatus.ready || OrderStatus.pickedUp => KafzaBadge(label),
      OrderStatus.accepted => KafzaBadge(label, tone: BadgeTone.solid),
      OrderStatus.delivered => KafzaBadge(label, tone: BadgeTone.success, icon: IconsaxPlusBold.tick_circle),
      OrderStatus.deliveryFailed || OrderStatus.disputed => KafzaBadge(label, tone: BadgeTone.warning),
      _ => KafzaBadge(label, tone: BadgeTone.neutral),
    };
  }
}

/// Time left for the store to answer; warning style under 25% of the window.
class CountdownChip extends StatelessWidget {
  const CountdownChip({super.key, required this.deadline, required this.window, required this.now});

  final DateTime deadline, now;
  final Duration window;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final left = deadline.difference(now);
    return KafzaBadge(
      l10n.timeLeft(formatDuration(l10n, left)),
      icon: IconsaxPlusLinear.timer_1,
      tone: left < window * 0.25 ? BadgeTone.warning : BadgeTone.primary,
    );
  }
}

const _happyPath = [
  OrderStatus.placed,
  OrderStatus.accepted,
  OrderStatus.inPreparation,
  OrderStatus.ready,
  OrderStatus.pickedUp,
  OrderStatus.delivered,
];

/// Status history with times: done steps checked, the current one in primary, the steps
/// still ahead muted. Off-path endings (Declined, Expired…) have no steps ahead.
class StatusTimeline extends StatelessWidget {
  const StatusTimeline(this.order, {super.key});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final k = context.kafza;
    final i = _happyPath.indexOf(order.status);
    final ahead = i < 0 ? const <OrderStatus>[] : _happyPath.sublist(i + 1);
    final rows = [
      for (final (n, e) in order.history.indexed) (e.status, e.time, e.note, n == order.history.length - 1),
      for (final s in ahead) (s, null, null, false),
    ];

    Icon iconOf(OrderStatus s, bool current, bool future) {
      final (icon, color) = _icon(s, current, future, scheme, k);
      return Icon(icon, size: 22, color: color);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (n, (status, time, note, current)) in rows.indexed)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: KafzaSpacing.md,
              children: [
                Column(
                  children: [
                    iconOf(status, current, time == null),
                    if (n < rows.length - 1)
                      Expanded(
                        child: VerticalDivider(
                          width: 22,
                          thickness: 2,
                          // Primary up to the last step reached, muted after it.
                          color: rows[n + 1].$2 == null ? scheme.outline : scheme.primary,
                        ),
                      ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(bottom: KafzaSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.status(status),
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: current ? FontWeight.w600 : null,
                            color: time == null ? scheme.onSurfaceVariant : null,
                          ),
                        ),
                        if (time != null)
                          Text(
                            formatDateTime(l10n, time),
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
                          ),
                        if (note != null && note.isNotEmpty)
                          Text(isolate(note), style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  static (IconData, Color) _icon(OrderStatus s, bool current, bool future, ColorScheme scheme, KafzaTokens k) {
    if (future) return (IconsaxPlusLinear.record, scheme.onSurfaceVariant);
    if (!current) return (IconsaxPlusBold.tick_circle, scheme.primary);
    return switch (s) {
      OrderStatus.delivered => (IconsaxPlusBold.tick_circle, k.success),
      OrderStatus.deliveryFailed || OrderStatus.disputed => (IconsaxPlusLinear.danger, k.warning),
      _ when _happyPath.contains(s) => (IconsaxPlusBold.record_circle, scheme.primary),
      _ => (IconsaxPlusLinear.close_circle, scheme.onSurfaceVariant),
    };
  }
}

/// Each product of an order: picture, title, quantity and options, line total.
class OrderLines extends StatelessWidget {
  const OrderLines(this.order, {super.key});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final secondary = text.bodySmall!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: KafzaSpacing.md,
      children: [
        for (final l in order.lines)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: KafzaSpacing.md,
            children: [
              SizedBox.square(dimension: 48, child: InitialImage(l.title, id: l.productId)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    Text(isolate(l.title), style: text.bodyLarge),
                    Text(l10n.qty(l.unit, l.qty), style: secondary),
                    for (final x in l.options)
                      Text(l10n.labelValue(isolate(x.group), isolate(x.value)), style: secondary),
                  ],
                ),
              ),
              Text(
                formatPrice(context, l.total),
                style: text.labelLarge!.copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
              ),
            ],
          ),
      ],
    );
  }
}

/// Items · options · delivery fee (or "Free delivery") · total in bold.
class PriceBreakdown extends StatelessWidget {
  const PriceBreakdown({
    super.key,
    required this.itemsLabel,
    required this.items,
    this.options = 0,
    required this.deliveryFee,
    required this.freeDelivery,
  });

  final String itemsLabel;
  final int items, options, deliveryFee;
  final bool freeDelivery;

  int get total => items + options + (freeDelivery ? 0 : deliveryFee);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    const tabular = [FontFeature.tabularFigures()];
    Widget line(String label, String amount, {bool bold = false}) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: KafzaSpacing.md,
      children: [
        Expanded(child: Text(label, style: bold ? text.titleMedium : text.bodyMedium)),
        Text(
          amount,
          style: (bold ? text.titleMedium!.copyWith(fontWeight: FontWeight.w700) : text.bodyMedium!).copyWith(
            fontFeatures: tabular,
          ),
        ),
      ],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: KafzaSpacing.sm,
      children: [
        line(itemsLabel, formatPrice(context, items)),
        if (options > 0) line(l10n.optionsLine, formatPrice(context, options)),
        line(l10n.deliveryFeeLine, freeDelivery ? l10n.freeDelivery : formatPrice(context, deliveryFee)),
        const Divider(),
        line(l10n.totalLine, formatPrice(context, total), bold: true),
      ],
    );
  }
}
