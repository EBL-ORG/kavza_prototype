import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/l10n/app_localizations.dart';
import 'core/l10n/locale_provider.dart';
import 'core/theme/kafza_theme.dart';
import 'core/widgets/kafza_sheet.dart';
import 'features/client/client_app.dart';
import 'features/demo_panel/demo_panel.dart';
import 'features/launcher/launcher_screen.dart';
import 'features/store/store_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Full screen on the demo phone: system bars hidden, an edge swipe shows them briefly.
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }
  // Building both themes starts the font downloads. Waiting for them avoids a first layout
  // in fallback fonts that chips keep (clipped labels). Offline: start anyway after 3 s.
  buildKafzaTheme(const Locale('ar'));
  buildKafzaTheme(const Locale('fr'));
  try {
    await GoogleFonts.pendingFonts().timeout(const Duration(seconds: 3));
  } catch (_) {}
  runApp(const ProviderScope(child: KafzaPrototype()));
}

/// Launcher app. Both Kafza apps live under the same ProviderScope, so they share state.
class KafzaPrototype extends ConsumerWidget {
  const KafzaPrototype({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      theme: buildKafzaTheme(locale),
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onNavigationNotification: keepBackInFlutter,
      home: const LauncherScreen(
        clientApp: ClientApp(),
        storeApp: StoreApp(),
        openDemoPanel: showDemoPanel,
      ),
    );
  }
}
