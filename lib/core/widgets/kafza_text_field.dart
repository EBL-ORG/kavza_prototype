import 'package:flutter/material.dart';

import '../contact_check.dart';
import '../l10n/app_localizations.dart';
import '../l10n/labels.dart';

/// Free-text field. Blocks contact details (contactCheck) and says why under the field.
/// The parent owns [value]; run `contactCheck(value)` there too before enabling submit.
class KafzaTextField extends StatelessWidget {
  const KafzaTextField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.helper,
    this.maxLength,
    this.maxLines = 1,
    this.error,
  });

  final String label, value;
  final ValueChanged<String> onChanged;
  final String? helper;
  final int? maxLength;
  final int maxLines;

  /// Shown when the text has no contact details (those always win).
  final String? error;

  @override
  Widget build(BuildContext context) {
    final issue = contactCheck(value);
    return TextFormField(
      initialValue: value,
      onChanged: onChanged,
      maxLength: maxLength,
      maxLines: maxLines,
      minLines: 1,
      decoration: InputDecoration(
        labelText: label,
        helperText: helper,
        helperMaxLines: 3,
        errorText: issue == null ? error : AppLocalizations.of(context).contactBlocked(issue),
        errorMaxLines: 3,
        alignLabelWithHint: maxLines > 1,
      ),
    );
  }
}
