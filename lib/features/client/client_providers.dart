import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/data/app_state.dart';
import '../../core/models/catalog.dart';
import '../../core/models/product.dart';
import '../../core/models/store.dart';

/// A plain value the client screens share (selected address, filters, recent searches).
class Setting<T> extends Notifier<T> {
  Setting(this._initial);

  final T _initial;

  @override
  T build() => _initial;

  void set(T value) => state = value;
}

/// Saved product and store ids (CLT-08). Ids are prefixed (p-, s-), so one set holds both.
final favouritesProvider = NotifierProvider<Favourites, Set<String>>(Favourites.new);

class Favourites extends Notifier<Set<String>> {
  @override
  Set<String> build() => const {};

  void toggle(String id) => state = state.contains(id) ? ({...state}..remove(id)) : {...state, id};
}

/// The delivery address picked on the home screen.
final addressIdProvider = NotifierProvider<Setting<String>, String>(() => Setting('a-home'));

/// Newest first, at most 5.
final recentSearchesProvider = NotifierProvider<Setting<List<String>>, List<String>>(() => Setting(const []));

final searchFiltersProvider = NotifierProvider<Setting<SearchFilters>, SearchFilters>(
  () => Setting(const SearchFilters()),
);

enum SearchSort { closest, rating, price, prepTime }

class SearchFilters {
  const SearchFilters({
    this.service,
    this.category,
    this.sort = SearchSort.closest,
    this.wilaya,
    this.availableNow = false,
    this.madeToOrder = false,
    this.minRating = 0,
    this.price,
  });

  /// Set from the home screen's service tiles and category chips.
  final Service? service;
  final Category? category;
  final SearchSort sort;
  final String? wilaya;
  final bool availableNow, madeToOrder;
  final double minRating;
  final RangeValues? price;

  /// Filters set in the sheet (sort aside), for the badge on the filter button.
  int get sheetCount =>
      [wilaya != null, availableNow, madeToOrder, minRating > 0, price != null].where((on) => on).length;

  SearchFilters copyWith({
    ValueGetter<Service?>? service,
    ValueGetter<Category?>? category,
    SearchSort? sort,
    ValueGetter<String?>? wilaya,
    bool? availableNow,
    bool? madeToOrder,
    double? minRating,
    ValueGetter<RangeValues?>? price,
  }) =>
      SearchFilters(
        service: service != null ? service() : this.service,
        category: category != null ? category() : this.category,
        sort: sort ?? this.sort,
        wilaya: wilaya != null ? wilaya() : this.wilaya,
        availableNow: availableNow ?? this.availableNow,
        madeToOrder: madeToOrder ?? this.madeToOrder,
        minRating: minRating ?? this.minRating,
        price: price != null ? price() : this.price,
      );
}

/// Lower case without French accents, so "gateau" finds "Gâteau".
String fold(String s) {
  const from = 'àâäáçéèêëîïíôöóùûüú', to = 'aaaaceeeeiiiooouuuu';
  final lower = s.toLowerCase();
  final out = StringBuffer();
  for (final ch in lower.split('')) {
    final i = from.indexOf(ch);
    out.write(i < 0 ? ch : to[i]);
  }
  return out.toString();
}

bool _matches(String query, Iterable<String> fields) {
  final q = fold(query.trim());
  return q.isEmpty || fields.any((f) => fold(f).contains(q));
}

/// Listed products matching [query] and [f], sorted by `f.sort` (CLT-04/05).
/// [categoryName] lets the query match category labels in the app language.
List<Product> searchProducts(
  AppState s,
  DateTime now,
  String query,
  SearchFilters f,
  String Function(Category) categoryName,
) {
  double? stars(Product p) => s.rating(storeId: p.storeId)?.stars;
  Duration wait(Product p) => p.canOrderNow ? p.readyMade!.prepTime : (p.madeToOrder?.leadTime ?? Duration.zero);

  final out = s.listedProducts(now).where((p) {
    final store = s.store(p.storeId);
    return _matches(query, [p.title, p.description, store.name, categoryName(p.category)]) &&
        (f.service == null || p.category.service == f.service) &&
        (f.category == null || p.category == f.category) &&
        (f.wilaya == null || store.wilaya == f.wilaya) &&
        (!f.availableNow || p.canOrderNow) &&
        (!f.madeToOrder || p.madeToOrder != null) &&
        (f.minRating == 0 || (stars(p) ?? 0) >= f.minRating) &&
        (f.price == null || (p.displayPrice >= f.price!.start && p.displayPrice <= f.price!.end));
  }).toList();

  int byDistance(Product a, Product b) => s.store(a.storeId).distanceKm.compareTo(s.store(b.storeId).distanceKm);
  out.sort(switch (f.sort) {
    SearchSort.closest => byDistance,
    SearchSort.rating => (a, b) => (stars(b) ?? 0).compareTo(stars(a) ?? 0),
    SearchSort.price => (a, b) => a.displayPrice.compareTo(b.displayPrice),
    SearchSort.prepTime => (a, b) => wait(a).compareTo(wait(b)),
  });
  return out;
}

/// Approved stores matching [query] and [f]. Price and preparation sorts fall back to closest.
List<Store> searchStores(AppState s, DateTime now, String query, SearchFilters f) {
  final listed = s.listedProducts(now);
  double stars(Store st) => s.rating(storeId: st.id)?.stars ?? 0;
  bool sells(Store st, bool Function(Product) test) => listed.any((p) => p.storeId == st.id && test(p));

  return s.listedStores.where((st) {
    return _matches(query, [st.name, st.commune, st.wilaya, st.description]) &&
        (f.service == null || sells(st, (p) => p.category.service == f.service)) &&
        (f.category == null || sells(st, (p) => p.category == f.category)) &&
        (f.wilaya == null || st.wilaya == f.wilaya) &&
        (!f.availableNow || s.takingOrders(st, now)) &&
        (f.minRating == 0 || stars(st) >= f.minRating);
  }).toList()
    ..sort(f.sort == SearchSort.rating
        ? (a, b) => stars(b).compareTo(stars(a))
        : (a, b) => a.distanceKm.compareTo(b.distanceKm));
}
