import '../models/catalog.dart';
import '../models/client.dart';
import '../models/notification.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../models/store.dart';

/// Everything both apps share. Only the order engine replaces it.
class AppState {
  const AppState({
    required this.stores,
    required this.products,
    required this.clients,
    required this.orders,
    required this.reviews,
    required this.strikes,
    required this.withdrawals,
    required this.notifications,
    required this.nextOrderNo,
  });

  final List<Store> stores;
  final List<Product> products;
  final List<Client> clients;

  /// Newest first.
  final List<Order> orders;
  final List<Review> reviews;
  final List<Strike> strikes;
  final List<Withdrawal> withdrawals;

  /// Newest first.
  final List<AppNotification> notifications;
  final int nextOrderNo;

  Store store(String id) => stores.firstWhere((s) => s.id == id);
  Product product(String id) => products.firstWhere((p) => p.id == id);
  Client client(String id) => clients.firstWhere((c) => c.id == id);
  Order order(String id) => orders.firstWhere((o) => o.id == id);

  /// A store clients can order from: approved, not paused, not suspended.
  bool takingOrders(Store s, DateTime now) => s.status == StoreStatus.approved && !s.paused && !s.suspendedAt(now);

  /// Stores clients can find. Pending and rejected stores stay hidden.
  List<Store> get listedStores => stores.where((s) => s.status == StoreStatus.approved).toList();

  /// Products clients can find (CLT-03): live, from a store taking orders.
  List<Product> listedProducts(DateTime now) =>
      products.where((p) => p.status == ProductStatus.live && takingOrders(store(p.storeId), now)).toList();

  /// The client's order still waiting for the store (at most one).
  Order? waitingOrder(String clientId) =>
      orders.where((o) => o.clientId == clientId && o.status == OrderStatus.placed).firstOrNull;

  /// The one category a free-plan store sells in (the first of its other products'), or
  /// null when any category is open: Pro, or no other product yet (brief §2).
  Category? freeCategory(String storeId, {String? except}) {
    if (store(storeId).pro) return null;
    return products.where((p) => p.storeId == storeId && p.id != except).firstOrNull?.category;
  }

  /// A product with an unfinished order can't be deleted (STR-20).
  bool hasOpenOrder(String productId) =>
      orders.any((o) => _open.contains(o.status) && o.lines.any((l) => l.productId == productId));

  static const _open = {
    OrderStatus.placed,
    OrderStatus.accepted,
    OrderStatus.inPreparation,
    OrderStatus.ready,
    OrderStatus.pickedUp,
  };

  /// Average stars and review count; null when there is no review yet.
  ({double stars, int count})? rating({String? storeId, String? productId, Service? service}) {
    final rs = reviews.where((r) =>
        (storeId == null || r.storeId == storeId) &&
        (productId == null || r.productIds.contains(productId)) &&
        (service == null || r.service == service));
    if (rs.isEmpty) return null;
    return (stars: rs.fold(0, (sum, r) => sum + r.stars) / rs.length, count: rs.length);
  }

  AppState copyWith({
    List<Store>? stores,
    List<Product>? products,
    List<Client>? clients,
    List<Order>? orders,
    List<Review>? reviews,
    List<Strike>? strikes,
    List<Withdrawal>? withdrawals,
    List<AppNotification>? notifications,
    int? nextOrderNo,
  }) =>
      AppState(
        stores: stores ?? this.stores,
        products: products ?? this.products,
        clients: clients ?? this.clients,
        orders: orders ?? this.orders,
        reviews: reviews ?? this.reviews,
        strikes: strikes ?? this.strikes,
        withdrawals: withdrawals ?? this.withdrawals,
        notifications: notifications ?? this.notifications,
        nextOrderNo: nextOrderNo ?? this.nextOrderNo,
      );
}
