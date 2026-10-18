import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/l10n/locale_provider.dart';
import '../../core/models/notification.dart';
import '../../core/models/order.dart';
import '../../core/models/store.dart';
import '../../core/order_engine/order_engine.dart';
import '../../core/theme/kafza_theme.dart';
import '../../core/widgets/kafza_sheet.dart';
import '../../core/widgets/notice_banner.dart';
import 'earnings/earnings_screen.dart';
import 'home/home_screen.dart';
import 'more/more_screen.dart';
import 'onboarding/pending_screen.dart';
import 'onboarding/phone_screens.dart';
import 'onboarding/verify_screen.dart';
import 'onboarding/welcome_screen.dart';
import 'orders/order_detail_screen.dart';
import 'orders/orders_screen.dart';
import 'product_editor/product_editor_screen.dart';
import 'products/products_screen.dart';
import 'profile/profile_screen.dart';
import 'reviews/reviews_screen.dart';
import 'store_providers.dart';
import 'store_widgets.dart';
import 'strikes/strikes_screen.dart';

/// Reachable only while logged out. `/verify` is reachable both ways: a new store, or a
/// rejected one resubmitting.
const _onboarding = {'/welcome', '/phone', '/otp'};

/// The Kafza Store app. Owns its router so it navigates on its own in side-by-side.
class StoreApp extends ConsumerStatefulWidget {
  const StoreApp({super.key});

  @override
  ConsumerState<StoreApp> createState() => _StoreAppState();
}

class _StoreAppState extends ConsumerState<StoreApp> {
  final _rootKey = GlobalKey<NavigatorState>();

  // Editor, profile, order detail and the More sub-pages sit on the root navigator, so they
  // cover the navigation bar; the last two keep their tab underneath, so Back lands there.
  late final _router = GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/welcome',
    redirect: (_, state) {
      final loggedIn = ref.read(currentStoreProvider) != null;
      final path = state.matchedLocation;
      if (!loggedIn && !_onboarding.contains(path) && path != '/verify') return '/welcome';
      if (loggedIn && _onboarding.contains(path)) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/welcome', builder: (_, _) => const WelcomeScreen()),
      GoRoute(path: '/phone', builder: (_, _) => const PhoneScreen()),
      GoRoute(
        path: '/otp',
        builder: (_, state) => OtpScreen(phone: state.extra! as String),
      ),
      GoRoute(
        path: '/verify',
        builder: (_, state) => VerifyScreen(phone: state.extra as String?),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => _Gate(_StoreShell(shell)),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: '/home', builder: (_, _) => const _HomeTab())],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/orders',
                builder: (_, _) => const OrdersScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    parentNavigatorKey: _rootKey,
                    builder: (_, state) => _Gate(StoreOrderScreen(id: state.pathParameters['id']!)),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/products', builder: (_, _) => const ProductsScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/earnings', builder: (_, _) => const EarningsScreen())],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/more',
                builder: (_, _) => const MoreScreen(),
                routes: [
                  for (final (path, page) in [
                    ('notifications', const StoreNotificationsScreen()),
                    ('reviews', const ReviewsScreen()),
                    ('strikes', const StrikesScreen()),
                    ('help', const StoreHelpScreen()),
                  ])
                    GoRoute(path: path, parentNavigatorKey: _rootKey, builder: (_, _) => _Gate(page)),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/editor',
        builder: (_, state) => _Gate(ProductEditorScreen(id: state.uri.queryParameters['id'])),
      ),
      GoRoute(path: '/profile', builder: (_, _) => const _Gate(ProfileScreen())),
    ],
  );

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Log in, log out, or a demo reset removing the store: re-run the redirect.
    ref.listen(currentStoreProvider.select((s) => s == null), (_, _) => _router.refresh());
    final locale = ref.watch(localeProvider);
    final storeId = ref.watch(currentStoreProvider.select((s) => s?.id));
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: buildKafzaTheme(locale),
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: _router,
      onNavigationNotification: keepBackInFlutter,
      builder: (_, child) =>
          NoticeBanner(app: AppSide.store, to: storeId, onTap: (n) => _router.go(noticeRoute(n)), child: child!),
    );
  }
}

/// Logged-in pages read `currentStoreProvider!`. Between a demo reset (or log out) and the
/// redirect that follows, this shows nothing instead.
class _Gate extends ConsumerWidget {
  const _Gate(this.child);

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(currentStoreProvider) == null ? const Scaffold() : child;
}

/// Home · Orders (badge: new orders) · Products · Earnings · More.
class _StoreShell extends ConsumerWidget {
  const _StoreShell(this.shell);

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final id = ref.watch(currentStoreProvider.select((s) => s?.id));
    final fresh = ref.watch(
      orderEngineProvider.select(
        (s) => s.orders.where((o) => o.storeId == id && o.status == OrderStatus.placed).length,
      ),
    );
    Widget badged(IconData icon) => Badge(label: Text('$fresh'), isLabelVisible: fresh > 0, child: Icon(icon));
    return Scaffold(
      body: shell,
      // Five tabs are 78 px each: past 1.15× text, "Commandes" breaks mid-word. The labels
      // stop growing there; everything else still scales.
      bottomNavigationBar: MediaQuery.withClampedTextScaling(
        maxScaleFactor: 1.15,
        child: NavigationBar(
          selectedIndex: shell.currentIndex,
          onDestinationSelected: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
          destinations: [
            NavigationDestination(
              icon: const Icon(IconsaxPlusLinear.home_2),
              selectedIcon: const Icon(IconsaxPlusBold.home_2),
              label: l10n.tabHome,
            ),
            NavigationDestination(
              icon: badged(IconsaxPlusLinear.receipt_text),
              selectedIcon: badged(IconsaxPlusBold.receipt_text),
              label: l10n.tabOrders,
              tooltip: fresh > 0 ? l10n.ordersNew(fresh) : null,
            ),
            NavigationDestination(
              icon: const Icon(IconsaxPlusLinear.box),
              selectedIcon: const Icon(IconsaxPlusBold.box),
              label: l10n.tabProducts,
            ),
            NavigationDestination(
              icon: const Icon(IconsaxPlusLinear.wallet),
              selectedIcon: const Icon(IconsaxPlusBold.wallet),
              label: l10n.tabEarnings,
            ),
            NavigationDestination(icon: const Icon(IconsaxPlusLinear.menu_1), label: l10n.tabMore),
          ],
        ),
      ),
    );
  }
}

/// S4 until approval, then S5.
class _HomeTab extends ConsumerWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(currentStoreProvider.select((s) => s?.status)) == StoreStatus.approved
      ? const StoreHomeScreen()
      : const PendingScreen();
}
