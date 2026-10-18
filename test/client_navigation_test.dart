import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:prototype/core/order_engine/order_engine.dart';
import 'package:prototype/features/client/client_app.dart';
import 'package:prototype/features/client/home/home_screen.dart';
import 'package:prototype/features/client/product/product_page.dart';
import 'package:prototype/features/client/search/search_screen.dart';
import 'package:prototype/features/client/yassir_home/yassir_home_screen.dart';
import 'package:prototype/main.dart';

void main() {
  testWidgets('system Back: product → search tab → Yassir; ✕ → Yassir', (tester) async {
    tester.view.physicalSize = const Size(780, 1688);
    tester.view.devicePixelRatio = 2;
    await tester.pumpWidget(ProviderScope(
      overrides: [fakeDelayProvider.overrideWithValue(() async {})],
      child: const ClientApp(),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.image(const AssetImage('assets/logo/word logo white.png')));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);

    await tester.tap(find.byIcon(IconsaxPlusLinear.search_normal_1).last);
    await tester.pumpAndSettle();
    GoRouter.of(tester.element(find.byType(SearchScreen))).push('/product/p-baklawa');
    await tester.pumpAndSettle();
    expect(find.byType(ProductPage), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(SearchScreen), findsOneWidget); // back to the tab that opened it

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(YassirHomeScreen), findsOneWidget);

    await tester.tap(find.image(const AssetImage('assets/logo/word logo white.png')));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(IconsaxPlusLinear.close_circle));
    await tester.pumpAndSettle();
    expect(find.byType(YassirHomeScreen), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('phone: system Back at the app root returns to the launcher, never quits', (tester) async {
    tester.view.physicalSize = const Size(780, 1688);
    tester.view.devicePixelRatio = 2;
    await tester.pumpWidget(ProviderScope(
      overrides: [fakeDelayProvider.overrideWithValue(() async {})],
      child: const KafzaPrototype(),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(IconsaxPlusLinear.bag_2));
    await tester.pumpAndSettle();
    await tester.tap(find.image(const AssetImage('assets/logo/word logo white.png')));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(YassirHomeScreen), findsOneWidget); // the app still gets Back first

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(YassirHomeScreen), findsNothing);
    expect(find.byIcon(IconsaxPlusLinear.bag_2), findsOneWidget); // launcher menu
    await tester.pumpWidget(const SizedBox());
  });
}
