import '../contact_check.dart';
import '../models/catalog.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../order_engine/order_engine.dart';
import 'app_localizations.dart';

/// Display labels for model enums.
extension Labels on AppLocalizations {
  String status(OrderStatus s) => switch (s) {
        OrderStatus.placed => statusPlaced,
        OrderStatus.accepted => statusAccepted,
        OrderStatus.inPreparation => statusInPreparation,
        OrderStatus.ready => statusReady,
        OrderStatus.pickedUp => statusPickedUp,
        OrderStatus.delivered => statusDelivered,
        OrderStatus.cancelledByClient => statusCancelledByClient,
        OrderStatus.declined => statusDeclined,
        OrderStatus.expired => statusExpired,
        OrderStatus.paymentFailed => statusPaymentFailed,
        OrderStatus.cancelledAfterAcceptance => statusCancelledAfterAcceptance,
        OrderStatus.deliveryFailed => statusDeliveryFailed,
        OrderStatus.disputed => statusDisputed,
      };

  String service(Service s) => switch (s) {
        Service.cooking => serviceCooking,
        Service.sewing => serviceSewing,
        Service.crafts => serviceCrafts,
      };

  String category(Category c) => switch (c) {
        Category.traditionalFood => categoryTraditionalFood,
        Category.traditionalSweets => categoryTraditionalSweets,
        Category.cakes => categoryCakes,
        Category.breads => categoryBreads,
        Category.traditionalClothing => categoryTraditionalClothing,
        Category.childrenClothing => categoryChildrenClothing,
        Category.pottery => categoryPottery,
        Category.rugs => categoryRugs,
        Category.baskets => categoryBaskets,
        Category.jewellery => categoryJewellery,
      };

  /// "/ kg" part of a unit price.
  String unit(Unit u) => switch (u) {
        Unit.piece => unitPiece,
        Unit.kg => unitKg,
        Unit.box => unitBox,
        Unit.portion => unitPortion,
      };

  String optionType(OptionType t) => switch (t) {
        OptionType.single => optionSingle,
        OptionType.multiple => optionMultiple,
        OptionType.colour => optionColour,
        OptionType.text => optionText,
      };

  /// "1,5 kg", "10 pièces".
  String qty(Unit u, num n) => switch (u) {
        Unit.piece => qtyPiece(n),
        Unit.kg => qtyKg(n),
        Unit.box => qtyBox(n),
        Unit.portion => qtyPortion(n),
      };

  /// Why a free text was blocked, plus the reason Kafza blocks it.
  String contactBlocked(ContactIssue i) => '${switch (i) {
        ContactIssue.phone => contactPhone,
        ContactIssue.email => contactEmail,
        ContactIssue.link => contactLink,
        ContactIssue.handle => contactHandle,
        ContactIssue.word => contactWord,
      }} $contactWhy';

  String orderError(OrderError e) => switch (e) {
        OrderError.unavailable => errorUnavailable,
        OrderError.waitingOrder => errorWaitingOrder,
        OrderError.outOfStock => errorOutOfStock,
        OrderError.invalidQty => errorInvalidQty,
        OrderError.missingOption => errorMissingOption,
        OrderError.invalidOption => errorInvalidOption,
        OrderError.contactDetails => contactWhy,
        OrderError.invalidDate => errorInvalidDate,
        OrderError.lowBalance => errorLowBalance,
        OrderError.notAllowed => errorNotAllowed,
      };
}
