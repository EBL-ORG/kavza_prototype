import 'package:flutter/material.dart';

import '../models/store.dart';
import '../theme/kafza_theme.dart';

/// Item picture: the bundled photo `assets/images/<id>_<page>.jpg` for seed items, otherwise the item's initial in purple on a
/// lavender tile (Yassir's tile look), so a product added in the demo never shows a broken image.
class InitialImage extends StatelessWidget {
  const InitialImage(
    this.name, {
    super.key,
    this.radius = KafzaRadius.input,
    this.id,
    this.page = 0,
  });

  final String name;
  final double radius;

  /// Product, store or client id whose photos are bundled; null shows the initial.
  final String? id;
  final int page;

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isEmpty
        ? ''
        : name.trim().characters.first.toUpperCase();
    final tile = ColoredBox(
      color: Theme.of(context).colorScheme.primaryContainer,
      // The initial grows with the box (45% of its height, up to 96 px), like an object on a tile.
      child: Center(
        child: FractionallySizedBox(
          heightFactor: 0.45,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 96),
            child: FittedBox(
              child: ExcludeSemantics(
                child: Text(
                  initial,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: (id ?? '').isEmpty
          ? tile
          : Image.asset(
              'assets/images/${id}_$page.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              excludeFromSemantics: true,
              errorBuilder: (_, _, _) => tile,
            ),
    );
  }
}

/// A store's round picture (STR-08): its photo, its logo (the 3D emoji of its activity), or its initial.
class StoreAvatar extends StatelessWidget {
  const StoreAvatar(this.store, {super.key});

  final Store store;

  @override
  Widget build(BuildContext context) => switch (store.picture) {
    StorePicture.photo => InitialImage(store.name, id: store.id, radius: 999),
    StorePicture.none => InitialImage(store.name, radius: 999),
    StorePicture.logo => DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: FractionallySizedBox(
        widthFactor: 0.7,
        heightFactor: 0.7,
        child: Image.asset(
          'assets/emoji/${store.activity?.name ?? 'kafza'}.png',
          excludeFromSemantics: true,
        ),
      ),
    ),
  };
}
