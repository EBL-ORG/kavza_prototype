/// Kafza's fixed taxonomy. Labels come from the ARB files, so these stay enums.
enum Service { cooking, sewing, crafts }

enum Category {
  traditionalFood(Service.cooking),
  traditionalSweets(Service.cooking),
  cakes(Service.cooking),
  breads(Service.cooking),
  traditionalClothing(Service.sewing),
  childrenClothing(Service.sewing),
  pottery(Service.crafts),
  rugs(Service.crafts),
  baskets(Service.crafts),
  jewellery(Service.crafts);

  const Category(this.service);
  final Service service;

  /// Ingredients are shown for food only.
  bool get isFood => service == Service.cooking;
}
