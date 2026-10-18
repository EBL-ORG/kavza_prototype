import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';

/// "45 min", "1 h 12 min", "48 h", "5 days". Days only from 3 whole days up, as the brief
/// writes "Order 48 h ahead". Negative durations read as zero.
String formatDuration(AppLocalizations l10n, Duration d) {
  if (d.isNegative) d = Duration.zero;
  final h = d.inHours, m = d.inMinutes % 60;
  if (h > 48 && h % 24 == 0) return l10n.durationDays(h ~/ 24);
  if (h == 0) return l10n.durationMinutes(m);
  return m == 0 ? l10n.durationHours(h) : l10n.durationHoursMinutes(h, m);
}

/// Weekday names (`DateTime.monday` … `sunday`) in the app language, Monday first.
String formatWeekdays(AppLocalizations l10n, Set<int> days) {
  final names = DateFormat.EEEE(l10n.localeName);
  // 1 Jan 2024 is a Monday, so DateTime(2024, 1, d) falls on weekday d.
  return ([...days]..sort())
      .map((d) => names.format(DateTime(2024, 1, d)))
      .join(l10n.listSeparator);
}

/// "12 oct., 14:05".
String formatDateTime(AppLocalizations l10n, DateTime t) => DateFormat.MMMd(l10n.localeName).add_Hm().format(t);

/// "jeudi 15 octobre".
String formatDay(AppLocalizations l10n, DateTime t) => DateFormat.MMMMEEEEd(l10n.localeName).format(t);
