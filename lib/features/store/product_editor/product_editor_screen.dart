import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../core/contact_check.dart';
import '../../../core/data/clock.dart';
import '../../../core/format/price.dart';
import '../../../core/format/time.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/models/catalog.dart';
import '../../../core/models/product.dart';
import '../../../core/models/store.dart';
import '../../../core/order_engine/order_engine.dart';
import '../../../core/theme/kafza_theme.dart';
import '../../../core/widgets/info_banner.dart';
import '../../../core/widgets/initial_image.dart';
import '../../../core/widgets/kafza_badge.dart';
import '../../../core/widgets/kafza_sheet.dart';
import '../../../core/widgets/kafza_text_field.dart';
import '../../../core/widgets/product_detail_view.dart';
import '../../../core/widgets/quantity_stepper.dart';
import '../store_providers.dart';
import '../store_widgets.dart';
import 'option_group_sheet.dart';

enum _Step { category, details, modes, rules, options, preview }

const _maxPhotos = 5;
const _readyTimes = [Duration(minutes: 15), Duration(minutes: 30), Duration(hours: 1), Duration(hours: 2), Duration(hours: 3)];
const _orderTimes = [
  Duration(hours: 6), Duration(hours: 12), Duration(hours: 24), Duration(hours: 48), Duration(days: 3), //
  Duration(days: 5), Duration(days: 7), Duration(days: 10), Duration(days: 14), Duration(days: 21),
];

/// Algerian week order for the day chips: Saturday first.
const _week = [DateTime.saturday, DateTime.sunday, DateTime.monday, DateTime.tuesday, DateTime.wednesday, DateTime.thursday, DateTime.friday];

/// S9: product editor in 6 steps (STR-12…15, STR-24/25). A draft is saved on every step change;
/// live and paused products save only at the end, so clients never see a half-edit.
class ProductEditorScreen extends ConsumerStatefulWidget {
  const ProductEditorScreen({super.key, this.id});

  /// Null creates a product.
  final String? id;

  @override
  ConsumerState<ProductEditorScreen> createState() => _ProductEditorScreenState();
}

class _ProductEditorScreenState extends ConsumerState<ProductEditorScreen> {
  late final String _storeId = ref.read(currentStoreProvider)!.id;
  String? _id;
  ProductStatus _status = ProductStatus.draft;
  _Step _step = _Step.category;
  bool _showErrors = false;
  DateTime? _savedAt;

  Category? _category;
  int _photos = 0;
  String _title = '', _description = '', _ingredients = '';
  Unit _unit = Unit.piece;
  bool _freeDelivery = false;

  bool _rmOn = false;
  String _rmPrice = '';
  int _rmStock = 1, _rmAlert = 3;
  Duration _rmPrep = const Duration(hours: 1);

  bool _mtoOn = false, _suggested = false;
  String _mtoPrice = '';
  num _min = 1, _qtyStep = 1;
  num? _max;
  Duration _lead = const Duration(hours: 48), _mtoPrep = const Duration(hours: 24);
  Set<int> _days = {..._week};
  List<OptionGroup> _groups = [];

  @override
  void initState() {
    super.initState();
    _id = widget.id;
    if (_id == null) return;
    final p = ref.read(orderEngineProvider).product(_id!);
    _status = p.status;
    _category = p.category;
    _photos = p.photos;
    _title = p.title;
    _description = p.description;
    _ingredients = p.ingredients;
    _unit = p.unit;
    _freeDelivery = p.freeDelivery;
    if (p.readyMade case final rm?) {
      _rmOn = true;
      _rmPrice = '${rm.price}';
      _rmStock = rm.stock;
      _rmAlert = rm.lowStockAlert;
      _rmPrep = rm.prepTime;
    }
    if (p.madeToOrder case final m?) {
      _mtoOn = true;
      _mtoPrice = '${m.price}';
      _min = m.minQty;
      _qtyStep = m.step;
      _max = m.maxQty;
      _lead = m.leadTime;
      _mtoPrep = m.prepTime;
      _days = {...m.availableDays};
      _groups = [...m.optionGroups];
    }
  }

  List<_Step> get _flow =>
      [_Step.category, _Step.details, _Step.modes, if (_mtoOn) ...[_Step.rules, _Step.options], _Step.preview];

  /// Quantities move by 0.5 for kg, by 1 otherwise.
  num get _unitStep => _unit == Unit.kg ? 0.5 : 1;

  int get _rmPriceValue => int.tryParse(_rmPrice) ?? 0;
  int get _mtoPriceValue => int.tryParse(_mtoPrice) ?? 0;

  Category? get _freeCategory => ref.read(orderEngineProvider).freeCategory(_storeId, except: _id);

  bool _locked(Category c) => _freeCategory != null && _freeCategory != c;

  bool _valid(_Step s) => switch (s) {
        _Step.category => _category != null && !_locked(_category!),
        _Step.details => _photos > 0 &&
            _title.trim().isNotEmpty &&
            [_title, _description, _ingredients].every((t) => contactCheck(t) == null),
        _Step.modes => (_rmOn || _mtoOn) && (!_rmOn || _rmPriceValue > 0),
        _Step.rules => _mtoPriceValue > 0 && _days.isNotEmpty && _mtoPrep <= _lead && (_max == null || _max! >= _min),
        _Step.options || _Step.preview => true,
      };

  Product _product(ProductStatus status) => Product(
        id: _id ?? '',
        storeId: _storeId,
        category: _category!,
        title: _title,
        description: _description,
        ingredients: _ingredients,
        unit: _unit,
        photos: _photos,
        freeDelivery: _freeDelivery,
        status: status,
        readyMade: _rmOn
            ? ReadyMade(price: _rmPriceValue, stock: _rmStock, prepTime: _rmPrep, lowStockAlert: _rmAlert)
            : null,
        madeToOrder: _mtoOn
            ? MadeToOrder(
                price: _mtoPriceValue,
                minQty: _min,
                maxQty: _max,
                step: _qtyStep,
                leadTime: _lead,
                prepTime: _mtoPrep,
                availableDays: _days,
                optionGroups: _groups,
              )
            : null,
        createdAt: ref.read(clockProvider),
      );

  /// Drafts only. A refusal (contact details, locked category) is already shown on the step.
  void _autosave() {
    if (_status != ProductStatus.draft || _category == null) return;
    try {
      _id = ref.read(orderEngineProvider.notifier).saveProduct(_product(ProductStatus.draft));
      _savedAt = ref.read(clockProvider);
    } on OrderException catch (_) {}
  }

  /// "Suggested by Kafza": rules prefilled the first time made to order is switched on.
  void _suggest() {
    final food = _category?.isFood ?? true;
    final sewing = _category?.service == Service.sewing;
    _min = _unitStep;
    _qtyStep = _unitStep;
    _max = null;
    _lead = food ? const Duration(hours: 48) : (sewing ? const Duration(days: 14) : const Duration(days: 7));
    _mtoPrep = food ? const Duration(hours: 24) : (sewing ? const Duration(days: 10) : const Duration(days: 5));
    _days = food ? (_week.toSet()..remove(DateTime.friday)) : {..._week};
    if (_mtoPrice.isEmpty) _mtoPrice = _rmPrice;
    _suggested = true;
  }

  void _next() {
    if (!_valid(_step)) return setState(() => _showErrors = true);
    _autosave();
    setState(() {
      _step = _flow[_flow.indexOf(_step) + 1];
      _showErrors = false;
    });
  }

  void _back() {
    _autosave();
    setState(() {
      _step = _flow[_flow.indexOf(_step) - 1];
      _showErrors = false;
    });
  }

  void _close() {
    _autosave();
    if (_savedAt != null) snack(context, AppLocalizations.of(context).draftSaved);
    Navigator.pop(context);
  }

  void _finish(ProductStatus status) {
    final l10n = AppLocalizations.of(context);
    try {
      ref.read(orderEngineProvider.notifier).saveProduct(_product(status));
      snack(
        context,
        switch (status) {
          ProductStatus.live when _status == ProductStatus.draft => l10n.publishedDone,
          ProductStatus.draft => l10n.draftSaved,
          _ => l10n.changesSaved,
        },
      );
      Navigator.pop(context);
    } on OrderException catch (e) {
      snack(context, e.error == OrderError.notAllowed ? l10n.publishLocked : l10n.orderError(e.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final store = ref.watch(currentStoreProvider)!;
    final flow = _flow;
    final index = flow.indexOf(_step);
    final stepTitle = switch (_step) {
      _Step.category => l10n.editorCategory,
      _Step.details => l10n.editorDetails,
      _Step.modes => l10n.editorModes,
      _Step.rules => l10n.editorRules,
      _Step.options => l10n.editorOptions,
      _Step.preview => l10n.editorPreview,
    };

    return PopScope(
      canPop: index == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.id == null ? l10n.newProduct : l10n.editProduct),
          actions: [IconButton(icon: const Icon(IconsaxPlusLinear.close_circle), tooltip: l10n.closeEditor, onPressed: _close)],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(KafzaSpacing.lg, 0, KafzaSpacing.lg, KafzaSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: KafzaSpacing.sm,
                children: [
                  LinearProgressIndicator(
                    value: (index + 1) / flow.length,
                    minHeight: 4,
                    borderRadius: BorderRadius.circular(2),
                    backgroundColor: Theme.of(context).colorScheme.outline,
                  ),
                  Text(l10n.stepOf(index + 1, flow.length, stepTitle), style: text.titleMedium),
                  if (_savedAt case final t?)
                    Text(
                      l10n.draftSavedAt(ltr(DateFormat.Hm(l10n.localeName).format(t))),
                      style: text.bodySmall!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                key: ValueKey(_step),
                padding: _step == _Step.preview ? EdgeInsets.zero : const EdgeInsets.all(KafzaSpacing.lg),
                children: switch (_step) {
                  _Step.category => _categoryStep(l10n, text),
                  _Step.details => _detailsStep(l10n, text),
                  _Step.modes => _modesStep(l10n, text),
                  _Step.rules => _rulesStep(l10n, text),
                  _Step.options => _optionsStep(l10n, text),
                  _Step.preview => [
                      Padding(
                        padding: const EdgeInsets.all(KafzaSpacing.lg),
                        child: InfoBanner(icon: IconsaxPlusLinear.eye, text: l10n.previewHint),
                      ),
                      ProductDetailView(product: _product(_status), store: store),
                    ],
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomBar(
          children: _step != _Step.preview
              ? [FilledButton(onPressed: _next, child: Text(l10n.next))]
              : _status != ProductStatus.draft
                  ? [FilledButton(onPressed: () => _finish(_status), child: Text(l10n.saveChanges))]
                  : [
                      if (store.status != StoreStatus.approved)
                        Text(
                          l10n.publishLocked,
                          textAlign: TextAlign.center,
                          style: text.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                      FilledButton(
                        onPressed: store.status == StoreStatus.approved ? () => _finish(ProductStatus.live) : null,
                        child: Text(l10n.publish),
                      ),
                      OutlinedButton(onPressed: () => _finish(ProductStatus.draft), child: Text(l10n.saveDraft)),
                    ],
        ),
      ),
    );
  }

  Widget _error(String message) => Padding(
        padding: const EdgeInsetsDirectional.only(top: KafzaSpacing.sm),
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.error),
        ),
      );

  /// Label at the start, stepper at the end.
  Widget _stepperRow(String label, Widget stepper) => Padding(
        padding: const EdgeInsetsDirectional.only(top: KafzaSpacing.md),
        child: Row(
          spacing: KafzaSpacing.sm,
          children: [Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyLarge)), stepper],
        ),
      );

  Widget _durationField(String label, Duration value, List<Duration> choices, ValueChanged<Duration> onChanged,
      {String? error}) {
    final l10n = AppLocalizations.of(context);
    final items = ({...choices, value}.toList()..sort());
    return DropdownButtonFormField<Duration>(
      initialValue: value,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(labelText: label, errorText: error, errorMaxLines: 3),
      items: [for (final d in items) DropdownMenuItem(value: d, child: Text(formatDuration(l10n, d)))],
      onChanged: (d) => setState(() => onChanged(d!)),
    );
  }

  List<Widget> _categoryStep(AppLocalizations l10n, TextTheme text) {
    final free = _freeCategory;
    return [
      if (free != null) ...[
        InfoBanner(icon: IconsaxPlusLinear.crown_1, text: l10n.freePlanCategory(l10n.category(free)), onTap: () => showProSheet(context)),
        const SizedBox(height: KafzaSpacing.md),
      ],
      RadioGroup<Category>(
        groupValue: _category,
        onChanged: (c) => setState(() => _category = c),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final s in Service.values) ...[
              Padding(
                padding: const EdgeInsetsDirectional.only(top: KafzaSpacing.lg, bottom: KafzaSpacing.xs),
                child: Text(l10n.service(s), style: text.titleMedium),
              ),
              for (final c in Category.values.where((c) => c.service == s))
                _locked(c)
                    ? ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Padding(
                          padding: EdgeInsetsDirectional.symmetric(horizontal: KafzaSpacing.md),
                          child: Icon(IconsaxPlusLinear.lock),
                        ),
                        title: Text(l10n.category(c)),
                        trailing: KafzaBadge(l10n.badgePro, tone: BadgeTone.solid),
                        onTap: () => showProSheet(context),
                      )
                    : RadioListTile<Category>(value: c, title: Text(l10n.category(c)), contentPadding: EdgeInsets.zero),
            ],
          ],
        ),
      ),
      if (_showErrors && _category == null) _error(l10n.chooseCategory),
    ];
  }

  List<Widget> _detailsStep(AppLocalizations l10n, TextTheme text) {
    final scheme = Theme.of(context).colorScheme;
    return [
      Text(l10n.photos, style: text.titleMedium),
      const SizedBox(height: KafzaSpacing.sm),
      // ponytail: placeholder photos (the prototype ships no camera roll); a tile adds one.
      Wrap(
        spacing: KafzaSpacing.sm,
        runSpacing: KafzaSpacing.sm,
        children: [
          for (var i = 0; i < _photos; i++)
            SizedBox.square(
              dimension: 80,
              child: Stack(
                children: [
                  Positioned.fill(child: InitialImage(_title.isEmpty ? '${i + 1}' : _title, id: _id, page: i)),
                  PositionedDirectional(
                    top: 0,
                    end: 0,
                    child: IconButton(
                      tooltip: l10n.removePhoto,
                      icon: Icon(IconsaxPlusBold.close_circle, color: scheme.onSurfaceVariant),
                      onPressed: () => setState(() => _photos--),
                    ),
                  ),
                ],
              ),
            ),
          if (_photos < _maxPhotos)
            Semantics(
              button: true,
              label: l10n.addPhoto,
              excludeSemantics: true,
              child: InkWell(
                onTap: () => setState(() => _photos++),
                borderRadius: BorderRadius.circular(KafzaRadius.input),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: _showErrors && _photos == 0 ? scheme.error : scheme.outline),
                    borderRadius: BorderRadius.circular(KafzaRadius.input),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(IconsaxPlusLinear.gallery_add, color: scheme.primary),
                      Text(l10n.addPhotoShort, style: text.bodySmall!.copyWith(color: scheme.primary)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      if (_showErrors && _photos == 0) _error(l10n.photosRequired),
      const SizedBox(height: KafzaSpacing.xl),
      KafzaTextField(
        label: l10n.productTitle,
        value: _title,
        maxLength: 60,
        error: _showErrors && _title.trim().isEmpty ? l10n.titleRequired : null,
        onChanged: (v) => setState(() => _title = v),
      ),
      const SizedBox(height: KafzaSpacing.sm),
      KafzaTextField(
        label: l10n.productDescription,
        value: _description,
        maxLength: 500,
        maxLines: 4,
        onChanged: (v) => setState(() => _description = v),
      ),
      if (_category!.isFood) ...[
        const SizedBox(height: KafzaSpacing.sm),
        KafzaTextField(
          label: l10n.ingredients,
          helper: l10n.ingredientsHelper,
          value: _ingredients,
          maxLength: 300,
          maxLines: 3,
          onChanged: (v) => setState(() => _ingredients = v),
        ),
      ],
      const SizedBox(height: KafzaSpacing.lg),
      Text(l10n.sellBy, style: text.titleMedium),
      const SizedBox(height: KafzaSpacing.sm),
      Wrap(
        spacing: KafzaSpacing.sm,
        runSpacing: KafzaSpacing.sm,
        children: [
          for (final u in Unit.values)
            ChoiceChip(
              label: Text(l10n.unit(u)),
              selected: _unit == u,
              onSelected: (_) => setState(() {
                _unit = u;
                // Whole quantities again when leaving kg.
                if (u != Unit.kg) {
                  _min = _min.ceil();
                  _qtyStep = _qtyStep.ceil();
                  _max = _max?.ceil();
                }
              }),
            ),
        ],
      ),
      const SizedBox(height: KafzaSpacing.lg),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(l10n.freeDelivery),
        subtitle: Text(l10n.freeDeliveryHint),
        value: _freeDelivery,
        onChanged: (v) => setState(() => _freeDelivery = v),
      ),
    ];
  }

  List<Widget> _modesStep(AppLocalizations l10n, TextTheme text) {
    final unit = l10n.unit(_unit);
    return [
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(l10n.readyMadeTitle, style: text.titleMedium),
        subtitle: Text(l10n.readyMadeHint),
        value: _rmOn,
        onChanged: (v) => setState(() => _rmOn = v),
      ),
      if (_rmOn) ...[
        const SizedBox(height: KafzaSpacing.sm),
        NumberField(
          label: l10n.pricePer(unit),
          value: _rmPrice,
          suffix: l10n.currency,
          error: _showErrors && _rmPriceValue <= 0 ? l10n.priceRequired : null,
          onChanged: (v) => setState(() => _rmPrice = v),
        ),
        _stepperRow(
          l10n.stockLabel,
          QuantityStepper(
            value: _rmStock,
            min: 0,
            label: '$_rmStock',
            onChanged: (v) => setState(() => _rmStock = v.toInt()),
          ),
        ),
        _stepperRow(
          l10n.lowStockAlertLabel,
          QuantityStepper(
            value: _rmAlert,
            min: 0,
            max: 50,
            label: '$_rmAlert',
            onChanged: (v) => setState(() => _rmAlert = v.toInt()),
          ),
        ),
        const SizedBox(height: KafzaSpacing.lg),
        _durationField(l10n.readyInLabel, _rmPrep, _readyTimes, (d) => _rmPrep = d),
      ],
      const SizedBox(height: KafzaSpacing.lg),
      const Divider(),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(l10n.madeToOrderTitle, style: text.titleMedium),
        subtitle: Text(l10n.madeToOrderHint),
        value: _mtoOn,
        onChanged: (v) => setState(() {
          _mtoOn = v;
          if (v && _mtoPrice.isEmpty) _suggest();
        }),
      ),
      if (_showErrors && !_rmOn && !_mtoOn) _error(l10n.modeRequired),
    ];
  }

  List<Widget> _rulesStep(AppLocalizations l10n, TextTheme text) {
    String qty(num n) => l10n.qty(_unit, n);
    return [
      if (_suggested) ...[
        InfoBanner(icon: IconsaxPlusLinear.magic_star, text: l10n.suggestedByKafza),
        const SizedBox(height: KafzaSpacing.lg),
      ],
      NumberField(
        label: l10n.pricePer(l10n.unit(_unit)),
        value: _mtoPrice,
        suffix: l10n.currency,
        error: _showErrors && _mtoPriceValue <= 0 ? l10n.priceRequired : null,
        onChanged: (v) => setState(() => _mtoPrice = v),
      ),
      _stepperRow(
        l10n.minPerOrder,
        QuantityStepper(
          value: _min,
          min: _unitStep,
          step: _unitStep,
          label: qty(_min),
          onChanged: (v) => setState(() {
            _min = v;
            if (_max != null && _max! < v) _max = v;
          }),
        ),
      ),
      _stepperRow(
        l10n.orderBy,
        QuantityStepper(
          value: _qtyStep,
          min: _unitStep,
          step: _unitStep,
          label: qty(_qtyStep),
          onChanged: (v) => setState(() => _qtyStep = v),
        ),
      ),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(l10n.setMaximum),
        value: _max != null,
        onChanged: (v) => setState(() => _max = v ? _min : null),
      ),
      if (_max case final max?)
        _stepperRow(
          l10n.maxPerOrder,
          QuantityStepper(
            value: max,
            min: _min,
            step: _unitStep,
            label: qty(max),
            onChanged: (v) => setState(() => _max = v),
          ),
        ),
      const SizedBox(height: KafzaSpacing.lg),
      _durationField(l10n.leadTimeLabel, _lead, _orderTimes, (d) => _lead = d),
      const SizedBox(height: KafzaSpacing.lg),
      _durationField(
        l10n.prepTimeLabel,
        _mtoPrep,
        _orderTimes,
        (d) => _mtoPrep = d,
        error: _mtoPrep > _lead ? l10n.prepLongerThanLead : null,
      ),
      const SizedBox(height: KafzaSpacing.xl),
      Text(l10n.deliveryDays, style: text.titleMedium),
      const SizedBox(height: KafzaSpacing.sm),
      Wrap(
        spacing: KafzaSpacing.sm,
        runSpacing: KafzaSpacing.sm,
        children: [
          for (final d in _week)
            FilterChip(
              label: Text(formatWeekdays(l10n, {d})),
              selected: _days.contains(d),
              onSelected: (on) => setState(() => on ? _days.add(d) : _days.remove(d)),
            ),
        ],
      ),
      if (_showErrors && _days.isEmpty) _error(l10n.daysRequired),
    ];
  }

  List<Widget> _optionsStep(AppLocalizations l10n, TextTheme text) {
    final secondary = Theme.of(context).colorScheme.onSurfaceVariant;

    Future<void> edit([int? i]) async {
      final g = await showKafzaSheet<OptionGroup>(
        context,
        (_) => OptionGroupSheet(
          // Ids only need to be unique inside the product.
          id: i == null ? 'g-${ref.read(clockProvider).microsecondsSinceEpoch}' : _groups[i].id,
          group: i == null ? null : _groups[i],
          unit: _unit,
        ),
      );
      if (g == null) return;
      setState(() => i == null ? _groups.add(g) : _groups[i] = g);
    }

    String summary(OptionGroup g) => [
          l10n.optionType(g.type),
          g.required ? l10n.required : l10n.optional,
          if (g.type == OptionType.text)
            l10n.maxChars(g.maxLength)
          else
            g.choices
                .map((c) => c.price == 0
                    ? isolate(c.name)
                    : '${isolate(c.name)} +${formatPrice(context, c.price)}${c.perUnit ? ' / ${l10n.unit(_unit)}' : ''}')
                .join(l10n.listSeparator),
        ].join(' · ');

    return [
      InfoBanner(icon: IconsaxPlusLinear.setting_4, text: l10n.optionsIntro),
      const SizedBox(height: KafzaSpacing.lg),
      if (_groups.isEmpty)
        Text(l10n.noOptions, style: text.bodyMedium!.copyWith(color: secondary))
      else
        for (final (i, g) in _groups.indexed)
          Padding(
            padding: const EdgeInsetsDirectional.only(bottom: KafzaSpacing.sm),
            child: Card(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(KafzaSpacing.lg, KafzaSpacing.md, KafzaSpacing.xs, KafzaSpacing.md),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: KafzaSpacing.xs,
                        children: [
                          Text(isolate(g.name), style: text.titleMedium),
                          Text(summary(g), style: text.bodySmall!.copyWith(color: secondary)),
                        ],
                      ),
                    ),
                    IconButton(tooltip: l10n.edit, icon: const Icon(IconsaxPlusLinear.edit_2), onPressed: () => edit(i)),
                    IconButton(
                      tooltip: l10n.delete,
                      icon: const Icon(IconsaxPlusLinear.trash),
                      onPressed: () => setState(() => _groups.removeAt(i)),
                    ),
                  ],
                ),
              ),
            ),
          ),
      const SizedBox(height: KafzaSpacing.md),
      OutlinedButton.icon(onPressed: edit, icon: const Icon(IconsaxPlusLinear.add), label: Text(l10n.addOptionGroup)),
    ];
  }
}
