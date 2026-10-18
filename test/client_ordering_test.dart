import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:prototype/core/contact_check.dart';
import 'package:prototype/core/data/seed.dart';
import 'package:prototype/core/l10n/app_localizations.dart';
import 'package:prototype/core/l10n/labels.dart';
import 'package:prototype/core/models/order.dart';
import 'package:prototype/core/order_engine/order_engine.dart';
import 'package:prototype/core/widgets/kafza_button.dart';
import 'package:prototype/features/client/client_app.dart';
import 'package:prototype/features/client/home/home_screen.dart';
import 'package:prototype/features/client/ordering/placed_screen.dart';

final l10n = lookupAppLocalizations(const Locale('ar'));

Future<ProviderContainer> _open(WidgetTester tester, String productId) async {
  tester.view.physicalSize = const Size(780, 1688);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(ProviderScope(
    overrides: [fakeDelayProvider.overrideWithValue(() async {})],
    child: const ClientApp(),
  ));
  await tester.pumpAndSettle();
  await tester.tap(find.image(const AssetImage('assets/logo/word logo white.png')));
  await tester.pumpAndSettle();
  GoRouter.of(tester.element(find.byType(HomeScreen))).push('/product/$productId');
  await tester.pumpAndSettle();
  return ProviderScope.containerOf(tester.element(find.byType(ClientApp)));
}

Future<void> _orderNowToSummary(WidgetTester tester) async {
  await tester.tap(find.text(l10n.orderNow));
  await tester.pumpAndSettle();
  await tester.tap(find.textContaining(l10n.continueTotal('').trim()));
  await tester.pumpAndSettle();
}

/// Disposes the app so the clock and banner timers stop.
Future<void> _close(WidgetTester tester) => tester.pumpWidget(const SizedBox());

void main() {
  testWidgets('order now → summary → placed: no debit; a second order offers to replace the first', (tester) async {
    final c = await _open(tester, 'p-baklawa');
    await _orderNowToSummary(tester);
    await tester.tap(find.text(l10n.placeOrder));
    await tester.pumpAndSettle();

    expect(find.byType(PlacedScreen), findsOneWidget);
    final first = c.read(orderEngineProvider).waitingOrder(demoClientId)!;
    expect(c.read(orderEngineProvider).client(demoClientId).balance, 6200);

    GoRouter.of(tester.element(find.byType(PlacedScreen))).push('/product/p-tcharek');
    await tester.pumpAndSettle();
    await _orderNowToSummary(tester);
    await tester.tap(find.text(l10n.placeOrder));
    // The button keeps its spinner behind the dialog, so pump instead of settling.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text(l10n.waitingTitle), findsOneWidget);
    await tester.tap(find.text(l10n.cancelAndPlace));
    await tester.pumpAndSettle();

    final s = c.read(orderEngineProvider);
    expect(s.order(first.id).status, OrderStatus.cancelledByClient);
    expect(s.waitingOrder(demoClientId)!.productId, 'p-tcharek');
    await _close(tester);
  });

  testWidgets('low balance: Place order disabled until a CCP recharge covers it', (tester) async {
    final c = await _open(tester, 'p-baklawa');
    c.read(orderEngineProvider.notifier).setBalance(demoClientId, 0);
    await _orderNowToSummary(tester);
    expect(tester.widget<FilledButton>(find.widgetWithText(FilledButton, l10n.placeOrder)).onPressed, isNull);

    await tester.tap(find.text(l10n.rechargeCcp));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(KafzaButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.backToOrder));
    await tester.pumpAndSettle();

    final balance = c.read(orderEngineProvider).client(demoClientId).balance;
    final s = c.read(orderEngineProvider);
    expect(balance, s.product('p-baklawa').readyMade!.price + deliveryFee(s.store('s-fatma').distanceKm)); // the exact total
    await tester.tap(find.text(l10n.placeOrder));
    await tester.pumpAndSettle();
    expect(find.byType(PlacedScreen), findsOneWidget);
    expect(c.read(orderEngineProvider).client(demoClientId).balance, balance); // still not debited
    await _close(tester);
  });

  testWidgets('made to order: contact details in the text option block Continue', (tester) async {
    await _open(tester, 'p-wedding');
    await tester.tap(find.text(l10n.orderMadeForMe));
    await tester.pumpAndSettle();
    final sheetList = find.byType(ListView).last;
    await tester.dragUntilVisible(find.byType(TextFormField), sheetList, const Offset(0, -200));
    await tester.enterText(find.byType(TextFormField), 'wtsp 0555123456');
    await tester.pumpAndSettle();

    expect(find.text(l10n.contactBlocked(ContactIssue.phone)), findsOneWidget);
    final cont = find.ancestor(of: find.textContaining(l10n.continueTotal('').trim()), matching: find.byType(FilledButton));
    expect(tester.widget<FilledButton>(cont).onPressed, isNull);
    await _close(tester);
  });
}
