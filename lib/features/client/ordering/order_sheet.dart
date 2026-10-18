import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/contact_check.dart';
import '../../../core/data/clock.dart';
import '../../../core/data/seed.dart';
import '../../../core/format/price.dart';
import '../../../core/format/time.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/models/order.dart';
import '../../../core/models/product.dart';
import '../../../core/order_engine/order_engine.dart';
import '../../../core/theme/kafza_theme.dart';
import '../../../core/widgets/kafza_sheet.dart';
import '../../../core/widgets/kafza_text_field.dart';
import '../../../core/widgets/order_widgets.dart';
import '../../../core/widgets/quantity_stepper.dart';
import '../client_providers.dart';
import '../client_widgets.dart';

/// What the order sheet hands to the summary. The address is `addressIdProvider`.
class OrderDraft {
  const OrderDraft({required this.productId, required this.type, required this.qty, this.picks = const {}, this.date});

  final String productId;
  final OrderType type;
  final num qty;

  /// Option group id → choice ids, or the typed text for text groups.
  final Map<String, List<String>> picks;
  final DateTime? date;
}

/// Unit price × qty, and the options on top (what PriceBreakdown shows).
({int items, int options}) draftAmounts(Product p, OrderDraft d) {
  final unit = d.type == OrderType.readyMade ? p.readyMade!.price : p.madeToOrder!.price;
  final items = (unit * d.qty).round();
  return (items: items, options: itemTotalOf(p, d.type, d.qty, d.picks) - items);
}

/// "2 × 2 400 DA".
String itemsLabel(BuildContext context, Product p, OrderType type, num qty) {
  final l10n = AppLocalizations.of(context);
  final unit = type == OrderType.readyMade ? p.readyMade!.price : p.madeToOrder!.price;
  return l10n.itemsLine(l10n.qty(p.unit, qty), formatPrice(context, unit));
}

/// The first day a made-to-order product can be delivered, within 60 days.
DateTime? firstDeliveryDay(MadeToOrder m, DateTime now) {
  for (var i = 0; i < 60; i++) {
    final d = DateTime(now.year, now.month, now.day + i);
    if (isValidDeliveryDay(m, d, now)) return d;
  }
  return null;
}

/// C6: "Order now" (qty + address) or "Order made for me" (qty, options, date, address).
Future<OrderDraft?> showOrderSheet(BuildContext context, String productId, OrderType type) =>
    showKafzaSheet<OrderDraft>(context, (_) => _OrderSheet(productId, type));

class _OrderSheet extends ConsumerStatefulWidget {
  const _OrderSheet(this.productId, this.type);

  final String productId;
  final OrderType type;

  @override
  ConsumerState<_OrderSheet> createState() => _OrderSheetState();
}

class _OrderSheetState extends ConsumerState<_OrderSheet> {
  num? _qty;
  final _picks = <String, List<String>>{};
  DateTime? _date;

  void _pick(String group, List<String> values) => setState(() => _picks[group] = values);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final secondary = Theme.of(context).colorScheme.onSurfaceVariant;
    final state = ref.watch(orderEngineProvider);
    ref.watch(clockProvider.select((t) => t.millisecondsSinceEpoch ~/ 60000));
    final now = ref.read(clockProvider);
    final p = state.product(widget.productId);
    final store = state.store(p.storeId);
    final made = widget.type == OrderType.madeToOrder;
    final m = p.madeToOrder;
    final rm = p.readyMade;

    final min = made ? m!.minQty : 1;
    final max = made ? m!.maxQty : rm!.available;
    var qty = _qty ?? min;
    if (max != null && qty > max && max >= min) qty = max; // stock went down while the sheet was open
    final soldOut = !made && rm!.available < 1;

    // What still blocks Continue. Each problem is also shown next to its field.
    final missing = <String>[];
    var blocked = soldOut;
    for (final g in m?.optionGroups ?? const <OptionGroup>[]) {
      if (!made) break;
      final picked = _picks[g.id] ?? const [];
      final value = g.type == OptionType.text ? (picked.firstOrNull ?? '').trim() : null;
      if (g.required && (value?.isEmpty ?? picked.isEmpty)) missing.add(isolate(g.name));
      if (value != null && contactCheck(value) != null) blocked = true;
    }
    final firstDay = made ? firstDeliveryDay(m!, now) : null;
    final dateExpired = made && _date != null && !isValidDeliveryDay(m!, _date!, now);
    if (made && (_date == null || dateExpired)) missing.add(l10n.deliveryDate);
    final valid = missing.isEmpty && !blocked;

    final draft = OrderDraft(
      productId: p.id,
      type: widget.type,
      qty: qty,
      picks: {for (final e in _picks.entries) e.key: [for (final v in e.value) v.trim()]},
      date: _date,
    );
    final amounts = draftAmounts(p, draft);
    final fee = deliveryFee(store.distanceKm);
    final total = amounts.items + amounts.options + (p.freeDelivery ? 0 : fee);

    Widget section(String title, Widget child, {String? hint, String? error}) => Padding(
          padding: const EdgeInsetsDirectional.only(top: KafzaSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: KafzaSpacing.sm,
            children: [
              Text(title, style: text.titleMedium),
              child,
              if (error != null)
                Text(error, style: text.bodySmall!.copyWith(color: Theme.of(context).colorScheme.error))
              else if (hint != null)
                Text(hint, style: text.bodySmall!.copyWith(color: secondary)),
            ],
          ),
        );

    String choiceLabel(OptionChoice c) {
      if (c.price == 0) return isolate(c.name);
      final price = ltr('+${formatPrice(context, c.price)}');
      return '${isolate(c.name)} · ${c.perUnit ? l10n.pricePerUnit(price, l10n.unit(p.unit)) : price}';
    }

    Widget group(OptionGroup g) {
      final picked = _picks[g.id] ?? const <String>[];
      final title = '${isolate(g.name)} · ${g.required ? l10n.required : l10n.optional}';
      return switch (g.type) {
        OptionType.single => section(
            title,
            RadioGroup<String>(
              groupValue: picked.firstOrNull,
              onChanged: (v) => _pick(g.id, [v!]),
              child: Column(
                children: [
                  for (final c in g.choices)
                    RadioListTile<String>(value: c.id, title: Text(choiceLabel(c)), contentPadding: EdgeInsets.zero),
                ],
              ),
            ),
          ),
        OptionType.multiple => section(
            title,
            Wrap(
              spacing: KafzaSpacing.sm,
              runSpacing: KafzaSpacing.sm,
              children: [
                for (final c in g.choices)
                  FilterChip(
                    label: Text(choiceLabel(c)),
                    selected: picked.contains(c.id),
                    onSelected: (on) => _pick(g.id, on ? [...picked, c.id] : [...picked]..remove(c.id)),
                  ),
              ],
            ),
          ),
        OptionType.colour => section(
            title,
            Wrap(
              spacing: KafzaSpacing.sm,
              children: [
                for (final c in g.choices) _Swatch(c, selected: picked.contains(c.id), onTap: () => _pick(g.id, [c.id])),
              ],
            ),
            hint: g.choices.where((c) => picked.contains(c.id)).map((c) => isolate(c.name)).firstOrNull,
          ),
        OptionType.text => Padding(
            padding: const EdgeInsetsDirectional.only(top: KafzaSpacing.xl),
            child: KafzaTextField(
              label: title,
              value: picked.firstOrNull ?? '',
              maxLength: g.maxLength,
              onChanged: (v) => _pick(g.id, [v]),
            ),
          ),
      };
    }

    Future<void> pickDate() async {
      final d = await showDatePicker(
        context: appRootContext(context),
        useRootNavigator: false,
        initialDate: _date != null && !dateExpired ? _date : firstDay,
        firstDate: firstDay!,
        lastDate: firstDay.add(const Duration(days: 90)),
        selectableDayPredicate: (d) => isValidDeliveryDay(m!, d, now),
      );
      if (d != null) setState(() => _date = d);
    }

    final address = ref.watch(addressIdProvider);
    final client = state.client(demoClientId);
    final a = client.addresses.firstWhere((a) => a.id == address, orElse: () => client.addresses.first);

    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsetsDirectional.fromSTEB(KafzaSpacing.lg, 0, KafzaSpacing.lg, KafzaSpacing.lg),
              children: [
                Text(made ? l10n.orderMadeForMe : l10n.orderNow, style: text.titleLarge),
                Text(isolate(p.title), style: text.bodyMedium!.copyWith(color: secondary)),
                section(
                  l10n.quantity,
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: QuantityStepper(
                      value: qty,
                      min: min,
                      max: max,
                      step: made ? m!.step : 1,
                      label: l10n.qty(p.unit, qty),
                      onChanged: soldOut ? (_) {} : (v) => setState(() => _qty = v),
                    ),
                  ),
                  hint: made
                      ? [
                          l10n.ruleMin(l10n.qty(p.unit, m!.minQty)),
                          if (m.step != 1) l10n.ruleStep(l10n.qty(p.unit, m.step)),
                          if (m.maxQty case final x?) l10n.ruleMax(l10n.qty(p.unit, x)),
                        ].join(l10n.listSeparator)
                      : l10n.inStock(l10n.qty(p.unit, rm!.available)),
                  error: soldOut ? l10n.errorOutOfStock : null,
                ),
                if (made) ...[
                  for (final g in m!.optionGroups) group(g),
                  section(
                    l10n.deliveryDate,
                    OutlinedButton.icon(
                      onPressed: firstDay == null ? null : pickDate,
                      icon: const Icon(IconsaxPlusLinear.calendar_1),
                      label: Text(_date == null ? l10n.chooseDate : formatDay(l10n, _date!)),
                      style: OutlinedButton.styleFrom(alignment: AlignmentDirectional.centerStart),
                    ),
                    hint: [
                      l10n.ruleLead(formatDuration(l10n, m.leadTime)),
                      m.availableDays.length == 7 ? l10n.ruleEveryDay : l10n.ruleDays(formatWeekdays(l10n, m.availableDays)),
                    ].join('\n'),
                    error: dateExpired ? l10n.errorInvalidDate : null,
                  ),
                ],
                section(
                  l10n.chooseAddress,
                  Material(
                    color: context.kafza.muted,
                    borderRadius: BorderRadius.circular(KafzaRadius.input),
                    child: ListTile(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(KafzaRadius.input)),
                      leading: const Icon(IconsaxPlusLinear.location),
                      title: Text(isolate(a.label)),
                      subtitle: Text(isolate('${a.street}, ${a.commune}')),
                      trailing: const Icon(KafzaIcons.chevronEnd),
                      onTap: () => showKafzaSheet<void>(context, (_) => const AddressSheet()),
                    ),
                  ),
                  hint: made
                      ? l10n.etaMadeToOrder
                      : l10n.etaReadyMade(formatDuration(l10n, rm!.prepTime + deliveryEta(store.distanceKm))),
                ),
                const SizedBox(height: KafzaSpacing.xl),
                PriceBreakdown(
                  itemsLabel: itemsLabel(context, p, widget.type, qty),
                  items: amounts.items,
                  options: amounts.options,
                  deliveryFee: fee,
                  freeDelivery: p.freeDelivery,
                ),
              ],
            ),
          ),
          // Sticky bar: the live total and Continue, with what is missing right above it.
          DecoratedBox(
            decoration: BoxDecoration(border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant))),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(KafzaSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: KafzaSpacing.sm,
                  children: [
                    if (missing.isNotEmpty)
                      Text(
                        l10n.toContinue(missing.join(l10n.listSeparator)),
                        style: text.bodySmall!.copyWith(color: secondary),
                      ),
                    FilledButton(
                      onPressed: valid ? () => Navigator.pop(context, draft) : null,
                      child: Text(l10n.continueTotal(formatPrice(context, total))),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A colour choice: 48 px target, 36 px dot, primary ring when selected.
class _Swatch extends StatelessWidget {
  const _Swatch(this.choice, {required this.selected, required this.onTap});

  final OptionChoice choice;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      label: choice.name,
      selected: selected,
      button: true,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: selected ? Border.all(color: scheme.primary, width: 2) : null,
          ),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.kafza.swatches[choice.swatch ?? 0],
              border: Border.all(color: scheme.outlineVariant),
            ),
          ),
        ),
      ),
    );
  }
}
