import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prototype/core/data/seed.dart';
import 'package:prototype/core/models/catalog.dart';
import 'package:prototype/features/client/client_providers.dart';

void main() {
  final now = DateTime(2026, 10, 12, 10);
  final s = seed(now);
  List<String> products(String q, [SearchFilters f = const SearchFilters()]) =>
      searchProducts(s, now, q, f, (c) => c.name).map((p) => p.id).toList();

  test('paused products and paused stores never appear', () {
    final all = products('');
    expect(all, isNot(contains('p-mkhabez'))); // product paused
    expect(all, isNot(contains('p-bracelet'))); // store paused
    expect(all, contains('p-chakhchoukha')); // unavailable but listed
  });

  test('query ignores case and French accents, and matches store names', () {
    expect(products('gateau'), contains('p-wedding'));
    expect(products('YEMMA'), containsAll(['p-couscous', 'p-msemen']));
  });

  test('filters narrow the results', () {
    expect(products('', const SearchFilters(category: Category.cakes)),
        unorderedEquals(['p-wedding', 'p-fraisier', 'p-tarte', 'p-cupcakes']));
    final ready = products('', const SearchFilters(availableNow: true));
    expect(ready, isNot(contains('p-msemen')));
    expect(ready, isNot(contains('p-chakhchoukha')));
    expect(products('', const SearchFilters(wilaya: 'Blida')),
        unorderedEquals(['p-couscous', 'p-msemen', 'p-rechta', 'p-kesra', 'p-chakhchoukha']));
    expect(products('', const SearchFilters(price: RangeValues(0, 500))),
        unorderedEquals(['p-msemen', 'p-kesra', 'p-msemen-zohra', 'p-kesra-zohra']));
  });

  test('sort changes the order', () {
    expect(products('', const SearchFilters(sort: SearchSort.price)).first, 'p-msemen');
    expect(products('', const SearchFilters(sort: SearchSort.closest)).take(2), unorderedEquals(['p-karakou', 'p-gandoura']));
    final closest = searchStores(s, now, '', const SearchFilters());
    expect(closest.first.id, 's-nour'); // 1.2 km
  });

  test('paused store is findable but drops out with "available now"', () {
    expect(searchStores(s, now, '', const SearchFilters()).map((x) => x.id), contains('s-thiziri'));
    expect(searchStores(s, now, '', const SearchFilters(availableNow: true)).map((x) => x.id), isNot(contains('s-thiziri')));
  });
}
