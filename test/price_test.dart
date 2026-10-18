import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prototype/core/format/price.dart';
import 'package:prototype/core/l10n/app_localizations.dart';

void main() {
  final nnbsp = String.fromCharCode(0x202F); // intl's French group separator
  final nbsp = String.fromCharCode(0xA0); // the amount never wraps away from its currency
  for (final (locale, expected) in [('fr', '2${nnbsp}400${nbsp}DA'), ('ar', '2,400$nbspد.ج')]) {
    testWidgets('formatPrice $locale', (tester) async {
      late String out;
      await tester.pumpWidget(Localizations(
        locale: Locale(locale),
        delegates: AppLocalizations.localizationsDelegates,
        child: Builder(builder: (context) {
          out = formatPrice(context, 2400.4);
          return const SizedBox();
        }),
      ));
      expect(out, ltr(expected));
    });
  }
}
