import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/contact_check.dart';
import '../../../core/format/price.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/l10n/labels.dart';
import '../../../core/models/store.dart';
import '../../../core/order_engine/order_engine.dart';
import '../../../core/theme/kafza_theme.dart';
import '../../../core/widgets/initial_image.dart';
import '../../../core/widgets/kafza_sheet.dart';
import '../../../core/widgets/kafza_text_field.dart';
import '../store_providers.dart';
import '../store_widgets.dart';

/// Wilayas and communes the prototype offers (place names stay as written).
const _communes = {
  'Alger': ['Alger Centre', 'Bab Ezzouar', 'Ben Aknoun', 'Chéraga', 'El Biar', 'Hydra', 'Kouba'],
  'Blida': ['Blida', 'Boufarik', 'Ouled Yaïch'],
  'Oran': ['Oran', 'Bir El Djir', 'Es Sénia'],
  'Tizi Ouzou': ['Tizi Ouzou', 'Azazga', 'Draâ Ben Khedda'],
};

/// S11: store profile and settings (STR-08…11, STR-26).
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late final Store _initial = ref.read(currentStoreProvider)!;
  late String _name = _initial.name, _description = _initial.description, _ccp = _initial.ccp;
  late String _wilaya = _communes.containsKey(_initial.wilaya) ? _initial.wilaya : _communes.keys.first;
  late String _commune =
      _communes[_wilaya]!.contains(_initial.commune) ? _initial.commune : _communes[_wilaya]!.first;
  late (double, double) _pickup = _initial.pickup;
  late StorePicture _picture = _initial.picture;

  bool get _ccpValid => _ccp.isEmpty || (_ccp.length >= 10 && _ccp.length <= 20);

  bool get _valid =>
      _name.trim().isNotEmpty && contactCheck(_name) == null && contactCheck(_description) == null && _ccpValid;

  void _save() {
    final l10n = AppLocalizations.of(context);
    try {
      ref.read(orderEngineProvider.notifier).updateProfile(
            _initial.id,
            name: _name,
            description: _description,
            commune: _commune,
            wilaya: _wilaya,
            ccp: _ccp,
            pickup: _pickup,
            picture: _picture,
          );
      snack(context, l10n.profileSaved);
      Navigator.pop(context);
    } on OrderException catch (e) {
      snack(context, l10n.orderError(e.error));
    }
  }

  Future<void> _setPaused(bool paused) async {
    final l10n = AppLocalizations.of(context);
    if (paused) {
      final ok = await showKafzaDialog(
        context,
        title: l10n.pauseTitle,
        body: l10n.pauseBody,
        cancel: l10n.cancel,
        confirm: l10n.pauseConfirm,
      );
      if (!ok) return;
    }
    ref.read(orderEngineProvider.notifier).setStorePaused(_initial.id, paused);
    if (mounted) snack(context, paused ? l10n.storePaused : l10n.storeResumed);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final paused = ref.watch(currentStoreProvider.select((s) => s?.paused ?? false));

    Widget heading(String title) => Padding(
          padding: const EdgeInsetsDirectional.only(top: KafzaSpacing.xl, bottom: KafzaSpacing.md),
          child: Text(title, style: text.titleMedium),
        );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.storeProfile)),
      body: ListView(
        padding: const EdgeInsets.all(KafzaSpacing.lg),
        children: [
          Row(
            spacing: KafzaSpacing.lg,
            children: [
              SizedBox.square(
                dimension: 72,
                child: StoreAvatar(_initial.copyWith(name: _name, picture: _picture)),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: KafzaSpacing.xs,
                  children: [
                    Text(l10n.storePicture, style: text.labelLarge),
                    Wrap(
                      spacing: KafzaSpacing.sm,
                      runSpacing: KafzaSpacing.xs,
                      children: [
                        for (final (p, label) in [
                          (StorePicture.photo, l10n.picturePhoto),
                          (StorePicture.logo, l10n.pictureLogo),
                          (StorePicture.none, l10n.pictureNone),
                        ])
                          ChoiceChip(
                            showCheckmark: false,
                            label: Text(label),
                            selected: _picture == p,
                            onSelected: (_) => setState(() => _picture = p),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: KafzaSpacing.xl),
          KafzaTextField(
            label: l10n.storeName,
            value: _name,
            maxLength: 40,
            // Save is disabled without a name; say why.
            error: _name.trim().isEmpty ? l10n.nameRequired : null,
            onChanged: (v) => setState(() => _name = v),
          ),
          const SizedBox(height: KafzaSpacing.sm),
          KafzaTextField(
            label: l10n.storeDescription,
            helper: l10n.storeDescriptionHelper,
            value: _description,
            maxLength: 300,
            maxLines: 4,
            onChanged: (v) => setState(() => _description = v),
          ),

          heading(l10n.storeLocation),
          DropdownButtonFormField<String>(
            initialValue: _wilaya,
            style: text.bodyLarge,
            decoration: InputDecoration(labelText: l10n.wilaya),
            items: [for (final w in _communes.keys) DropdownMenuItem(value: w, child: Text(isolate(w)))],
            onChanged: (w) => setState(() {
              _wilaya = w!;
              _commune = _communes[w]!.first;
            }),
          ),
          const SizedBox(height: KafzaSpacing.lg),
          DropdownButtonFormField<String>(
            key: ValueKey(_wilaya),
            initialValue: _commune,
            style: text.bodyLarge,
            decoration: InputDecoration(labelText: l10n.commune, helperText: l10n.communeHelper, helperMaxLines: 2),
            items: [for (final c in _communes[_wilaya]!) DropdownMenuItem(value: c, child: Text(isolate(c)))],
            onChanged: (c) => setState(() => _commune = c!),
          ),

          heading(l10n.pickupTitle),
          Text(l10n.pickupBody, style: text.bodyMedium),
          const SizedBox(height: KafzaSpacing.md),
          _PickupMap(pin: _pickup, onChanged: (p) => setState(() => _pickup = p)),
          const SizedBox(height: KafzaSpacing.sm),
          Row(
            spacing: KafzaSpacing.sm,
            children: [
              Icon(IconsaxPlusLinear.lock, size: 18, color: scheme.onSurfaceVariant),
              Expanded(child: Text(l10n.neverShownToClients, style: text.bodySmall!.copyWith(color: scheme.onSurfaceVariant))),
            ],
          ),

          heading(l10n.payoutTitle),
          NumberField(
            label: l10n.ccpLabel,
            value: _ccp,
            maxLength: 20,
            helper: l10n.ccpHelper,
            error: _ccpValid ? null : l10n.ccpInvalid,
            onChanged: (v) => setState(() => _ccp = v),
          ),

          const SizedBox(height: KafzaSpacing.xl),
          const Divider(),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.pauseStore),
            subtitle: Text(l10n.pauseStoreHint),
            value: paused,
            onChanged: _setPaused,
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(
        children: [FilledButton(onPressed: _valid ? _save : null, child: Text(l10n.save))],
      ),
    );
  }
}

/// Static mock map with a draggable pin. Tap or drag to move it. The pin is stored as
/// fractions of the map, so the map stays unmirrored in Arabic, like a real one.
class _PickupMap extends StatelessWidget {
  const _PickupMap({required this.pin, required this.onChanged});

  final (double, double) pin;
  final ValueChanged<(double, double)> onChanged;

  static const _height = 200.0, _pinSize = 40.0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      label: AppLocalizations.of(context).pickupMapSemantics,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(KafzaRadius.card),
        child: SizedBox(
          height: _height,
          child: LayoutBuilder(
            builder: (context, box) {
              void move(Offset p) =>
                  onChanged(((p.dx / box.maxWidth).clamp(0.05, 0.95), (p.dy / _height).clamp(0.15, 0.95)));
              return Directionality(
                textDirection: TextDirection.ltr,
                child: GestureDetector(
                  onTapDown: (d) => move(d.localPosition),
                  onPanUpdate: (d) => move(d.localPosition),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _MapPainter(
                            ground: context.kafza.muted,
                            block: scheme.surface,
                            road: scheme.outline,
                          ),
                        ),
                      ),
                      PositionedDirectional(
                        start: pin.$1 * box.maxWidth - _pinSize / 2,
                        top: pin.$2 * _height - _pinSize,
                        child: Icon(IconsaxPlusBold.location, size: _pinSize, color: scheme.primary),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// A few city blocks and roads: enough to read as a map, nothing that claims a real place.
class _MapPainter extends CustomPainter {
  const _MapPainter({required this.ground, required this.block, required this.road});

  final Color ground, block, road;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = ground);
    final blocks = Paint()..color = block;
    const cols = 5, rows = 3, gap = 14.0;
    final w = (size.width - gap * (cols + 1)) / cols, h = (size.height - gap * (rows + 1)) / rows;
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        final rect = Rect.fromLTWH(gap + c * (w + gap), gap + r * (h + gap), w, h);
        canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)), blocks);
      }
    }
    final roads = Paint()
      ..color = road
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(0, size.height * 0.8), Offset(size.width, size.height * 0.35), roads);
  }

  @override
  bool shouldRepaint(_MapPainter old) => old.ground != ground || old.block != block || old.road != road;
}
