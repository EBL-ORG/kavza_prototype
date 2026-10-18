import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';

/// Left-to-right isolate (U+2066 … U+2069): keeps numbers LTR inside RTL text.
String ltr(String s) => '${String.fromCharCode(0x2066)}$s${String.fromCharCode(0x2069)}';

/// First-strong isolate (U+2068 … U+2069): user content (names, titles) keeps its own
/// direction inside a sentence of the other script ("Yacine B." stays intact in Arabic).
String isolate(String s) => '${String.fromCharCode(0x2068)}$s${String.fromCharCode(0x2069)}';

/// `2 400 DA` (fr), `2,400 د.ج` (ar), always LTR. A no-break space keeps the currency on
/// the amount's line.
String formatPrice(BuildContext context, num amount) {
  final l10n = AppLocalizations.of(context);
  final number = NumberFormat.decimalPattern(l10n.localeName).format(amount.round());
  return ltr('$number${String.fromCharCode(0xA0)}${l10n.currency}');
}

/// A plain number in the app locale (`1,5` fr, `1.5` ar), LTR.
String formatNumber(BuildContext context, num n, {int? decimals}) {
  final locale = AppLocalizations.of(context).localeName;
  final f = decimals == null
      ? NumberFormat.decimalPattern(locale)
      : NumberFormat.decimalPatternDigits(locale: locale, decimalDigits: decimals);
  return ltr(f.format(n));
}
