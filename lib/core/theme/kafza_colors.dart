import 'package:flutter/painting.dart';

/// The only file in lib/ allowed to hold colour values (DESIGN.md).
/// Widgets read colours via `Theme.of(context).colorScheme` or `context.kafza`.
/// Values come from Yassir's public design tokens (yassir.com: brand, grey, positive,
/// warning, negative scales); semantic text colours use the darker steps that pass 4.5:1.
abstract final class KafzaColors {
  static const primary = Color(0xFF6316DB); // brand-600
  static const primaryDark = Color(0xFF4C0FAD); // brand-700
  static const primaryLight = Color(0xFFF1F1FE); // brand-50: tiles, selected, info
  static const primaryTint = Color(0xFFE4E2FD); // brand-100: nav indicator, pressed tiles
  static const ink = Color(0xFF1A0244); // brand-900 / grey-950: text, Yassir Pay card
  static const textSecondary = Color(0xFF6B648C); // grey-700
  static const onInkSecondary = Color(0xFFCAC4FB); // brand-200: captions on the ink card
  static const background = Color(0xFFFFFFFF);
  static const muted = Color(0xFFF7F3F8); // grey-50
  static const border = Color(0xFFEDEAF1); // grey-100: dividers, cards
  static const outline = Color(0xFFD9D5E2); // grey-200: inputs, chips, outline buttons
  static const accent = Color(0xFFFB2576); // brand-accent-600: graphics only, never text
  static const shadow = Color(0x141A0244); // ink at 8%
  static const success = Color(0xFF249F58);
  static const successLight = Color(0xFFEAFCE6); // positive-100
  static const warning = Color(0xFF995C00);
  static const warningLight = Color(0xFFFEF7DC); // warning-100
  static const error = Color(0xFFBE352F); // negative-700
  static const errorLight = Color(0xFFFEF2EF); // negative-50

  /// Product colour choices (OptionChoice.swatch indexes this list): bordeaux, black, emerald,
  /// night blue, ivory, gold.
  static const swatches = [
    Color(0xFF7A1F2B),
    Color(0xFF1F1E1B),
    Color(0xFF0F7A55),
    Color(0xFF1B2A57),
    Color(0xFFF4EEDC),
    Color(0xFFC9A227),
  ];
}
