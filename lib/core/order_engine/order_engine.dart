import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../contact_check.dart';
import '../data/app_state.dart';
import '../data/clock.dart';
import '../data/seed.dart';
import '../models/catalog.dart';
import '../models/notification.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../models/store.dart';

/// Fake network latency for wallet calls (300–1200 ms). Tests override it with a no-op.
final fakeDelayProvider = Provider<Future<void> Function()>(
  (ref) => () => Future.delayed(Duration(milliseconds: 300 + Random().nextInt(901))),
);

/// The shared state of both apps, and the only code that changes order status, stock,
/// wallet, earnings and strikes. Screens watch it and call its methods.
final orderEngineProvider = NotifierProvider<OrderEngine, AppState>(OrderEngine.new);

/// Why an engine call was refused. Screens map it to an ARB message.
enum OrderError {
  unavailable,
  waitingOrder,
  outOfStock,
  invalidQty,
  missingOption,
  invalidOption,
  contactDetails,
  invalidDate,
  lowBalance,
  notAllowed,
}

class OrderException implements Exception {
  const OrderException(this.error);
  final OrderError error;

  @override
  String toString() => 'OrderException(${error.name})';
}

/// Acceptance window (brief §2).
Duration acceptanceWindow(OrderType type) =>
    type == OrderType.readyMade ? const Duration(hours: 2) : const Duration(hours: 24);

const strikesBeforeSuspension = 3;
const suspension = Duration(days: 7);
const disputeWindow = Duration(hours: 48);

/// Kafza Pro, paid monthly from the store balance (placeholder, brief §2).
const proPrice = 1500;

/// Smallest withdrawal to the store's CCP (placeholder, brief §2).
const minWithdrawal = 2000;

/// Item total = unit price × qty + options (PAY-01). Unknown choice ids are ignored here;
/// placeOrder rejects them.
int itemTotalOf(Product p, OrderType type, num qty, Map<String, List<String>> picks) {
  final unit = type == OrderType.readyMade ? p.readyMade!.price : p.madeToOrder!.price;
  var total = unit * qty;
  for (final g in p.madeToOrder?.optionGroups ?? const <OptionGroup>[]) {
    if (type != OrderType.madeToOrder || g.type == OptionType.text) continue;
    for (final c in g.choices.where((c) => picks[g.id]?.contains(c.id) ?? false)) {
      total += c.perUnit ? c.price * qty : c.price;
    }
  }
  return total.round();
}

DateTime _day(DateTime t) => DateTime(t.year, t.month, t.day);

/// A made-to-order delivery day: at least the lead time away and on an available day.
bool isValidDeliveryDay(MadeToOrder m, DateTime day, DateTime now) =>
    !_day(day).isBefore(_day(now.add(m.leadTime))) && m.availableDays.contains(day.weekday);

class OrderEngine extends Notifier<AppState> {
  @override
  AppState build() {
    ref.listen(clockProvider, (_, _) => expireDue());
    return seed(ref.read(clockProvider));
  }

  DateTime get _now => ref.read(clockProvider);

  // ---------------------------------------------------------------- client

  /// Checks everything and the balance, reserves stock, debits nothing (PAY-02). Several
  /// [items] only for ready-made products of one store; made to order is one item.
  Future<Order> placeOrder({
    required String clientId,
    required String addressId,
    required List<OrderDraft> items,
  }) async {
    await ref.read(fakeDelayProvider)();
    // Everything below is synchronous, so nothing can change between the checks and the write.
    final s = state;
    final now = _now;
    if (items.isEmpty) throw const OrderException(OrderError.notAllowed);
    final type = items.first.type;
    final products = [for (final d in items) s.product(d.productId)];
    final store = s.store(products.first.storeId);
    final client = s.client(clientId);
    if (items.any((d) => d.type != type) ||
        (type == OrderType.madeToOrder && items.length > 1) ||
        products.any((p) => p.storeId != store.id) ||
        products.map((p) => p.id).toSet().length < products.length) {
      throw const OrderException(OrderError.notAllowed);
    }
    if (products.any((p) => p.status != ProductStatus.live) || !s.takingOrders(store, now)) {
      throw const OrderException(OrderError.unavailable);
    }
    if (s.waitingOrder(clientId) != null) {
      throw const OrderException(OrderError.waitingOrder);
    }

    final lines = [for (final (i, d) in items.indexed) _line(products[i], d, now)];
    final date = items.first.date;
    final order = Order(
      id: 'KF-${s.nextOrderNo}',
      clientId: clientId,
      storeId: store.id,
      type: type,
      lines: lines,
      deliveryDate: type == OrderType.madeToOrder ? _day(date!) : null,
      address: client.addresses.firstWhere((a) => a.id == addressId),
      deliveryFee: deliveryFee(store.distanceKm),
      freeDelivery: products.every((p) => p.freeDelivery),
      status: OrderStatus.placed,
      money: Money.inWallet,
      deadline: now.add(acceptanceWindow(type)),
      history: [OrderEvent(OrderStatus.placed, now)],
    );
    if (client.balance < order.total) throw const OrderException(OrderError.lowBalance);

    state = s.copyWith(orders: [order, ...s.orders], nextOrderNo: s.nextOrderNo + 1);
    _reserve(order, 1);
    _notify(AppSide.store, order.storeId, order: order);
    return order;
  }

  /// One draft checked against its product: quantity, stock, options, date.
  OrderLine _line(Product p, OrderDraft d, DateTime now) {
    final qty = d.qty;
    final options = <OrderOption>[];
    if (d.type == OrderType.readyMade) {
      final rm = p.readyMade ?? (throw const OrderException(OrderError.unavailable));
      if (qty < 1 || qty != qty.round()) throw const OrderException(OrderError.invalidQty);
      if (qty > rm.available) throw const OrderException(OrderError.outOfStock);
    } else {
      final m = p.madeToOrder ?? (throw const OrderException(OrderError.unavailable));
      final steps = (qty - m.minQty) / m.step;
      if (qty < m.minQty || (m.maxQty != null && qty > m.maxQty!) || (steps - steps.round()).abs() > 1e-9) {
        throw const OrderException(OrderError.invalidQty);
      }
      for (final g in m.optionGroups) {
        final picked = d.picks[g.id] ?? const [];
        if (g.type == OptionType.text) {
          final text = picked.isEmpty ? '' : picked.single.trim();
          if (text.isEmpty) {
            if (g.required) throw const OrderException(OrderError.missingOption);
            continue;
          }
          if (contactCheck(text) != null) throw const OrderException(OrderError.contactDetails);
          if (text.length > g.maxLength) throw const OrderException(OrderError.invalidOption);
          options.add(OrderOption(g.name, text, 0));
          continue;
        }
        if (g.required && picked.isEmpty) throw const OrderException(OrderError.missingOption);
        if (g.type != OptionType.multiple && picked.length > 1) throw const OrderException(OrderError.invalidOption);
        for (final id in picked) {
          final c = g.choices.where((c) => c.id == id).firstOrNull ??
              (throw const OrderException(OrderError.invalidOption));
          options.add(OrderOption(g.name, c.name, (c.perUnit ? c.price * qty : c.price).round()));
        }
      }
      if (d.date == null || !isValidDeliveryDay(m, d.date!, now)) {
        throw const OrderException(OrderError.invalidDate);
      }
    }
    return OrderLine(
      productId: p.id,
      title: p.title,
      unit: p.unit,
      qty: qty,
      options: options,
      total: itemTotalOf(p, d.type, qty, d.picks),
    );
  }

  /// Placed only (CLT-26).
  void cancelByClient(String orderId) {
    final o = _require(orderId, {OrderStatus.placed});
    _reserve(o, -1);
    _move(o, OrderStatus.cancelledByClient, store: true);
  }

  /// Within 48 h of delivery (TRS-13).
  void openDispute(String orderId, String reason) {
    final o = _require(orderId, {OrderStatus.delivered});
    if (_now.difference(o.timeOf(OrderStatus.delivered)!) > disputeWindow) {
      throw const OrderException(OrderError.notAllowed);
    }
    if (contactCheck(reason) != null) throw const OrderException(OrderError.contactDetails);
    _move(o, OrderStatus.disputed, note: reason, store: true);
  }

  /// Once per delivered order.
  void addReview(String orderId, int stars, String comment) {
    final o = _require(orderId, {OrderStatus.delivered, OrderStatus.disputed});
    if (stars < 1 || stars > 5 || state.reviews.any((r) => r.orderId == orderId)) {
      throw const OrderException(OrderError.notAllowed);
    }
    if (contactCheck(comment) != null) throw const OrderException(OrderError.contactDetails);
    final review = Review(
      orderId: o.id,
      storeId: o.storeId,
      productIds: [for (final l in o.lines) l.productId],
      service: state.product(o.lines.first.productId).category.service,
      stars: stars,
      comment: comment.trim(),
      time: _now,
    );
    state = state.copyWith(reviews: [review, ...state.reviews]);
    _notify(AppSide.store, o.storeId, kind: NoticeKind.review, order: o);
  }

  /// Mock CCP top-up from the Yassir recharge page.
  Future<void> recharge(String clientId, int amount) async {
    await ref.read(fakeDelayProvider)();
    state = state.copyWith(
        clients: _replace(state.clients, (c) => c.id == clientId, (c) => c.copyWith(balance: c.balance + amount)));
  }

  // ---------------------------------------------------------------- store

  /// The reason shows on the client's timeline, so contact details are refused.
  void decline(String orderId, String reason) {
    final o = _require(orderId, {OrderStatus.placed});
    if (contactCheck(reason) != null) throw const OrderException(OrderError.contactDetails);
    _reserve(o, -1);
    _move(o, OrderStatus.declined, note: reason, client: true);
  }

  /// Debits the full total or nothing (PAY-04). A second call is a no-op, so a double tap
  /// never debits twice. Returns the order as it ends up (Accepted, Payment failed or Expired).
  Future<Order> accept(String orderId) async {
    await ref.read(fakeDelayProvider)();
    final o = state.order(orderId);
    if (o.status != OrderStatus.placed || o.money != Money.inWallet) return o;
    if (!_now.isBefore(o.deadline)) {
      _expire(o);
      return state.order(orderId);
    }
    final client = state.client(o.clientId);
    if (client.balance < o.total) {
      _reserve(o, -1);
      _move(o, OrderStatus.paymentFailed, client: true, store: true);
      return state.order(orderId);
    }
    state = state.copyWith(clients: _replace(state.clients, (c) => c.id == client.id, (c) => c.copyWith(balance: c.balance - o.total)));
    if (o.type == OrderType.readyMade) {
      for (final l in o.lines) {
        final q = l.qty.toInt();
        _updateReadyMade(l.productId, (rm) => rm.copyWith(stock: rm.stock - q, reserved: rm.reserved - q));
        final rm = state.product(l.productId).readyMade!;
        if (rm.available <= rm.lowStockAlert) {
          _notify(AppSide.store, o.storeId, kind: NoticeKind.lowStock, productId: l.productId);
        }
      }
    }
    _move(o, OrderStatus.accepted, money: Money.held, client: true);
    return state.order(orderId);
  }

  void startPreparation(String orderId) =>
      _move(_require(orderId, {OrderStatus.accepted}), OrderStatus.inPreparation, client: true);

  /// Sends the delivery request to Yassir Express (DLV-01).
  void markReady(String orderId) =>
      _move(_require(orderId, {OrderStatus.accepted, OrderStatus.inPreparation}), OrderStatus.ready, client: true);

  /// Full refund + strike; every 3rd strike suspends the store for 7 days (STR-31, TRS).
  void cancelAfterAcceptance(String orderId, String reason) {
    final o = _require(orderId, {OrderStatus.accepted, OrderStatus.inPreparation});
    if (contactCheck(reason) != null) throw const OrderException(OrderError.contactDetails);
    _refund(o, o.total);
    _move(o, OrderStatus.cancelledAfterAcceptance, note: reason, money: Money.refunded, client: true);
    final now = _now;
    final strikes = [Strike(storeId: o.storeId, orderId: o.id, reason: reason, time: now), ...state.strikes];
    state = state.copyWith(strikes: strikes);
    _notify(AppSide.store, o.storeId, kind: NoticeKind.strike, order: o);
    // ponytail: every 3rd strike ever suspends; add strike expiry when TRS-04's admin settings exist.
    if (strikes.where((s) => s.storeId == o.storeId).length % strikesBeforeSuspension == 0) {
      _updateStore(o.storeId, (st) => st.copyWith(suspendedUntil: now.add(suspension)));
      _notify(AppSide.store, o.storeId, kind: NoticeKind.suspended);
    }
  }

  /// S10: earnings to the store's CCP, at least [minWithdrawal] and at most the balance (STR-34).
  Future<void> withdraw(String storeId, int amount) async {
    await ref.read(fakeDelayProvider)();
    final s = state.store(storeId);
    if (s.ccp.isEmpty || amount < minWithdrawal) throw const OrderException(OrderError.notAllowed);
    if (amount > s.balance) throw const OrderException(OrderError.lowBalance);
    _updateStore(storeId, (s) => s.copyWith(balance: s.balance - amount));
    final w = Withdrawal(storeId: storeId, amount: amount, time: _now, status: WithdrawalStatus.requested);
    state = state.copyWith(withdrawals: [w, ...state.withdrawals]);
  }

  /// S13: one appeal per strike; Kafza decides outside the prototype (STR-37).
  void appealStrike(String orderId, String text) {
    final strike = state.strikes.firstWhere((s) => s.orderId == orderId);
    if (strike.appeal != null || text.trim().isEmpty) throw const OrderException(OrderError.notAllowed);
    if (contactCheck(text) != null) throw const OrderException(OrderError.contactDetails);
    state = state.copyWith(
        strikes: _replace(state.strikes, (s) => s.orderId == orderId, (s) => s.copyWith(appeal: text.trim())));
  }

  /// S12: flag a review to Kafza. The store can't reply or delete it (STR-36).
  void reportReview(String orderId) => state = state.copyWith(
      reviews: _replace(state.reviews, (r) => r.orderId == orderId, (r) => r.copyWith(reported: true)));

  /// Opening the notifications list reads them all.
  void markNotificationsRead(AppSide app, String to) => state = state.copyWith(
      notifications: _replace(state.notifications, (n) => n.app == app && n.to == to && !n.read, (n) => n.markRead()));

  // ---------------------------------------------------------------- store account and catalogue

  /// S3 done: a new store, pending until the back-office (demo panel) approves it (STR-04).
  String registerStore({
    required String name,
    required String phone,
    required String cardNumber,
    required Service activity,
  }) {
    final id = 's-${_now.microsecondsSinceEpoch}';
    // ponytail: new stores start in Alger Centre, 5 km away; S11 sets the commune, not the distance.
    final store = Store(
      id: id,
      name: name,
      commune: 'Alger Centre',
      wilaya: 'Alger',
      distanceKm: 5,
      status: StoreStatus.pending,
      phone: phone,
      cardNumber: cardNumber,
      activity: activity,
    );
    state = state.copyWith(stores: [...state.stores, store]);
    return id;
  }

  /// S4 Resubmit after a rejection: new card details, pending again.
  void resubmitStore(String storeId, {required String cardNumber, required Service activity}) => _updateStore(
      storeId, (s) => s.copyWith(status: StoreStatus.pending, cardNumber: cardNumber, activity: activity));

  /// S11. Name and description are free text, so contact details are refused.
  void updateProfile(
    String storeId, {
    required String name,
    required String description,
    required String commune,
    required String wilaya,
    required String ccp,
    required (double, double) pickup,
    required StorePicture picture,
  }) {
    if (name.trim().isEmpty) throw const OrderException(OrderError.notAllowed);
    if (contactCheck(name) != null || contactCheck(description) != null) {
      throw const OrderException(OrderError.contactDetails);
    }
    _updateStore(
      storeId,
      (s) => s.copyWith(
        name: name.trim(),
        description: description.trim(),
        commune: commune,
        wilaya: wilaya,
        ccp: ccp,
        pickup: pickup,
        picture: picture,
      ),
    );
  }

  /// "Pause my store": its products leave client lists; open orders carry on (STR-26).
  void setStorePaused(String storeId, bool paused) => _updateStore(storeId, (s) => s.copyWith(paused: paused));

  /// Kafza Pro from the store balance; refused when the balance is short.
  Future<void> subscribePro(String storeId) async {
    await ref.read(fakeDelayProvider)();
    final s = state.store(storeId);
    if (s.pro) return;
    if (s.balance < proPrice) throw const OrderException(OrderError.lowBalance);
    _updateStore(storeId, (s) => s.copyWith(pro: true, balance: s.balance - proPrice));
  }

  /// S9: creates ([Product.id] empty) or replaces a product. Live needs an approved store and a
  /// complete product; a free-plan store stays in one category. Stock already reserved by
  /// waiting orders, sales and the creation date are kept. Returns the product id.
  String saveProduct(Product p) {
    final store = state.store(p.storeId);
    final old = state.products.where((x) => x.id == p.id).firstOrNull;
    final texts = [
      p.title,
      p.description,
      p.ingredients,
      for (final g in p.madeToOrder?.optionGroups ?? const <OptionGroup>[]) ...[g.name, ...g.choices.map((c) => c.name)],
    ];
    if (texts.any((t) => contactCheck(t) != null)) throw const OrderException(OrderError.contactDetails);
    final locked = state.freeCategory(store.id, except: p.id);
    if (locked != null && locked != p.category) throw const OrderException(OrderError.notAllowed);
    final complete = p.title.trim().isNotEmpty && p.photos > 0 && (p.readyMade != null || p.madeToOrder != null);
    if (p.status == ProductStatus.live && (store.status != StoreStatus.approved || !complete)) {
      throw const OrderException(OrderError.notAllowed);
    }
    final reserved = old?.readyMade?.reserved ?? 0;
    if (reserved > 0 && (p.readyMade == null || p.readyMade!.stock < reserved)) {
      throw const OrderException(OrderError.outOfStock);
    }

    final saved = Product(
      id: old?.id ?? 'p-${_now.microsecondsSinceEpoch}',
      storeId: p.storeId,
      category: p.category,
      title: p.title.trim(),
      description: p.description.trim(),
      ingredients: p.category.isFood ? p.ingredients.trim() : '',
      unit: p.unit,
      photos: p.photos,
      freeDelivery: p.freeDelivery,
      status: p.status,
      readyMade: p.readyMade?.copyWith(reserved: reserved),
      madeToOrder: p.madeToOrder,
      createdAt: old?.createdAt ?? _now,
      sold: old?.sold ?? 0,
    );
    state = state.copyWith(
      products: old == null ? [saved, ...state.products] : _replace(state.products, (x) => x.id == p.id, (_) => saved),
    );
    return saved.id;
  }

  /// Stock sheet (STR-18). Never below what waiting orders hold.
  void setStock(String productId, int stock) {
    if (stock < state.product(productId).readyMade!.reserved) throw const OrderException(OrderError.outOfStock);
    _updateReadyMade(productId, (rm) => rm.copyWith(stock: stock));
  }

  /// Refused while an order for it is unfinished (STR-20).
  void deleteProduct(String productId) {
    if (state.hasOpenOrder(productId)) throw const OrderException(OrderError.notAllowed);
    state = state.copyWith(products: state.products.where((p) => p.id != productId).toList());
  }

  // ---------------------------------------------------------------- courier (demo panel)

  void pickedUp(String orderId) =>
      _move(_require(orderId, {OrderStatus.ready}), OrderStatus.pickedUp, client: true, store: true);

  /// Credits the store's earnings (PAY-08/09).
  void delivered(String orderId) {
    final o = _require(orderId, {OrderStatus.pickedUp});
    _pay(o);
    _move(o, OrderStatus.delivered, money: Money.paid, client: true, store: true);
  }

  /// Spec §9.4 proposal: made to order → store paid, no refund; ready-made → stock back,
  /// client refunded what they paid minus the delivery fee.
  void deliveryFailed(String orderId) {
    final o = _require(orderId, {OrderStatus.pickedUp});
    if (o.type == OrderType.madeToOrder) {
      _pay(o);
      _move(o, OrderStatus.deliveryFailed, money: Money.paid, client: true, store: true);
    } else {
      for (final l in o.lines) {
        _updateReadyMade(l.productId, (rm) => rm.copyWith(stock: rm.stock + l.qty.toInt()));
      }
      _refund(o, max(0, o.total - o.deliveryFee));
      _move(o, OrderStatus.deliveryFailed, money: Money.refunded, client: true, store: true);
    }
  }

  // ---------------------------------------------------------------- clock

  /// Placed orders past their window become Expired (no strike). Runs on every clock tick.
  void expireDue() {
    final now = _now;
    for (final o in state.orders.where((o) => o.status == OrderStatus.placed && !now.isBefore(o.deadline)).toList()) {
      _expire(o);
    }
  }

  // ---------------------------------------------------------------- demo panel

  void setBalance(String clientId, int balance) => state = state.copyWith(
      clients: _replace(state.clients, (c) => c.id == clientId, (c) => c.copyWith(balance: max(0, balance))));

  /// Back-office stand-in: approve or reject a pending store.
  void reviewStore(String storeId, {required bool approve}) {
    _updateStore(storeId, (s) => s.copyWith(status: approve ? StoreStatus.approved : StoreStatus.rejected));
    _notify(AppSide.store, storeId, kind: approve ? NoticeKind.storeApproved : NoticeKind.storeRejected);
  }

  /// Seed data again, and the clock back to real time.
  void reset() {
    ref.read(clockProvider.notifier).reset();
    state = seed(_now);
  }

  // ---------------------------------------------------------------- internals

  Order _require(String orderId, Set<OrderStatus> from) {
    final o = state.order(orderId);
    if (!from.contains(o.status)) throw const OrderException(OrderError.notAllowed);
    return o;
  }

  void _expire(Order o) {
    _reserve(o, -1);
    _move(o, OrderStatus.expired, client: true, store: true);
  }

  /// Changes the status, adds the history entry and the notifications.
  void _move(Order o, OrderStatus to, {String? note, Money? money, bool client = false, bool store = false}) {
    final now = _now;
    final updated = state.order(o.id).copyWith(
      status: to,
      money: money,
      history: [...state.order(o.id).history, OrderEvent(to, now, note)],
    );
    state = state.copyWith(orders: _replace(state.orders, (x) => x.id == o.id, (_) => updated));
    if (client) _notify(AppSide.client, o.clientId, order: updated);
    if (store) _notify(AppSide.store, o.storeId, order: updated);
  }

  void _notify(AppSide app, String to, {NoticeKind kind = NoticeKind.order, Order? order, String? productId}) {
    final n = AppNotification(
      app: app,
      to: to,
      kind: kind,
      time: _now,
      orderId: order?.id,
      status: kind == NoticeKind.order ? order?.status : null,
      productId: productId,
    );
    state = state.copyWith(notifications: [n, ...state.notifications]);
  }

  /// [sign] 1 reserves every line's quantity, -1 releases it. Made-to-order orders hold no stock.
  void _reserve(Order o, int sign) {
    if (o.type != OrderType.readyMade) return;
    for (final l in o.lines) {
      _updateReadyMade(l.productId, (rm) => rm.copyWith(reserved: rm.reserved + sign * l.qty.toInt()));
    }
  }

  void _refund(Order o, int amount) => state = state.copyWith(
      clients: _replace(state.clients, (c) => c.id == o.clientId, (c) => c.copyWith(balance: c.balance + amount)));

  void _pay(Order o) {
    _updateStore(o.storeId, (s) => s.copyWith(balance: s.balance + o.earnings));
    for (final l in o.lines) {
      state = state.copyWith(
          products: _replace(state.products, (p) => p.id == l.productId, (p) => p.copyWith(sold: p.sold + l.qty.ceil())));
    }
  }

  void _updateReadyMade(String productId, ReadyMade Function(ReadyMade) f) => state = state.copyWith(
      products: _replace(state.products, (p) => p.id == productId, (p) => p.copyWith(readyMade: f(p.readyMade!))));

  void _updateStore(String storeId, Store Function(Store) f) =>
      state = state.copyWith(stores: _replace(state.stores, (s) => s.id == storeId, f));
}

List<T> _replace<T>(List<T> list, bool Function(T) where, T Function(T) f) => [for (final x in list) where(x) ? f(x) : x];
