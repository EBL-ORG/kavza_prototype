import 'catalog.dart';

enum StoreStatus { pending, approved, rejected }

/// What the store shows as its picture (STR-08): a bundled photo, its activity's 3D emoji as logo, or its initial.
enum StorePicture { none, photo, logo }

class Store {
  const Store({
    required this.id,
    required this.name,
    this.description = '',
    required this.commune,
    required this.wilaya,
    required this.distanceKm,
    this.status = StoreStatus.approved,
    this.paused = false,
    this.pro = false,
    this.reliability = 100,
    this.balance = 0,
    this.suspendedUntil,
    this.phone = '',
    this.cardNumber = '',
    this.activity,
    this.ccp = '',
    this.pickup = (0.5, 0.5),
    this.picture = StorePicture.none,
  });

  final String id, name, description, commune, wilaya;

  /// Owner's verified phone and auto-entrepreneur card number (STR-01/02). Never shown to clients.
  final String phone, cardNumber;
  final Service? activity;

  /// CCP / BaridiMob account for withdrawals (STR-11).
  final String ccp;

  /// Pickup pin on the mock map, as fractions of its width and height (STR-10). Private.
  final (double, double) pickup;
  final StorePicture picture;

  /// Approximate distance from the client (the client never sees an address).
  // ponytail: one distance per store, not per client address; compute from coordinates if addresses must differ.
  final double distanceKm;
  final StoreStatus status;
  final bool paused, pro;

  /// Share of accepted orders delivered, in % (TRS-06).
  final int reliability;

  /// Earnings available to withdraw, in DZD.
  final int balance;
  final DateTime? suspendedUntil;

  bool suspendedAt(DateTime now) => suspendedUntil != null && now.isBefore(suspendedUntil!);

  Store copyWith({
    String? name,
    String? description,
    String? commune,
    String? wilaya,
    StoreStatus? status,
    bool? paused,
    bool? pro,
    int? balance,
    DateTime? suspendedUntil,
    String? phone,
    String? cardNumber,
    Service? activity,
    String? ccp,
    (double, double)? pickup,
    StorePicture? picture,
  }) =>
      Store(
        id: id,
        name: name ?? this.name,
        description: description ?? this.description,
        commune: commune ?? this.commune,
        wilaya: wilaya ?? this.wilaya,
        distanceKm: distanceKm,
        status: status ?? this.status,
        paused: paused ?? this.paused,
        pro: pro ?? this.pro,
        reliability: reliability,
        balance: balance ?? this.balance,
        suspendedUntil: suspendedUntil ?? this.suspendedUntil,
        phone: phone ?? this.phone,
        cardNumber: cardNumber ?? this.cardNumber,
        activity: activity ?? this.activity,
        ccp: ccp ?? this.ccp,
        pickup: pickup ?? this.pickup,
        picture: picture ?? this.picture,
      );
}

class Review {
  const Review({
    required this.orderId,
    required this.storeId,
    required this.productIds,
    required this.service,
    required this.stars,
    this.comment = '',
    required this.time,
    this.reported = false,
  });

  final String orderId, storeId, comment;

  /// Every product of the order: one review counts for each of them.
  final List<String> productIds;
  final Service service;
  final int stars;
  final DateTime time;

  /// The store flagged it to Kafza (STR-36). It stays visible until Kafza decides.
  final bool reported;

  Review copyWith({bool? reported}) => Review(
        orderId: orderId,
        storeId: storeId,
        productIds: productIds,
        service: service,
        stars: stars,
        comment: comment,
        time: time,
        reported: reported ?? this.reported,
      );
}

class Strike {
  const Strike({required this.storeId, required this.orderId, required this.reason, required this.time, this.appeal});

  final String storeId, orderId, reason;
  final DateTime time;

  /// The store's appeal text, once sent (STR-37). Kafza decides outside the prototype.
  final String? appeal;

  Strike copyWith({String? appeal}) =>
      Strike(storeId: storeId, orderId: orderId, reason: reason, time: time, appeal: appeal ?? this.appeal);
}

enum WithdrawalStatus { requested, sent, failed }

class Withdrawal {
  const Withdrawal({required this.storeId, required this.amount, required this.time, required this.status});

  final String storeId;
  final int amount;
  final DateTime time;
  final WithdrawalStatus status;
}
