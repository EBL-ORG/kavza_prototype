import 'order.dart';

enum AppSide { client, store }

enum NoticeKind { order, lowStock, review, strike, suspended, storeApproved, storeRejected }

/// Text is built at display time from [kind] (+ [status]) so it follows the app language.
class AppNotification {
  const AppNotification({
    required this.app,
    required this.to,
    required this.kind,
    required this.time,
    this.orderId,
    this.status,
    this.productId,
    this.read = false,
  });

  final AppSide app;

  /// Client id or store id.
  final String to;
  final NoticeKind kind;
  final DateTime time;
  final String? orderId, productId;

  /// For [NoticeKind.order]: the order's new status.
  final OrderStatus? status;
  final bool read;

  AppNotification markRead() => AppNotification(
      app: app, to: to, kind: kind, time: time, orderId: orderId, status: status, productId: productId, read: true);
}
