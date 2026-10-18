/// Why a free text was blocked. Screens map it to an ARB message.
enum ContactIssue { phone, email, link, handle, word }

// Digits glued across spaces, dots, dashes, slashes or brackets: "0555 12.34-56" → "0555123456".
final _separators = RegExp(r'(?<=\d)[\s.\-_/()]+(?=\d)');
// Algerian mobiles: 05/06/07 + 8 digits, or with 213 / +213 / 00213.
final _phone = RegExp(r'(?:(?:\+|00)?213|0)[567]\d{8}');
final _email = RegExp(r'[\w.+-]+@[\w-]+\.[a-z]{2,}', caseSensitive: false);
final _link = RegExp(
  r'https?://|www\.|\b[\w-]+\.(?:com|net|org|dz|fr|me|io|ly|gl|link|app|page)\b',
  caseSensitive: false,
);
final _handle = RegExp(r'(?:^|\s)@[\w.]{2,}');
final _latinWords = RegExp(
  r'\b(?:whats\s?app|whatsap|watsapp?|wtsp|wsp|insta|instagram|facebook|fb|messenger|snap|snapchat|'
  r'telegram|tiktok|viber|num[ée]ro|nmra|nemra|n[ée]mro)\b',
  caseSensitive: false,
);
const _arabicWords = [
  'واتساب', 'واتس', 'وتساب', 'انستغرام', 'انستا', 'إنستغرام', 'فيسبوك', 'فايسبوك', 'فيس بوك', //
  'تيليغرام', 'تلغرام', 'سناب', 'تيك توك', 'تيكتوك', 'رقمي', 'نمرتي',
];

/// Returns null when [text] is fine, or why it was blocked (CNT rules: no contact details).
ContactIssue? contactCheck(String text) {
  // Arabic-Indic digits (٠–٩) count as digits too.
  final ascii = text.replaceAllMapped(RegExp('[٠-٩]'), (m) => '${m[0]!.codeUnitAt(0) - 0x0660}');
  final glued = ascii.replaceAll(_separators, '');
  if (_phone.hasMatch(glued)) return ContactIssue.phone;
  if (_email.hasMatch(ascii)) return ContactIssue.email;
  if (_link.hasMatch(ascii)) return ContactIssue.link;
  if (_handle.hasMatch(ascii)) return ContactIssue.handle;
  if (_latinWords.hasMatch(ascii) || _arabicWords.any(ascii.contains)) return ContactIssue.word;
  return null;
}
