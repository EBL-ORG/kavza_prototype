import 'dart:math';

import 'client.dart';
import 'product.dart';

enum OrderType { readyMade, madeToOrder }

enum OrderStatus {
  placed,
  accepted,
  inPreparation,
  ready,
  pickedUp,
  delivered,
  cancelledByClient,
  declined,
  expired,
  paymentFailed,
  cancelledAfterAcceptance,
  deliveryFailed,
  disputed,
}

/// Where the client's money is (spec §8 table).
enum Money { inWallet, held, refunded, paid }

/// Kafza commission on the item total (placeholder, brief §2).
const commissionRate = 0.10;

/// Yassir Express fee: 250 DZD + 30 DZD/km, capped at 900 (placeholder, brief §2).
int deliveryFee(double km) => min(900, 250 + (30 * km).round());

/// Rough Yassir Express trip after pickup (placeholder): 20 min + 3 min/km.
Duration deliveryEta(double km) => Duration(minutes: 20 + (3 * km).round());

class OrderOption {
  const OrderOption(this.group, this.value, this.price);

  final String group, value;

  /// Line total for this option (already × quantity when priced per unit).
  final int price;
}

/// One product as the client configured it, before the engine checks it.
class OrderDraft {
  const OrderDraft({required this.productId, required this.type, required this.qty, this.picks = const {}, this.date});

  final String productId;
  final OrderType type;
  final num qty;

  /// Option group id → choice ids, or the typed text for text groups.
  final Map<String, List<String>> picks;
  final DateTime? date;
}

/// One product of an order. Ready-made orders can hold several, from one store.
class OrderLine {
  const OrderLine({
    required this.productId,
    required this.title,
    required this.unit,
    required this.qty,
    this.options = const [],
    required this.total,
  });

  final String productId, title;
  final Unit unit;
  final num qty;
  final List<OrderOption> options;

  /// Unit price × qty + options.
  final int total;
}

class OrderEvent {
  const OrderEvent(this.status, this.time, [this.note]);

  final OrderStatus status;
  final DateTime time;
  final String? note;
}

class Order {
  const Order({
    required this.id,
    required this.clientId,
    required this.storeId,
    required this.type,
    required this.lines,
    this.deliveryDate,
    required this.address,
    required this.deliveryFee,
    required this.freeDelivery,
    required this.status,
    required this.money,
    required this.deadline,
    required this.history,
  });

  final String id, clientId, storeId;
  final OrderType type;

  /// At least one; made-to-order orders have exactly one.
  final List<OrderLine> lines;

  /// Made to order only.
  final DateTime? deliveryDate;

  /// Full address for the client and the courier; the store only ever shows `address.commune`.
  final Address address;
  final int deliveryFee;

  /// Only when every line has free delivery.
  final bool freeDelivery;
  final OrderStatus status;
  final Money money;

  /// End of the acceptance window.
  final DateTime deadline;
  final List<OrderEvent> history;

  DateTime get placedAt => history.first.time;

  int get itemTotal => lines.fold(0, (s, l) => s + l.total);

  /// What the client pays (PAY-01).
  int get total => itemTotal + (freeDelivery ? 0 : deliveryFee);

  /// What went back to Yassir Cash when [money] is refunded: everything, except a failed
  /// ready-made delivery keeps the delivery fee (spec §9.4, as in the engine).
  int get refund => status == OrderStatus.deliveryFailed ? max(0, total - deliveryFee) : total;

  int get commission => (itemTotal * commissionRate).round();

  /// Store earnings (PAY-08).
  int get earnings => itemTotal - commission - (freeDelivery ? deliveryFee : 0);

  DateTime? timeOf(OrderStatus s) {
    for (final e in history.reversed) {
      if (e.status == s) return e.time;
    }
    return null;
  }

  Order copyWith({OrderStatus? status, Money? money, List<OrderEvent>? history}) => Order(
        id: id,
        clientId: clientId,
        storeId: storeId,
        type: type,
        lines: lines,
        deliveryDate: deliveryDate,
        address: address,
        deliveryFee: deliveryFee,
        freeDelivery: freeDelivery,
        status: status ?? this.status,
        money: money ?? this.money,
        deadline: deadline,
        history: history ?? this.history,
      );
}
