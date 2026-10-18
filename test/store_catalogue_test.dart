import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:prototype/core/data/clock.dart';
import 'package:prototype/core/data/seed.dart';
import 'package:prototype/core/l10n/app_localizations.dart';
import 'package:prototype/core/models/catalog.dart';
import 'package:prototype/core/models/order.dart';
import 'package:prototype/core/models/product.dart';
import 'package:prototype/core/models/store.dart';
import 'package:prototype/core/order_engine/order_engine.dart';
import 'package:prototype/features/store/onboarding/pending_screen.dart';
import 'package:prototype/features/store/store_app.dart';

/// A made-to-order product as the S9 editor builds it (empty id = new).
Product _makrout({required String storeId, ProductStatus status = ProductStatus.live, Category? category, String? title}) =>
    Product(
      id: '',
      storeId: storeId,
      category: category ?? Category.traditionalSweets,
      title: title ?? 'Makrout au miel',
      unit: Unit.kg,
      status: status,
      madeToOrder: const MadeToOrder(
        price: 3000,
        minQty: 1,
        step: 0.5,
        maxQty: 4,
        leadTime: Duration(hours: 48),
        prepTime: Duration(hours: 24),
        optionGroups: [
          OptionGroup('g-box', 'Boîte', OptionType.single, required: true, choices: [
            OptionChoice('c-plain', 'Simple'),
            OptionChoice('c-gift', 'Cadeau', price: 300),
          ]),
          OptionGroup('g-name', 'Prénom', OptionType.text, maxLength: 20),
        ],
      ),
      createdAt: DateTime(2026),
    );

void main() {
  late ProviderContainer c;
  OrderEngine engine() => c.read(orderEngineProvider.notifier);
  Matcher throwsOrderError(OrderError e) => throwsA(isA<OrderException>().having((x) => x.error, 'error', e));

  setUp(() => c = ProviderContainer.test(overrides: [fakeDelayProvider.overrideWithValue(() async {})]));

  test('a pending store saves drafts but cannot publish until approved', () {
    final id = engine().registerStore(name: 'Chez Lina', phone: '555123456', cardNumber: '12345678', activity: Service.cooking);
    expect(c.read(orderEngineProvider).store(id).status, StoreStatus.pending);
    final draft = engine().saveProduct(_makrout(storeId: id, status: ProductStatus.draft));
    expect(() => engine().saveProduct(c.read(orderEngineProvider).product(draft).copyWith(status: ProductStatus.live)),
        throwsOrderError(OrderError.notAllowed));

    engine().reviewStore(id, approve: true);
    engine().saveProduct(c.read(orderEngineProvider).product(draft).copyWith(status: ProductStatus.live));
    expect(c.read(orderEngineProvider).listedProducts(c.read(clockProvider)).map((p) => p.id), contains(draft));
  });

  test('a product published by the store is listed and its rules and options hold in a client order', () async {
    final id = engine().saveProduct(_makrout(storeId: demoStoreId));
    final now = c.read(clockProvider);
    expect(c.read(orderEngineProvider).listedProducts(now).map((p) => p.id), contains(id));

    Future<Order> order(num qty, Map<String, List<String>> picks) => engine().placeOrder(
          clientId: demoClientId,
          productId: id,
          type: OrderType.madeToOrder,
          qty: qty,
          addressId: 'a-home',
          picks: picks,
          deliveryDate: now.add(const Duration(days: 3)),
        );
    await expectLater(order(1.25, {'g-box': ['c-plain']}), throwsOrderError(OrderError.invalidQty));
    await expectLater(order(1.5, {}), throwsOrderError(OrderError.missingOption));
    await expectLater(order(1.5, {'g-box': ['c-gift'], 'g-name': ['wtsp 0555123456']}), throwsOrderError(OrderError.contactDetails));
    final o = await order(1.5, {'g-box': ['c-gift'], 'g-name': ['Lina']});
    expect(o.itemTotal, 3000 * 1.5 + 300);
  });

  test('free plan: one category; contact details refused; delete and stock guarded', () {
    expect(() => engine().saveProduct(_makrout(storeId: demoStoreId, category: Category.cakes)),
        throwsOrderError(OrderError.notAllowed));
    expect(() => engine().saveProduct(_makrout(storeId: demoStoreId, title: 'Makrout, wtsp 0555 12 34 56')),
        throwsOrderError(OrderError.contactDetails));
    expect(
      () => engine().updateProfile(demoStoreId,
          name: 'Dar Lalla Fatma', description: 'insta @lallafatma', commune: 'Kouba', wilaya: 'Alger', ccp: '', pickup: (0.5, 0.5), picture: StorePicture.none),
      throwsOrderError(OrderError.contactDetails),
    );
    // p-griwech has a waiting order holding 2 units.
    expect(() => engine().deleteProduct('p-griwech'), throwsOrderError(OrderError.notAllowed));
    expect(() => engine().setStock('p-griwech', 1), throwsOrderError(OrderError.outOfStock));
    engine().deleteProduct('p-tcharek'.replaceAll('tcharek', 'mkhabez'));
    expect(c.read(orderEngineProvider).products.any((p) => p.id == 'p-mkhabez'), isFalse);
  });

  testWidgets('onboarding: phone → code → card → live selfie (no gallery) → pending, then approval', (tester) async {
    final l10n = lookupAppLocalizations(const Locale('ar'));
    tester.view.physicalSize = const Size(780, 1688);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(ProviderScope(
      overrides: [fakeDelayProvider.overrideWithValue(() async {})],
      child: const StoreApp(),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text(l10n.getStarted));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '0555123456');
    await tester.pump();
    await tester.tap(find.text(l10n.sendCode));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '111111');
    await tester.pumpAndSettle();
    expect(find.text(l10n.otpWrong), findsOneWidget);
    await tester.enterText(find.byType(TextField), '123456');
    await tester.pumpAndSettle();

    for (var side = 0; side < 2; side++) {
      await tester.tap(find.byTooltip(l10n.takePhoto));
      await tester.pump();
      await tester.tap(find.text(l10n.continueLabel));
      await tester.pumpAndSettle();
    }
    await tester.enterText(find.byType(TextFormField), '16021987450');
    await tester.tap(find.text(l10n.serviceCooking));
    await tester.pump();
    await tester.tap(find.text(l10n.continueLabel));
    await tester.pumpAndSettle();

    expect(find.text(l10n.selfieTitle), findsOneWidget);
    expect(find.byIcon(Icons.photo_library_outlined), findsNothing);
    expect(find.byIcon(Icons.photo_library), findsNothing);
    await tester.tap(find.byTooltip(l10n.takePhoto));
    await tester.pump();
    await tester.tap(find.text(l10n.sendForReview));
    await tester.pumpAndSettle();

    expect(find.byType(PendingScreen), findsOneWidget);
    final c = ProviderScope.containerOf(tester.element(find.byType(StoreApp)));
    final store = c.read(orderEngineProvider).stores.last;
    expect((store.status, store.phone, store.activity), (StoreStatus.pending, '555123456', Service.cooking));

    c.read(orderEngineProvider.notifier).reviewStore(store.id, approve: true);
    await tester.pump();
    expect(find.text(l10n.storeApproved), findsOneWidget);
    expect(find.byType(PendingScreen), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets("dialogs open on the app's own navigator, not the launcher's around it", (tester) async {
    final l10n = lookupAppLocalizations(const Locale('ar'));
    // Tall enough for the whole profile: a drag over its pickup map would move the pin.
    tester.view.physicalSize = const Size(780, 4000);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    // Nested like main.dart: the launcher's MaterialApp around the store app's router.
    await tester.pumpWidget(ProviderScope(
      overrides: [fakeDelayProvider.overrideWithValue(() async {})],
      child: const MaterialApp(home: StoreApp()),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.haveStore));
    await tester.pumpAndSettle();
    GoRouter.of(tester.element(find.byType(NavigationBar))).push('/profile');
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.pauseStore));
    await tester.pumpAndSettle();
    expect(find.descendant(of: find.byType(StoreApp), matching: find.byType(AlertDialog)), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
