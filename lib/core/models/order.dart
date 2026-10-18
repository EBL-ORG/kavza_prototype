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
    required this.productId,
    required this.productTitle,
    required this.unit,
    required this.type,
    required this.qty,
    this.options = const [],
    this.deliveryDate,
    required this.address,
    required this.itemTotal,
    required this.deliveryFee,
    required this.freeDelivery,
    required this.status,
    required this.money,
    required this.deadline,
    required this.history,
  });

  final String id, clientId, storeId, productId, productTitle;
  final Unit unit;
  final OrderType type;
  final num qty;
  final List<OrderOption> options;

  /// Made to order only.
  final DateTime? deliveryDate;

  /// Full address for the client and the courier; the store only ever shows `address.commune`.
  final Address address;
  final int itemTotal, deliveryFee;
  final bool freeDelivery;
  final OrderStatus status;
  final Money money;

  /// End of the acceptance window.
  final DateTime deadline;
  final List<OrderEvent> history;

  DateTime get placedAt => history.first.time;

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
        productId: productId,
        productTitle: productTitle,
        unit: unit,
        type: type,
        qty: qty,
        options: options,
        deliveryDate: deliveryDate,
        address: address,
        itemTotal: itemTotal,
        deliveryFee: deliveryFee,
        freeDelivery: freeDelivery,
        status: status ?? this.status,
        money: money ?? this.money,
        deadline: deadline,
        history: history ?? this.history,
      );
}
