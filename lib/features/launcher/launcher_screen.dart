import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/l10n/locale_provider.dart';
import '../../core/theme/kafza_theme.dart';
import '../../core/widgets/phone_frame.dart';

enum _Mode { menu, client, store, sideBySide }

/// Launcher + framed views. Modes switch by state, not by pushing routes: Flutter sends
/// system Back to the outermost Navigator first, so a pushed route would swallow the
/// apps' own Back. The apps and the demo panel come in from main.dart (features never
/// import each other).
class LauncherScreen extends ConsumerStatefulWidget {
  const LauncherScreen({super.key, required this.clientApp, required this.storeApp, required this.openDemoPanel});

  final Widget clientApp, storeApp;
  final void Function(BuildContext) openDemoPanel;

  @override
  ConsumerState<LauncherScreen> createState() => _LauncherScreenState();
}

class _LauncherScreenState extends ConsumerState<LauncherScreen> {
  _Mode _mode = _Mode.menu;

  /// Two 420-wide frames plus gaps.
  static const _sideBySideMinWidth = 900.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final wide = MediaQuery.sizeOf(context).width >= _sideBySideMinWidth;

    if (_mode == _Mode.menu) return _menu(context, l10n, wide);

    return Stack(children: [_apps(context, l10n, wide), _BackToMenu(() => setState(() => _mode = _Mode.menu))]);
  }

  Widget _apps(BuildContext context, AppLocalizations l10n, bool wide) {
    final apps = switch (_mode) {
      _Mode.client => [widget.clientApp],
      _Mode.store => [widget.storeApp],
      _ => [widget.clientApp, widget.storeApp],
    };
    // On a real phone, a single app runs full screen; no frame. Long-press on the top strip
    // (status area + app-bar row) opens the demo panel; taps fall through to the app. The
    // app-bar row is needed on Android: SystemUI keeps every touch on the status bar itself.
    // A tab on the start edge, mid-height (clear of app bars, nav bars and sticky buttons),
    // goes back to the menu.
    if (!wide && apps.length == 1) {
      final scheme = Theme.of(context).colorScheme;
      return Stack(
        children: [
          apps.single,
          PositionedDirectional(
            top: 0,
            start: 0,
            end: 0,
            height: MediaQuery.viewPaddingOf(context).top + kToolbarHeight,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onLongPress: () => widget.openDemoPanel(context),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Material(
              color: scheme.inverseSurface.withValues(alpha: 0.72),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.horizontal(end: Radius.circular(28)),
              ),
              child: SizedBox(
                width: 48,
                height: 56,
                child: IconButton(
                  tooltip: l10n.backToLauncher,
                  color: scheme.onInverseSurface,
                  icon: const Icon(KafzaIcons.chevronStart),
                  onPressed: () => setState(() => _mode = _Mode.menu),
                ),
              ),
            ),
          ),
        ],
      );
    }

    // The phones sit on Yassir purple, like Yassir's store listing.
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.primary,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => widget.openDemoPanel(context),
        backgroundColor: scheme.surface,
        foregroundColor: scheme.primary,
        icon: const Icon(IconsaxPlusLinear.setting_4),
        label: Text(l10n.demoPanel),
      ),
      appBar: AppBar(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        titleTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: scheme.onPrimary),
        leading: BackButton(onPressed: () => setState(() => _mode = _Mode.menu)),
        title: Text(switch (_mode) {
          _Mode.client => l10n.clientApp,
          _Mode.store => l10n.storeApp,
          _ => l10n.sideBySide,
        }),
      ),
      body: Center(
        // Scales the phones down on short windows instead of overflowing.
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: const EdgeInsets.all(KafzaSpacing.xl),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: KafzaSpacing.xxl,
              children: [for (final app in apps) PhoneFrame(child: app)],
            ),
          ),
        ),
      ),
    );
  }

  Widget _menu(BuildContext context, AppLocalizations l10n, bool wide) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final locale = ref.watch(localeProvider);

    Widget option(IconData icon, String title, String hint, _Mode mode) => ListTile(
          contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: KafzaSpacing.lg),
          minVerticalPadding: KafzaSpacing.md,
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: scheme.primaryContainer, shape: BoxShape.circle),
            child: Icon(icon, color: scheme.primary),
          ),
          title: Text(title, style: text.titleMedium),
          subtitle: Text(hint),
          trailing: const Icon(KafzaIcons.chevronEnd),
          onTap: () => setState(() => _mode = mode),
        );

    return Scaffold(
      backgroundColor: scheme.primary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(KafzaSpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l10n.appName, style: text.headlineMedium!.copyWith(color: scheme.onPrimary)),
                  Text(l10n.launcherTitle, style: text.titleMedium!.copyWith(color: context.kafza.primaryTint)),
                  const SizedBox(height: KafzaSpacing.sm),
                  Text(l10n.launcherSubtitle, style: text.bodyMedium!.copyWith(color: context.kafza.primaryTint)),
                  const SizedBox(height: KafzaSpacing.xl),
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        option(IconsaxPlusLinear.bag_2, l10n.clientApp, l10n.clientAppHint, _Mode.client),
                        const Divider(),
                        option(IconsaxPlusLinear.shop, l10n.storeApp, l10n.storeAppHint, _Mode.store),
                        if (wide) ...[
                          const Divider(),
                          option(IconsaxPlusLinear.kanban, l10n.sideBySide, l10n.sideBySideHint,
                              _Mode.sideBySide),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: KafzaSpacing.xl),
                  Row(
                    children: [
                      Expanded(child: Text(l10n.language, style: text.titleMedium!.copyWith(color: scheme.onPrimary))),
                      for (final (code, label) in [('ar', l10n.langAr), ('fr', l10n.langFr)])
                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: KafzaSpacing.sm),
                          child: ChoiceChip(
                            showCheckmark: false,
                            label: Text(label),
                            selected: locale.languageCode == code,
                            onSelected: (_) => ref.read(localeProvider.notifier).set(Locale(code)),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// System Back with nothing left to pop in the app on screen: back to the menu, instead of
/// quitting Android (which would also wipe the demo state). The binding asks observers in
/// the order they registered; this one mounts after the apps, so their routers go first.
class _BackToMenu extends StatefulWidget {
  const _BackToMenu(this.onBack);

  final VoidCallback onBack;

  @override
  State<_BackToMenu> createState() => _BackToMenuState();
}

class _BackToMenuState extends State<_BackToMenu> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<bool> didPopRoute() async {
    widget.onBack();
    return true;
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
