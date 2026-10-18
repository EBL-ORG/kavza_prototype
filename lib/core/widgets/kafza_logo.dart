import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// Kafza word logo (mascot + purple "KAFZA"). White surfaces only: it vanishes on purple.
class KafzaLogo extends StatelessWidget {
  const KafzaLogo({super.key, this.height = 32});

  final double height;

  @override
  Widget build(BuildContext context) =>
      Image.asset('assets/logo/word logo.png', height: height, semanticLabel: AppLocalizations.of(context).kafza);
}
