import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../core/contact_check.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/models/product.dart';
import '../../../core/theme/kafza_theme.dart';
import '../../../core/widgets/kafza_text_field.dart';
import '../../../core/widgets/quantity_stepper.dart';
import '../store_widgets.dart';

/// One choice while it's being edited.
class _Choice {
  _Choice(this.id, {this.name = '', this.price = '', this.perUnit = false, this.swatch = 0});

  final String id;
  String name, price;
  bool perUnit;
  int swatch;
}

/// S9 step 5: one option group. Pops the finished [OptionGroup].
class OptionGroupSheet extends StatefulWidget {
  const OptionGroupSheet({super.key, required this.id, this.group, required this.unit});

  /// The group's id; choice ids derive from it.
  final String id;
  final OptionGroup? group;
  final Unit unit;

  @override
  State<OptionGroupSheet> createState() => _OptionGroupSheetState();
}

class _OptionGroupSheetState extends State<OptionGroupSheet> {
  late final String _id = widget.id;
  int _nextChoice = 0;
  late String _name = widget.group?.name ?? '';
  late OptionType _type = widget.group?.type ?? OptionType.single;
  late bool _required = widget.group?.required ?? false;
  late int _maxLength = widget.group?.maxLength ?? 30;
  bool _showErrors = false;
  late final List<_Choice> _choices = [
    for (final c in widget.group?.choices ?? const <OptionChoice>[])
      _Choice(c.id, name: c.name, price: c.price == 0 ? '' : '${c.price}', perUnit: c.perUnit, swatch: c.swatch ?? 0),
  ];

  _Choice _newChoice() => _Choice('$_id-c${_nextChoice++}-${_choices.length}', swatch: _choices.length % 6);

  @override
  void initState() {
    super.initState();
    if (_choices.isEmpty) _choices.add(_newChoice());
  }

  bool get _valid =>
      _name.trim().isNotEmpty &&
      contactCheck(_name) == null &&
      (_type == OptionType.text ||
          (_choices.isNotEmpty && _choices.every((c) => c.name.trim().isNotEmpty && contactCheck(c.name) == null)));

  OptionGroup _build() => OptionGroup(
        _id,
        _name.trim(),
        _type,
        required: _required,
        maxLength: _maxLength,
        choices: _type == OptionType.text
            ? const []
            : [
                for (final c in _choices)
                  OptionChoice(
                    c.id,
                    c.name.trim(),
                    price: int.tryParse(c.price) ?? 0,
                    perUnit: c.perUnit,
                    swatch: _type == OptionType.colour ? c.swatch : null,
                  ),
              ],
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final swatches = context.kafza.swatches;

    Widget choice(_Choice c) => Container(
          key: ValueKey(c.id),
          margin: const EdgeInsetsDirectional.only(bottom: KafzaSpacing.sm),
          padding: const EdgeInsetsDirectional.fromSTEB(KafzaSpacing.md, KafzaSpacing.md, KafzaSpacing.xs, KafzaSpacing.md),
          decoration: BoxDecoration(
            border: Border.all(color: scheme.outlineVariant),
            borderRadius: BorderRadius.circular(KafzaRadius.input),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: KafzaSpacing.sm,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: KafzaTextField(
                      label: l10n.choiceName,
                      value: c.name,
                      maxLength: 30,
                      error: _showErrors && c.name.trim().isEmpty ? l10n.nameRequired : null,
                      onChanged: (v) => setState(() => c.name = v),
                    ),
                  ),
                  IconButton(
                    tooltip: l10n.removeChoice,
                    icon: const Icon(IconsaxPlusLinear.trash),
                    onPressed: _choices.length > 1 ? () => setState(() => _choices.remove(c)) : null,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(end: KafzaSpacing.md),
                child: NumberField(
                  label: l10n.extraPrice,
                  value: c.price,
                  suffix: l10n.currency,
                  maxLength: 6,
                  onChanged: (v) => setState(() => c.price = v),
                ),
              ),
              Wrap(
                spacing: KafzaSpacing.sm,
                children: [
                  for (final (perUnit, label) in [(false, l10n.perOrder), (true, l10n.perUnitLabel(l10n.unit(widget.unit)))])
                    ChoiceChip(
                      label: Text(label),
                      selected: c.perUnit == perUnit,
                      onSelected: (_) => setState(() => c.perUnit = perUnit),
                    ),
                ],
              ),
              if (_type == OptionType.colour)
                Wrap(
                  children: [
                    for (var i = 0; i < swatches.length; i++)
                      IconButton(
                        tooltip: l10n.swatchN(i + 1),
                        isSelected: c.swatch == i,
                        onPressed: () => setState(() => c.swatch = i),
                        icon: Container(
                          width: 28,
                          height: 28,
                          decoration: ShapeDecoration(
                            color: swatches[i],
                            shape: CircleBorder(
                              side: BorderSide(
                                color: c.swatch == i ? scheme.primary : scheme.outline,
                                width: c.swatch == i ? 3 : 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        );

    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.fromSTEB(KafzaSpacing.lg, 0, KafzaSpacing.lg, KafzaSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.group == null ? l10n.addOptionGroup : l10n.editOptionGroup, style: text.titleLarge),
            const SizedBox(height: KafzaSpacing.lg),
            KafzaTextField(
              label: l10n.optionGroupName,
              helper: l10n.optionGroupNameHelper,
              value: _name,
              maxLength: 30,
              error: _showErrors && _name.trim().isEmpty ? l10n.nameRequired : null,
              onChanged: (v) => setState(() => _name = v),
            ),
            const SizedBox(height: KafzaSpacing.md),
            Text(l10n.optionTypeLabel, style: text.titleMedium),
            const SizedBox(height: KafzaSpacing.sm),
            Wrap(
              spacing: KafzaSpacing.sm,
              runSpacing: KafzaSpacing.sm,
              children: [
                for (final t in OptionType.values)
                  ChoiceChip(
                    label: Text(l10n.optionType(t)),
                    selected: _type == t,
                    onSelected: (_) => setState(() => _type = t),
                  ),
              ],
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.optionRequired),
              subtitle: Text(l10n.optionRequiredHint),
              value: _required,
              onChanged: (v) => setState(() => _required = v),
            ),
            const SizedBox(height: KafzaSpacing.sm),
            if (_type == OptionType.text) ...[
              Text(l10n.textOptionHint, style: text.bodyMedium!.copyWith(color: scheme.onSurfaceVariant)),
              const SizedBox(height: KafzaSpacing.sm),
              Row(
                spacing: KafzaSpacing.sm,
                children: [
                  Expanded(child: Text(l10n.maxLengthLabel, style: text.bodyLarge)),
                  QuantityStepper(
                    value: _maxLength,
                    min: 5,
                    max: 100,
                    step: 5,
                    label: l10n.maxChars(_maxLength),
                    onChanged: (v) => setState(() => _maxLength = v.toInt()),
                  ),
                ],
              ),
            ] else ...[
              Text(l10n.choices, style: text.titleMedium),
              const SizedBox(height: KafzaSpacing.sm),
              for (final c in _choices) choice(c),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton.icon(
                  onPressed: () => setState(() => _choices.add(_newChoice())),
                  icon: const Icon(IconsaxPlusLinear.add),
                  label: Text(l10n.addChoice),
                ),
              ),
            ],
            const SizedBox(height: KafzaSpacing.lg),
            // Like the editor's Next: tapping with gaps shows what's missing instead of a dead button.
            FilledButton(
              onPressed: () => _valid ? Navigator.pop(context, _build()) : setState(() => _showErrors = true),
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }
}
