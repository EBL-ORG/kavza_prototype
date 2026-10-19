import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prototype/core/data/seed.dart';
import 'package:prototype/core/l10n/app_localizations.dart';
import 'package:prototype/core/models/order.dart';
import 'package:prototype/core/models/store.dart';
import 'package:prototype/core/order_engine/order_engine.dart';
import 'package:prototype/features/store/store_app.dart';
import 'package:prototype/features/store/store_widgets.dart';

void main() {
  late ProviderContainer c;
  OrderEngine engine() => c.read(orderEngineProvider.notifier);
  Matcher throwsOrderError(OrderError e) => throwsA(isA<OrderException>().having((x) => x.error, 'error', e));

  setUp(() => c = ProviderContainer.test(overrides: [fakeDelayProvider.overrideWithValue(() async {})]));

  test('withdraw: at least 2,000, at most the balance, recorded as requested', () async {
    // Seed: 2,160 + 3,780 + 2,700 delivered earnings − 4,000 already withdrawn.
    expect(c.read(orderEngineProvider).store(demoStoreId).balance, 4640);
    await expectLater(engine().withdraw(demoStoreId, 1999), throwsOrderError(OrderError.notAllowed));
    await expectLater(engine().withdraw(demoStoreId, 5000), throwsOrderError(OrderError.lowBalance));
    await engine().withdraw(demoStoreId, 2000);
    final s = c.read(orderEngineProvider);
    expect(s.store(demoStoreId).balance, 2640);
    expect((s.withdrawals.first.amount, s.withdrawals.first.status), (2000, WithdrawalStatus.requested));
  });

  test('appeal once per strike, no contact details; decline reasons are checked too', () {
    expect(() => engine().appealStrike('KF-0897', 'appelez-moi au 0661 42 18 75'), throwsOrderError(OrderError.contactDetails));
    engine().appealStrike('KF-0897', 'Le fournisseur a livré en retard.');
    expect(c.read(orderEngineProvider).strikes.first.appeal, 'Le fournisseur a livré en retard.');
    expect(() => engine().appealStrike('KF-0897', 'Encore'), throwsOrderError(OrderError.notAllowed));
    expect(() => engine().decline('KF-1008', 'insta @fatma'), throwsOrderError(OrderError.contactDetails));
  });

  testWidgets('store side: new-order banner, accept secures payment, low client balance fails, client stays a commune',
      (tester) async {
    final l10n = lookupAppLocalizations(const Locale('ar'));
    tester.view.physicalSize = const Size(780, 1688);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(ProviderScope(
      overrides: [fakeDelayProvider.overrideWithValue(() async {})],
      child: const StoreApp(),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.haveStore));
    await tester.pumpAndSettle();
    expect(find.text(l10n.needsAnswer(2)), findsOneWidget);

    // The client places an order in the other app.
    final c = ProviderScope.containerOf(tester.element(find.byType(StoreApp)));
    final o = await c.read(orderEngineProvider.notifier).placeOrder(
        clientId: demoClientId,
        addressId: 'a-home',
        items: [const OrderDraft(productId: 'p-baklawa', type: OrderType.readyMade, qty: 1)]);
    await tester.pump();
    expect(find.text(l10n.noticeNewOrder), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));

    await tester.tap(find.text(l10n.tabOrders));
    await tester.pumpAndSettle();
    expect(find.text(l10n.ordersNew(3)), findsOneWidget);

    void expectPrivate() {
      for (final hidden in ['Yacine', 'Karim', 'Cité 1200', 'Chemin Poirson', '0555', '0770']) {
        expect(find.textContaining(hidden), findsNothing, reason: hidden);
      }
    }

    Finder card(String id) => find.descendant(of: find.byType(StoreOrderCard), matching: find.textContaining(id));
    expectPrivate();
    await tester.tap(card(o.id));
    await tester.pumpAndSettle();
    expectPrivate();
    await tester.tap(find.text(l10n.accept));
    await tester.pumpAndSettle();
    expect(c.read(orderEngineProvider).order(o.id).status, OrderStatus.accepted);
    expect(c.read(orderEngineProvider).client(demoClientId).balance, 6200 - o.total);
    expect(find.text(l10n.startPreparation), findsOneWidget);

    // Karim (KF-1008) has 1,000 DZD for a 2,400 DZD order.
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await tester.tap(card('KF-1008'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.accept));
    await tester.pumpAndSettle();
    expect(find.text(l10n.storePaymentFailed), findsOneWidget);
    expect(c.read(orderEngineProvider).order('KF-1008').status, OrderStatus.paymentFailed);

    await tester.pumpWidget(const SizedBox());
  });
}
