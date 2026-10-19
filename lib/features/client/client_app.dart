import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/seed.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/l10n/locale_provider.dart';
import '../../core/models/notification.dart';
import '../../core/models/order.dart';
import '../../core/theme/kafza_theme.dart';
import '../../core/widgets/kafza_logo.dart';
import '../../core/widgets/kafza_sheet.dart';
import '../../core/widgets/notice_banner.dart';
import 'favourites/favourites_screen.dart';
import 'help/help_screen.dart';
import 'home/home_screen.dart';
import 'client_providers.dart';
import 'ordering/placed_screen.dart';
import 'ordering/summary_screen.dart';
import 'orders/orders_screen.dart';
import 'orders/tracking_screen.dart';
import 'product/product_page.dart';
import 'search/search_screen.dart';
import 'store_page/store_page.dart';
import 'yassir_home/yassir_home_screen.dart';

/// The Kafza client mini-app inside a mock Yassir. Owns its router so it navigates on its own
/// in side-by-side.
class ClientApp extends ConsumerStatefulWidget {
  const ClientApp({super.key});

  @override
  ConsumerState<ClientApp> createState() => _ClientAppState();
}

class _ClientAppState extends ConsumerState<ClientApp> {
  final _rootKey = GlobalKey<NavigatorState>();

  // Store, product, summary and help pages sit beside the shell (not inside a tab), so they
  // cover the navigation bar and `push` keeps whichever tab opened them. Order tracking lives
  // under the Orders tab but on the root navigator: it covers the bar, and Back lands on Orders.
  late final _router = GoRouter(
    navigatorKey: _rootKey,
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => const YassirHomeScreen(),
        routes: [
          StatefulShellRoute.indexedStack(
            pageBuilder: (context, state, shell) => CustomTransitionPage(
              key: state.pageKey,
              child: _ClientShell(shell),
              transitionDuration: const Duration(milliseconds: 300),
              reverseTransitionDuration: const Duration(milliseconds: 250),
              transitionsBuilder: (context, animation, _, child) => MediaQuery.disableAnimationsOf(context)
                  ? child
                  : SlideTransition(
                      position: animation.drive(
                        Tween(begin: const Offset(0, 1), end: Offset.zero).chain(CurveTween(curve: Curves.easeOutCubic)),
                      ),
                      child: child,
                    ),
            ),
            branches: [
              StatefulShellBranch(routes: [GoRoute(path: 'kafza', builder: (_, _) => const HomeScreen())]),
              StatefulShellBranch(routes: [GoRoute(path: 'kafza/search', builder: (_, _) => const SearchScreen())]),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: 'kafza/orders',
                    builder: (_, _) => const OrdersScreen(),
                    routes: [
                      GoRoute(
                        path: ':id',
                        parentNavigatorKey: _rootKey,
                        builder: (_, state) => TrackingScreen(id: state.pathParameters['id']!),
                        routes: [
                          GoRoute(
                            path: 'placed',
                            parentNavigatorKey: _rootKey,
                            builder: (_, state) => PlacedScreen(id: state.pathParameters['id']!),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [GoRoute(path: 'kafza/favourites', builder: (_, _) => const FavouritesScreen())],
              ),
            ],
          ),
          GoRoute(path: 'store/:id', builder: (_, state) => StorePage(id: state.pathParameters['id']!)),
          GoRoute(
            path: 'product/:id',
            builder: (_, state) =>
                ProductPage(id: state.pathParameters['id']!, fromStore: state.uri.queryParameters['from'] == 'store'),
          ),
          // No extra: the store basket. Extra: a made-to-order draft, ordered on its own.
          GoRoute(path: 'order', builder: (_, state) => SummaryScreen(draft: state.extra as OrderDraft?)),
          GoRoute(path: 'recharge', builder: (_, state) => RechargeScreen(missing: state.extra as int? ?? 0)),
          GoRoute(path: 'help', builder: (_, _) => const HelpScreen()),
        ],
      ),
    ],
  );

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: buildKafzaTheme(locale),
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: _router,
      onNavigationNotification: keepBackInFlutter,
      builder: (_, child) => NoticeBanner(
        app: AppSide.client,
        to: demoClientId,
        onTap: (n) async {
          // Going to the order leaves the store, so a full basket asks first.
          if (ref.read(basketProvider) != null) {
            if (!await confirmLeaveStore(_rootKey.currentContext!)) return;
            ref.read(basketProvider.notifier).clear();
          }
          _router.go('/kafza/orders/${n.orderId}');
        },
        child: child!,
      ),
    );
  }
}

/// AppBar with the Kafza word logo (✕ back to Yassir, bell, ?) and the four tabs.
class _ClientShell extends StatelessWidget {
  const _ClientShell(this.shell);

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        // Yassir mini-app header: round close (the glyph is the circle), centred bold title.
        leadingWidth: 64,
        leading: Center(
          child: IconButton(
            icon: const Icon(IconsaxPlusLinear.close_circle),
            tooltip: l10n.backToYassir,
            onPressed: () => context.go('/'),
          ),
        ),
        title: const KafzaLogo(),
        actions: [
          // ponytail: the client has no notification list in the brief; the bell opens Orders,
          // where every update lands, and new ones also show as a banner (_NoticeBanner).
          IconButton(
            icon: const Icon(IconsaxPlusLinear.notification),
            tooltip: l10n.notifications,
            onPressed: () => shell.goBranch(2),
          ),
          IconButton(icon: const Icon(IconsaxPlusLinear.message_question), tooltip: l10n.help, onPressed: () => context.push('/help')),
        ],
      ),
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
        destinations: [
          NavigationDestination(icon: const Icon(IconsaxPlusLinear.home_2), selectedIcon: const Icon(IconsaxPlusBold.home_2), label: l10n.tabHome),
          NavigationDestination(icon: const Icon(IconsaxPlusLinear.search_normal_1), label: l10n.tabSearch),
          NavigationDestination(
            icon: const Icon(IconsaxPlusLinear.receipt_text),
            selectedIcon: const Icon(IconsaxPlusBold.receipt_text),
            label: l10n.tabOrders,
          ),
          NavigationDestination(
            icon: const Icon(IconsaxPlusLinear.heart),
            selectedIcon: const Icon(IconsaxPlusBold.heart),
            label: l10n.tabFavourites,
          ),
        ],
      ),
    );
  }
}
