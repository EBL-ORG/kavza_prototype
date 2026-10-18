import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'kafza_colors.dart';

/// 4-pt spacing scale (DESIGN.md › Layout).
abstract final class KafzaSpacing {
  static const double xs = 4, sm = 8, md = 12, lg = 16, xl = 24, xxl = 32;
}

extension AboveGestureBar on EdgeInsets {
  /// Adds the system gesture-bar inset below. For a scroll view's padding on a screen with no
  /// bottom bar: Android draws edge-to-edge, so the last line would sit under the gesture bar.
  EdgeInsets aboveGestureBar(BuildContext context) =>
      copyWith(bottom: bottom + MediaQuery.paddingOf(context).bottom);
}

/// Corner radii (DESIGN.md › Shapes). Buttons and chips are pills (StadiumBorder).
abstract final class KafzaRadius {
  static const double input = 12, card = 16, dialog = 20, sheet = 24;
}

/// Iconsax glyphs that must mirror in Arabic. Material's chevron and undo did; Iconsax's don't, so these copy their code
/// points from IconsaxPlusLinear (arrow_right_3, undo) with matchTextDirection.
abstract final class KafzaIcons {
  static const chevronEnd = IconData(
    0xe936,
    fontFamily: 'IconsaxPlusLinear',
    fontPackage: 'iconsax_plus',
    matchTextDirection: true,
  );
  static const chevronStart = IconData(
    0xe932,
    fontFamily: 'IconsaxPlusLinear',
    fontPackage: 'iconsax_plus',
    matchTextDirection: true,
  );
  static const undo = IconData(
    0xec47,
    fontFamily: 'IconsaxPlusLinear',
    fontPackage: 'iconsax_plus',
    matchTextDirection: true,
  );
}

/// Colours Material's ColorScheme has no slot for.
class KafzaTokens extends ThemeExtension<KafzaTokens> {
  const KafzaTokens({
    required this.muted,
    required this.primaryTint,
    required this.ink,
    required this.onInkSecondary,
    required this.accent,
    required this.success,
    required this.successLight,
    required this.warning,
    required this.warningLight,
    required this.swatches,
  });

  final Color muted,
      primaryTint,
      ink,
      onInkSecondary,
      accent,
      success,
      successLight,
      warning,
      warningLight;

  /// Product colour choices (`OptionChoice.swatch` indexes this list).
  final List<Color> swatches;

  // ponytail: one light theme, tokens never change between themes, so copy/lerp are identity.
  @override
  KafzaTokens copyWith() => this;

  @override
  KafzaTokens lerp(KafzaTokens? other, double t) => this;
}

extension KafzaContext on BuildContext {
  KafzaTokens get kafza => Theme.of(this).extension<KafzaTokens>()!;
}

const _scheme = ColorScheme(
  brightness: Brightness.light,
  primary: KafzaColors.primary,
  onPrimary: KafzaColors.background,
  primaryContainer: KafzaColors.primaryLight,
  onPrimaryContainer: KafzaColors.primaryDark,
  secondary: KafzaColors.primary,
  onSecondary: KafzaColors.background,
  secondaryContainer: KafzaColors.primaryTint,
  onSecondaryContainer: KafzaColors.primaryDark,
  surface: KafzaColors.background,
  onSurface: KafzaColors.ink,
  onSurfaceVariant: KafzaColors.textSecondary,
  surfaceContainerLowest: KafzaColors.background,
  surfaceContainerLow: KafzaColors.background,
  surfaceContainer: KafzaColors.background,
  surfaceContainerHigh: KafzaColors.background,
  surfaceContainerHighest: KafzaColors.muted,
  surfaceTint: KafzaColors.background,
  outline: KafzaColors.outline,
  outlineVariant: KafzaColors.border,
  shadow: KafzaColors.shadow,
  error: KafzaColors.error,
  onError: KafzaColors.background,
  errorContainer: KafzaColors.errorLight,
  onErrorContainer: KafzaColors.error,
  inverseSurface: KafzaColors.ink,
  onInverseSurface: KafzaColors.background,
  inversePrimary: KafzaColors.onInkSecondary,
);

/// The app's only ThemeData. Yassir sets Gellix (Latin) and TheSansArab (Arabic), both
/// licensed; their closest free faces stand in: Plus Jakarta Sans (fr), IBM Plex Sans
/// Arabic (ar). Swapping in the real fonts changes only the two lines below.
ThemeData buildKafzaTheme(Locale locale) {
  final arabic = locale.languageCode == 'ar';
  final font = arabic
      ? GoogleFonts.ibmPlexSansArabicTextTheme
      : GoogleFonts.plusJakartaSansTextTheme;
  // Yassir's headings are heavy and set tight. Arabic keeps zero tracking (DESIGN.md).
  TextStyle style(
    double size,
    double lineHeight,
    FontWeight weight, [
    double tracking = 0,
  ]) => TextStyle(
    fontSize: size,
    height: lineHeight / size,
    fontWeight: weight,
    letterSpacing: arabic ? 0 : tracking,
  );
  final text =
      font(
        TextTheme(
          headlineMedium: style(28, 36, FontWeight.w800, -0.6),
          titleLarge: style(22, 28, FontWeight.w800, -0.4),
          titleMedium: style(18, 24, FontWeight.w700, -0.2),
          bodyLarge: style(16, 24, FontWeight.w500),
          bodyMedium: style(14, 20, FontWeight.w400),
          labelLarge: style(14, 20, FontWeight.w700),
          bodySmall: style(12, 16, FontWeight.w500),
          labelSmall: style(12, 16, FontWeight.w600),
        ),
      ).apply(
        bodyColor: KafzaColors.ink,
        displayColor: KafzaColors.ink,
        // Arabic user content (reviews, names) inside the French UI keeps the Arabic face.
        fontFamilyFallback: arabic
            ? null
            : [GoogleFonts.ibmPlexSansArabic().fontFamily!],
      );

  OutlineInputBorder inputBorder(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(KafzaRadius.input),
        borderSide: BorderSide(color: color, width: width),
      );
  const pill = StadiumBorder();
  bool isSelected(Set<WidgetState> s) => s.contains(WidgetState.selected);
  WidgetStateProperty<T> selected<T>(T on, T off) =>
      WidgetStateProperty.resolveWith((s) => isSelected(s) ? on : off);

  return ThemeData(
    useMaterial3: true,
    colorScheme: _scheme,
    textTheme: text,
    scaffoldBackgroundColor: KafzaColors.background,
    // Phone UI even when the demo runs in a desktop browser.
    visualDensity: VisualDensity.standard,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    extensions: const [
      KafzaTokens(
        muted: KafzaColors.muted,
        primaryTint: KafzaColors.primaryTint,
        ink: KafzaColors.ink,
        onInkSecondary: KafzaColors.onInkSecondary,
        accent: KafzaColors.accent,
        success: KafzaColors.success,
        successLight: KafzaColors.successLight,
        warning: KafzaColors.warning,
        warningLight: KafzaColors.warningLight,
        swatches: KafzaColors.swatches,
      ),
    ],
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: KafzaColors.primary,
      selectionColor: KafzaColors.primaryTint,
      selectionHandleColor: KafzaColors.primary,
    ),
    // Yassir's mini-app headers: white, centred bold title.
    appBarTheme: AppBarTheme(
      backgroundColor: KafzaColors.background,
      foregroundColor: KafzaColors.ink,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: text.titleMedium,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, 52),
        shape: pill,
        textStyle: text.labelLarge,
        disabledBackgroundColor: KafzaColors.muted,
        disabledForegroundColor: KafzaColors.textSecondary,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(64, 48),
        shape: pill,
        textStyle: text.labelLarge,
        foregroundColor: KafzaColors.primary,
        side: const BorderSide(color: KafzaColors.outline),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(48, 48),
        shape: pill,
        textStyle: text.labelLarge,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: KafzaColors.primary,
      foregroundColor: KafzaColors.background,
      shape: pill,
      extendedTextStyle: text.labelLarge,
    ),
    // Yassir fields: soft grey fill, no visible edge until focus.
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: KafzaColors.muted,
      contentPadding: const EdgeInsetsDirectional.symmetric(
        horizontal: KafzaSpacing.lg,
        vertical: 14, // 52 px field with bodyLarge
      ),
      border: inputBorder(KafzaColors.muted),
      enabledBorder: inputBorder(KafzaColors.muted),
      focusedBorder: inputBorder(KafzaColors.primary, 1.5),
      errorBorder: inputBorder(KafzaColors.error),
      focusedErrorBorder: inputBorder(KafzaColors.error, 1.5),
    ),
    // Yassir filter chips: white outlined pills; selected = lavender with a purple edge.
    chipTheme: ChipThemeData(
      shape: pill,
      color: selected(KafzaColors.primaryLight, KafzaColors.background),
      side: WidgetStateBorderSide.resolveWith(
        (s) => BorderSide(
          color: isSelected(s) ? KafzaColors.primary : KafzaColors.outline,
        ),
      ),
      labelStyle: text.labelLarge!.copyWith(
        color: WidgetStateColor.resolveWith(
          (s) => isSelected(s) ? KafzaColors.primary : KafzaColors.ink,
        ),
      ),
      iconTheme: const IconThemeData(color: KafzaColors.primary, size: 18),
      checkmarkColor: KafzaColors.primary,
    ),
    cardTheme: CardThemeData(
      color: KafzaColors.background,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(KafzaRadius.card),
        side: const BorderSide(color: KafzaColors.border),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: KafzaColors.border,
      thickness: 1,
      space: 1,
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: KafzaColors.primary,
      unselectedLabelColor: KafzaColors.textSecondary,
      labelStyle: text.labelLarge,
      unselectedLabelStyle: text.labelLarge,
      indicatorSize: TabBarIndicatorSize.label,
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(color: KafzaColors.primary, width: 3),
        borderRadius: BorderRadius.vertical(top: Radius.circular(3)),
      ),
      dividerColor: KafzaColors.border,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      linearTrackColor: KafzaColors.primaryTint,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: KafzaColors.background,
      showDragHandle: true,
      dragHandleColor: KafzaColors.outline,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(KafzaRadius.sheet),
        ),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: KafzaColors.background,
      titleTextStyle: text.titleLarge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(KafzaRadius.dialog),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: KafzaColors.background,
      indicatorColor: KafzaColors.primaryTint,
      labelTextStyle: selected(
        text.labelSmall!.copyWith(
          color: KafzaColors.primary,
          fontWeight: FontWeight.w700,
        ),
        text.labelSmall!.copyWith(color: KafzaColors.textSecondary),
      ),
      iconTheme: selected(
        const IconThemeData(color: KafzaColors.primary),
        const IconThemeData(color: KafzaColors.textSecondary),
      ),
    ),
    // Material's unselected switch uses `outline`, too faint as a track edge.
    switchTheme: SwitchThemeData(
      thumbColor: selected(KafzaColors.background, KafzaColors.textSecondary),
      trackColor: selected(KafzaColors.primary, KafzaColors.muted),
      trackOutlineColor: selected(
        KafzaColors.primary,
        KafzaColors.textSecondary,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: KafzaColors.ink,
      contentTextStyle: text.bodyMedium!.copyWith(
        color: KafzaColors.background,
      ),
      actionTextColor: KafzaColors.onInkSecondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(KafzaRadius.input),
      ),
    ),
  );
}
