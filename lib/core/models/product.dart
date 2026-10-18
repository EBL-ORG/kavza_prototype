import 'catalog.dart';

enum ProductStatus { live, paused, draft }

/// "Only a few left" from this many available units (placeholder, brief §2).
const fewLeftAt = 3;

enum Unit { piece, kg, box, portion }

enum OptionType { single, multiple, colour, text }

class OptionChoice {
  const OptionChoice(this.id, this.name, {this.price = 0, this.perUnit = false, this.swatch});

  final String id, name;
  final int price;

  /// true: price × quantity; false: once per order.
  final bool perUnit;

  /// Index into `context.kafza.swatches` (colour groups only).
  final int? swatch;
}

class OptionGroup {
  const OptionGroup(
    this.id,
    this.name,
    this.type, {
    this.required = false,
    this.choices = const [],
    this.maxLength = 30,
  });

  final String id, name;
  final OptionType type;
  final bool required;
  final List<OptionChoice> choices;

  /// Text groups only.
  final int maxLength;
}

class ReadyMade {
  const ReadyMade({
    required this.price,
    required this.stock,
    this.reserved = 0,
    this.prepTime = const Duration(hours: 1),
    this.lowStockAlert = 3,
  });

  final int price, stock, reserved, lowStockAlert;
  final Duration prepTime;

  /// What a client can still order: stock minus what waiting orders hold.
  int get available => stock - reserved;

  ReadyMade copyWith({int? price, int? stock, int? reserved, Duration? prepTime, int? lowStockAlert}) =>
      ReadyMade(
        price: price ?? this.price,
        stock: stock ?? this.stock,
        reserved: reserved ?? this.reserved,
        prepTime: prepTime ?? this.prepTime,
        lowStockAlert: lowStockAlert ?? this.lowStockAlert,
      );
}

class MadeToOrder {
  const MadeToOrder({
    required this.price,
    this.minQty = 1,
    this.maxQty,
    this.step = 1,
    required this.leadTime,
    required this.prepTime,
    this.availableDays = const {1, 2, 3, 4, 5, 6, 7},
    this.optionGroups = const [],
  });

  final int price;
  final num minQty, step;
  final num? maxQty;
  final Duration leadTime, prepTime;

  /// `DateTime.monday` … `DateTime.sunday`.
  final Set<int> availableDays;
  final List<OptionGroup> optionGroups;
}

class Product {
  const Product({
    required this.id,
    required this.storeId,
    required this.category,
    required this.title,
    this.description = '',
    this.ingredients = '',
    this.unit = Unit.piece,
    this.photos = 1,
    this.freeDelivery = false,
    this.status = ProductStatus.live,
    this.readyMade,
    this.madeToOrder,
    required this.createdAt,
    this.sold = 0,
  });

  final String id, storeId, title, description, ingredients;
  final Category category;
  final Unit unit;

  /// Number of photos. Seed products bundle theirs as `assets/images/<id>_<n>.jpg`; others show the initial tile.
  final int photos;
  final bool freeDelivery;
  final ProductStatus status;
  final ReadyMade? readyMade;
  final MadeToOrder? madeToOrder;
  final DateTime createdAt;
  final int sold;

  bool get canOrderNow => (readyMade?.available ?? 0) > 0;

  bool get fewLeft => canOrderNow && readyMade!.available <= fewLeftAt;

  /// The price shown on cards: ready-made first, else made to order.
  int get displayPrice => readyMade?.price ?? madeToOrder!.price;

  Product copyWith({
    String? title,
    String? description,
    String? ingredients,
    Category? category,
    Unit? unit,
    int? photos,
    bool? freeDelivery,
    ProductStatus? status,
    ReadyMade? readyMade,
    MadeToOrder? madeToOrder,
    int? sold,
  }) =>
      Product(
        id: id,
        storeId: storeId,
        category: category ?? this.category,
        title: title ?? this.title,
        description: description ?? this.description,
        ingredients: ingredients ?? this.ingredients,
        unit: unit ?? this.unit,
        photos: photos ?? this.photos,
        freeDelivery: freeDelivery ?? this.freeDelivery,
        status: status ?? this.status,
        readyMade: readyMade ?? this.readyMade,
        madeToOrder: madeToOrder ?? this.madeToOrder,
        createdAt: createdAt,
        sold: sold ?? this.sold,
      );
}
