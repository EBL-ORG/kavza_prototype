import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prototype/core/contact_check.dart';
import 'package:prototype/core/data/clock.dart';
import 'package:prototype/core/data/seed.dart';
import 'package:prototype/core/models/order.dart';
import 'package:prototype/core/order_engine/order_engine.dart';

void main() {
  late ProviderContainer c;
  OrderEngine engine() => c.read(orderEngineProvider.notifier);
  int balance() => c.read(orderEngineProvider).client(demoClientId).balance;
  int storeBalance(String id) => c.read(orderEngineProvider).store(id).balance;
  Order order(String id) => c.read(orderEngineProvider).order(id);
  int reserved(String productId) => c.read(orderEngineProvider).product(productId).readyMade!.reserved;

  OrderDraft now(String productId, [num qty = 1]) => OrderDraft(productId: productId, type: OrderType.readyMade, qty: qty);
  Future<Order> placeAll(List<OrderDraft> items) =>
      engine().placeOrder(clientId: demoClientId, addressId: 'a-home', items: items);
  Future<Order> place(String productId, {num qty = 1}) => placeAll([now(productId, qty)]);

  Matcher throwsOrderError(OrderError e) =>
      throwsA(isA<OrderException>().having((x) => x.error, 'error', e));

  setUp(() {
    c = ProviderContainer.test(overrides: [fakeDelayProvider.overrideWithValue(() async {})]);
  });

  test('placing an order checks the balance but debits nothing, and reserves stock', () async {
    final o = await place('p-baklawa', qty: 2);
    expect(o.status, OrderStatus.placed);
    expect(o.money, Money.inWallet);
    expect(o.total, 2 * 2400 + 325);
    expect(balance(), 6200);
    expect(reserved('p-baklawa'), 2);
  });

  test('a double accept debits once', () async {
    final o = await place('p-baklawa');
    await Future.wait([engine().accept(o.id), engine().accept(o.id)]);
    expect(balance(), 6200 - o.total);
    expect(order(o.id).status, OrderStatus.accepted);
    expect(order(o.id).money, Money.held);
    expect(order(o.id).history.where((e) => e.status == OrderStatus.accepted), hasLength(1));
    final p = c.read(orderEngineProvider).product('p-baklawa').readyMade!;
    expect((p.stock, p.reserved), (4, 0));
  });

  test('low balance at accept → Payment failed, stock back, nothing debited, no strike', () async {
    final o = await place('p-baklawa');
    final strikes = c.read(orderEngineProvider).strikes.length;
    engine().setBalance(demoClientId, 100);
    final result = await engine().accept(o.id);
    expect(result.status, OrderStatus.paymentFailed);
    expect(balance(), 100);
    expect(reserved('p-baklawa'), 0);
    expect(c.read(orderEngineProvider).strikes, hasLength(strikes));
  });

  test('a basket is one order: one fee, stock reserved, consumed and returned per line', () async {
    engine().setBalance(demoClientId, 20000);
    final o = await placeAll([now('p-baklawa', 2), now('p-tcharek')]);
    expect(o.lines.map((l) => (l.productId, l.qty, l.total)), [('p-baklawa', 2, 4800), ('p-tcharek', 1, 1500)]);
    expect(o.total, 4800 + 1500 + 325);
    expect((reserved('p-baklawa'), reserved('p-tcharek')), (2, 1));
    expect(c.read(orderEngineProvider).waitingOrder(demoClientId)!.id, o.id);

    await engine().accept(o.id);
    expect(balance(), 20000 - o.total);
    final s = c.read(orderEngineProvider);
    expect((s.product('p-baklawa').readyMade!.stock, s.product('p-tcharek').readyMade!.stock), (3, 9));
    expect((reserved('p-baklawa'), reserved('p-tcharek')), (0, 0));
  });

  test('declining a basket returns every line', () async {
    engine().setBalance(demoClientId, 20000);
    final o = await placeAll([now('p-baklawa', 2), now('p-tcharek', 3)]);
    engine().decline(o.id, 'Rupture');
    expect((reserved('p-baklawa'), reserved('p-tcharek')), (0, 0));
  });

  test('one store per order: mixed stores, duplicates and made to order + more are refused', () async {
    expect(placeAll([now('p-baklawa'), now('p-fraisier')]), throwsOrderError(OrderError.notAllowed));
    expect(placeAll([now('p-baklawa'), now('p-baklawa')]), throwsOrderError(OrderError.notAllowed));
    expect(
      placeAll([now('p-baklawa'), const OrderDraft(productId: 'p-makrout', type: OrderType.madeToOrder, qty: 1)]),
      throwsOrderError(OrderError.notAllowed),
    );
    expect(placeAll([]), throwsOrderError(OrderError.notAllowed));
    await pumpEventQueue();
    expect(reserved('p-baklawa'), 0);
    expect(c.read(orderEngineProvider).waitingOrder(demoClientId), isNull);
  });

  test('one line short of stock refuses the whole basket', () async {
    expect(placeAll([now('p-baklawa'), now('p-tcharek', 11)]), throwsOrderError(OrderError.outOfStock));
    await pumpEventQueue();
    expect(reserved('p-baklawa'), 0);
  });

  test('free delivery only when every line has it', () async {
    final mixed = await placeAll([now('p-cupcakes'), now('p-fraisier')]); // cupcakes free, fraisier not; fee 520
    expect((mixed.freeDelivery, mixed.total), (false, 1300 + 3200 + 520));
    engine().cancelByClient(mixed.id);
    final free = await placeAll([now('p-cupcakes', 2)]);
    expect((free.freeDelivery, free.total), (true, 2600));
  });

  test('a second waiting order is rejected', () async {
    await place('p-baklawa');
    expect(place('p-tcharek'), throwsOrderError(OrderError.waitingOrder));
  });

  test('the client cannot cancel after acceptance', () async {
    final o = await place('p-baklawa');
    await engine().accept(o.id);
    expect(() => engine().cancelByClient(o.id), throwsOrderError(OrderError.notAllowed));
  });

  test('a placed order expires at its deadline, stock back, no strike', () async {
    final o = await place('p-baklawa');
    final clock = c.read(clockProvider.notifier);
    clock.advance(const Duration(hours: 1, minutes: 59));
    expect(order(o.id).status, OrderStatus.placed);
    clock.advance(const Duration(minutes: 1));
    expect(order(o.id).status, OrderStatus.expired);
    expect(reserved('p-baklawa'), 0);
    expect(balance(), 6200);
  });

  Future<void> deliver(String id) async {
    await engine().accept(id);
    engine()
      ..startPreparation(id)
      ..markReady(id)
      ..pickedUp(id)
      ..delivered(id);
  }

  test('earnings without free delivery: item total − 10%', () async {
    final before = storeBalance('s-fatma');
    final o = await place('p-baklawa');
    await deliver(o.id);
    expect(storeBalance('s-fatma') - before, 2400 - 240);
    expect(order(o.id).money, Money.paid);
  });

  test('earnings with free delivery: item total − 10% − delivery fee', () async {
    final before = storeBalance('s-amina');
    final o = await place('p-cupcakes'); // free delivery, 9 km → fee 520
    expect(o.total, 1300);
    await deliver(o.id);
    expect(storeBalance('s-amina') - before, 1300 - 130 - 520);
  });

  test("a delivered basket counts as sold per line, and its review counts for each product", () async {
    int sold(String id) => c.read(orderEngineProvider).product(id).sold;
    final before = (sold('p-baklawa'), sold('p-tcharek'));
    engine().setBalance(demoClientId, 20000);
    final o = await placeAll([now('p-baklawa', 2), now('p-tcharek')]);
    await deliver(o.id);
    expect((sold('p-baklawa'), sold('p-tcharek')), (before.$1 + 2, before.$2 + 1));
    engine().addReview(o.id, 1, '');
    final s = c.read(orderEngineProvider);
    expect(s.reviews.first.productIds, ['p-baklawa', 'p-tcharek']);
    expect(s.rating(productId: 'p-tcharek')!.count, 2); // the seed review + this one
  });

  test('made to order: qty step, date and options are enforced; price includes options', () async {
    Future<Order> makrout(num qty, DateTime? day, [Map<String, List<String>> picks = const {}]) =>
        placeAll([OrderDraft(productId: 'p-makrout', type: OrderType.madeToOrder, qty: qty, picks: picks, date: day)]);

    final now = c.read(clockProvider);
    var day = DateTime(now.year, now.month, now.day + 2);
    while (!{DateTime.tuesday, DateTime.thursday, DateTime.saturday}.contains(day.weekday)) {
      day = day.add(const Duration(days: 1));
    }
    expect(makrout(1.2, day), throwsOrderError(OrderError.invalidQty));
    expect(makrout(1.5, null), throwsOrderError(OrderError.invalidDate));
    expect(makrout(1.5, day.add(const Duration(days: 1))), throwsOrderError(OrderError.invalidDate));
    final o = await makrout(1.5, day, {
      'g-extras': ['c-honey', 'c-gift'],
    });
    expect(o.itemTotal, 2800 * 1.5 + 200 * 1.5 + 300);
  });

  test('cancel after acceptance refunds in full and the 3rd strike suspends the store', () async {
    final o = await place('p-baklawa');
    await engine().accept(o.id);
    engine().cancelAfterAcceptance(o.id, 'Rupture');
    expect(balance(), 6200);
    expect(order(o.id).money, Money.refunded);
    engine().cancelAfterAcceptance('KF-1005', 'Rupture'); // seeded accepted order; seed has 1 strike
    final now = c.read(clockProvider);
    expect(c.read(orderEngineProvider).store('s-fatma').suspendedAt(now), isTrue);
  });

  test('reset restores the seed data', () async {
    await place('p-baklawa');
    engine().setBalance(demoClientId, 0);
    c.read(clockProvider.notifier).advance(const Duration(hours: 5));
    engine().reset();
    final s = c.read(orderEngineProvider);
    expect(balance(), 6200);
    expect(s.orders, hasLength(8));
    expect(s.nextOrderNo, 1009);
    expect(reserved('p-baklawa'), 0);
    expect(s.orders.where((o) => o.status == OrderStatus.placed), hasLength(2));
  });

  test('contactCheck blocks contact details and allows normal text', () {
    expect(contactCheck('wtsp 0555 12 34 56'), isNotNull);
    expect(contactCheck('wtsp 0555123456'), isNotNull);
    expect(contactCheck('+213 6 61 22 33 44'), ContactIssue.phone);
    expect(contactCheck('écris-moi sur insta'), ContactIssue.word);
    expect(contactCheck('amina.gateaux@gmail.com'), ContactIssue.email);
    expect(contactCheck('@amina_cakes'), ContactIssue.handle);
    expect(contactCheck('www.amina.dz'), ContactIssue.link);
    expect(contactCheck('راسلني على واتساب'), ContactIssue.word);
    expect(contactCheck('Gâteau au chocolat'), isNull);
    expect(contactCheck('Pour 12 personnes, 2 étages'), isNull);
    expect(contactCheck('Joyeux anniversaire Lina'), isNull);
  });
}
