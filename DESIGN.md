---
name: Kafza by Yassir
description: Homemade-products marketplace inside the Yassir super-app. Yassir design system, Material 3.
colors:
  primary: "#6316DB"
  primary-dark: "#4C0FAD"
  primary-light: "#F1F1FE"
  primary-tint: "#E4E2FD"
  ink: "#1A0244"
  text-secondary: "#6B648C"
  on-ink-secondary: "#CAC4FB"
  background: "#FFFFFF"
  muted: "#F7F3F8"
  border: "#EDEAF1"
  outline: "#D9D5E2"
  accent: "#FB2576"
  success: "#249F58"
  success-light: "#EAFCE6"
  warning: "#995C00"
  warning-light: "#FEF7DC"
  error: "#BE352F"
  error-light: "#FEF2EF"
typography:
  headline:
    fontFamily: "IBM Plex Sans Arabic (ar), Plus Jakarta Sans (fr)"
    fontSize: "28px"
    fontWeight: 800
    lineHeight: 1.29
  title-large:
    fontFamily: "IBM Plex Sans Arabic (ar), Plus Jakarta Sans (fr)"
    fontSize: "22px"
    fontWeight: 800
    lineHeight: 1.27
  title-medium:
    fontFamily: "IBM Plex Sans Arabic (ar), Plus Jakarta Sans (fr)"
    fontSize: "18px"
    fontWeight: 700
    lineHeight: 1.33
  body-large:
    fontFamily: "IBM Plex Sans Arabic (ar), Plus Jakarta Sans (fr)"
    fontSize: "16px"
    fontWeight: 400
    lineHeight: 1.5
  body-medium:
    fontFamily: "IBM Plex Sans Arabic (ar), Plus Jakarta Sans (fr)"
    fontSize: "14px"
    fontWeight: 400
    lineHeight: 1.43
  label-large:
    fontFamily: "IBM Plex Sans Arabic (ar), Plus Jakarta Sans (fr)"
    fontSize: "14px"
    fontWeight: 600
    lineHeight: 1.43
  body-small:
    fontFamily: "IBM Plex Sans Arabic (ar), Plus Jakarta Sans (fr)"
    fontSize: "12px"
    fontWeight: 400
    lineHeight: 1.33
rounded:
  input: "12px"
  button: "999px"
  card: "16px"
  dialog: "20px"
  sheet-top: "24px"
  chip: "999px"
spacing:
  xs: "4px"
  sm: "8px"
  md: "12px"
  lg: "16px"
  xl: "24px"
  xxl: "32px"
components:
  button-primary:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.background}"
    typography: "{typography.label-large}"
    rounded: "{rounded.button}"
    height: "52px"
  button-outline:
    backgroundColor: "{colors.background}"
    textColor: "{colors.primary}"
    rounded: "{rounded.button}"
    height: "48px"
  button-destructive:
    backgroundColor: "{colors.background}"
    textColor: "{colors.error}"
    rounded: "{rounded.button}"
    height: "48px"
  card:
    backgroundColor: "{colors.background}"
    rounded: "{rounded.card}"
    padding: "16px"
  input:
    backgroundColor: "{colors.muted}"
    textColor: "{colors.ink}"
    rounded: "{rounded.input}"
    height: "52px"
  chip-status-active:
    backgroundColor: "{colors.primary-light}"
    textColor: "{colors.primary}"
    rounded: "{rounded.chip}"
  wallet-card:
    backgroundColor: "{colors.ink}"
    textColor: "{colors.background}"
    rounded: "{rounded.card}"
    padding: "16px"
  service-tile:
    backgroundColor: "{colors.primary-light}"
    rounded: "{rounded.card}"
  chip-status-terminal:
    backgroundColor: "{colors.muted}"
    textColor: "{colors.text-secondary}"
    rounded: "{rounded.chip}"
---

# Design System: Kafza by Yassir

## Overview

Kafza lives inside Yassir and must feel like Yassir: white surfaces, one confident purple, ink-purple text, cool lavender greys, pill buttons, heavy geometric headings, lavender service tiles and the dark Yassir Pay wallet card. Kafza adds no colour of its own; its one mark is the logo (see Logo). The interface is an **Operate** surface (people complete tasks: browse, order, accept, prepare), so scanability, consistency and Material 3 conventions outrank expression. Brand lives in precise details: the purple on the one action that matters, honest money lines, clean status chips.

Built in Flutter, Material 3, Android-first. Light theme only (dark mode out of scope). Arabic is the default locale (RTL); French is the second. Colour tokens come from Yassir's public design tokens (yassir.com CSS: `brand`, `grey`, `positive`, `warning`, `negative` scales); semantic text colours use the darker steps that pass 4.5:1. Layouts follow the Yassir super-app screens on its store listing. Yassir's fonts (Gellix, TheSansArab) are licensed, so free stand-ins are used until the files are supplied; they change in `lib/core/theme/` and nowhere else.

## Colors

All colours live in **one file**: `lib/core/theme/kafza_colors.dart`. No `Colors.xxx`, `Color(0x…)` or hex anywhere else in `lib/`. Widgets read colours from `Theme.of(context).colorScheme` or the `KafzaTokens` `ThemeExtension` (`context.kafza.muted` etc.).

### Primary
- **primary `#6316DB`** (Yassir purple, `brand-600`): the single primary CTA per screen ("Order now", "Place order", "Accept"), active tabs, links, the Kafza tile, the launcher and side-by-side backdrop.
- **primary-dark `#4C0FAD`**: pressed states, text on primary-light.
- **primary-light `#F1F1FE`**: Yassir's lavender tiles (service tiles, image placeholders), selected chips, active status chips, info banners.
- **primary-tint `#E4E2FD`**: navigation indicator, text selection, secondary text on primary.
- **accent `#FB2576`** (Yassir pink): graphics only, never text. The location chevron, nothing else.

### Neutral
- **ink `#1A0244`**: all text, and the dark Yassir Pay wallet card. Never pure black.
- **text-secondary `#6B648C`**: captions, helper text, terminal-status chips (5.5:1 on white).
- **on-ink-secondary `#CAC4FB`**: captions on the ink card.
- **background `#FFFFFF`**: screens, cards, sheets.
- **muted `#F7F3F8`**: input fills, grouped backgrounds, disabled fills, terminal-status chips.
- **border `#EDEAF1`**: dividers, card edges, sticky-bar edges.
- **outline `#D9D5E2`**: chip and outline-button edges, stepper buttons, timeline track.

### Semantic
- **success `#249F58`** on **success-light `#EAFCE6`**: delivered, verified, withdrawal sent, the "New" badge.
- **warning `#995C00`** on **warning-light `#FEF7DC`**: low balance, low stock, countdown under 25%, strike warning, disputed.
- **error `#BE352F`** on **error-light `#FEF2EF`**: errors, payment failed, delivery failed, suspension, missing amount.
- Info uses primary / primary-light.

### Material mapping
`ColorScheme(brightness: light)`: primary → primary, onPrimary → background, primaryContainer → primary-light, onPrimaryContainer → primary-dark, surface → background, onSurface → ink, onSurfaceVariant → text-secondary, surfaceContainerHighest → muted, outline → outline, outlineVariant → border, inverseSurface → ink, error → error, errorContainer → error-light. Material has no slot for muted / primary-tint / ink / accent / success / warning (and their light tints), so they live in the `KafzaTokens` `ThemeExtension`.

### Named Rules
- **One purple action.** Exactly one filled primary button per screen. Everything else is outline, text or tonal.
- **Amounts are neutral.** Totals, balances and earnings use `ink` (white on the ink card) or `primary`, bold, tabular figures. A semantic colour on an amount means a problem (missing amount = error).
- **Success is never small text.** `#249F58` on white is about 3.4:1. Use it for icons, chip fills (success-light background, `ink` label with success icon) or bold text 18 px and up. warning (≈5.5:1) and error (≈5.6:1) are fine for body text, also on their light tints.
- **Pink is a glint.** The accent marks one thing per screen at most (the location chevron) and never carries text.
- **Colour is never alone.** Every status pairs colour with a label and, where useful, an icon.

## Typography

Yassir sets **Gellix** (Latin) and **TheSansArab** (Arabic), both licensed. Until the files are supplied, `google_fonts` serves the closest free faces: **Plus Jakarta Sans** (`fr`, geometric with heavy weights like Gellix) and **IBM Plex Sans Arabic** (`ar`, humanist like TheSansArab). The font switches with the locale, inside the one `ThemeData` builder.

### Hierarchy (mapped to Material 3 text roles; sizes in logical px, scale with system font size)
| Role | Material slot | Size / line / weight | Use |
|---|---|---|---|
| Headline | `headlineMedium` | 28 / 36 / 800, −0.6 (fr) | Welcome line, balances, order placed |
| Title L | `titleLarge` | 22 / 28 / 800, −0.4 (fr) | Screen titles, product title, home section headers |
| Title M | `titleMedium` | 18 / 24 / 700, −0.2 (fr) | App-bar titles, section headers, card titles |
| Body L | `bodyLarge` | 16 / 24 / 500 | Primary reading text, inputs |
| Body | `bodyMedium` | 14 / 20 / 400 | Default body |
| Label | `labelLarge` | 14 / 20 / 700 | Buttons, chips, tabs |
| Caption | `bodySmall` / `labelSmall` | 12 / 16 / 500–600 | Helper text, timestamps, meta |

### Named Rules
- **Roles, not sizes.** Widgets use `Theme.of(context).textTheme.*`. No `fontSize:` in feature code.
- **Tabular money.** Prices and countdowns use `FontFeature.tabularFigures()`.
- **Heavy and tight.** Headings are ExtraBold with slight negative tracking in French, like Yassir's Gellix headings.
- **Arabic rules.** No uppercase, no letter-spacing. If Arabic body text reads small, bump body sizes +1–2 px for `ar` in the theme, never per widget.
- **Prices:** formatted only through the core price formatter (`intl`): `2 400 DA` (fr), Arabic-locale format in ar. Numbers, prices and phone numbers stay LTR inside RTL text.

## Layout

- **4-pt grid.** Spacing only from tokens: 4, 8, 12, 16, 24, 32 (`KafzaSpacing`).
- **Screen padding 16**, card padding 16, section gap 24.
- **Directional everywhere:** `EdgeInsetsDirectional`, `AlignmentDirectional`, `PositionedDirectional`, `start`/`end`. Never `left`/`right` in feature code.
- **Phone frame:** 390×844 logical px in side-by-side mode. Layouts are designed for that width and must not overflow at 360 wide or text scale 1.3.
- **Sticky bottom bars** for the screen's primary action on long pages (product page, summary, editor steps), with safe-area padding.

## Elevation & Depth

Flat by default. Depth comes from fills, not shadows: white cards with a 1 px `border` edge, lavender tiles, the ink wallet card. Material elevation only for floating things: bottom sheets, snackbars (ink), the FAB. No custom drop shadows.

## Shapes

- Buttons, FABs and chips: **full pill** (StadiumBorder), as in Yassir.
- Inputs: radius **12**, muted fill, no visible edge until focus (1.5 px primary).
- Cards and tiles: radius **16**; images inside cards **12**; avatars and icon discs are circles.
- Round icon buttons: the client header's close is an outlined circle; the wallet card's actions are filled circles (white, purple).
- Dialogs: radius **20**. Bottom sheets: **24** top corners, with a drag handle.
- Badges: full pill.
- Touch targets: **48×48 minimum**, 8 px apart.

## Components

All shared widgets live in `lib/core/widgets/`. Build once, reuse everywhere. A feature never restyles a shared widget locally; it adds a variant in core instead.

### Buttons
- `KafzaButton.primary` (FilledButton, 52 px, full width in bottom bars), `.outline` (48 px), `.text`, `.destructive` (error-coloured outline).
- **Loading state blocks taps** (spinner replaces the label, width stays fixed). Every button that moves money (Place order, Accept, Withdraw, Recharge) uses it.
- Pill-shaped. Outline buttons use the `outline` edge and a primary label.
- Disabled = muted fill, text-secondary label. Disabled buttons explain why nearby (inline error or helper text).

### Chips
- **StatusChip**, one style per order status, from a single map in core:
  - Placed: primary-light / primary + countdown. Accepted: primary / white. In preparation, Ready, Picked up: primary-light / primary.
  - Delivered: success-light / text + success icon.
  - Cancelled by client, Declined, Expired, Payment failed, Cancelled after acceptance: muted / text-secondary.
  - Delivery failed, Disputed: warning-light / warning.
- Filter / choice chips: Material `FilterChip` / `ChoiceChip` themed by `ChipTheme`; white outlined pills (`outline` edge, ink label); selected = primary-light fill, primary edge and label.
- Badges (`KafzaBadge`): "New", "Pro", "Ready-made", "Made to order", "Only a few left".

### Logo
- The product is named **Kavza** in the UI (code identifiers keep `Kafza`). Files in `assets/logo/`: `word logo.png` (mascot + purple "KAVZA"), `word logo white.png` (mascot + white "KAVZA") and `kafza logo.png` (the mascot alone, unused).
- **Word logo on white only**, through `KafzaLogo` (core/widgets): 32 px tall in top bars (client mini-app header, store home, store pending), 64 px on the store welcome screen with a small "by Yassir" caption under it. Top bars show the logo alone.
- **On purple:** the white word logo (40 px on the Yassir home entry card).
- Never recolour, stretch or put the purple word logo on a purple or photo background.

### Cards / Containers
- White, 1 px border, radius 16, padding 16. Product, store, order and KPI cards share this base.
- Images: seed products, stores and the demo client show bundled photos (`assets/images/<id>_<n>.jpg`, credits in `assets/images/CREDITS.md`), cropped with `BoxFit.cover`. Anything without a photo falls back to its initial in primary on a primary-light tile, sized to 45% of the box, never a broken image icon.
- **Service tiles** (Yassir home, Kafza home): primary-light tile, a 52 px 3D emoji (Microsoft Fluent Emoji 3D, MIT, `assets/emoji/`), the label in Label under it. A store's "logo" picture is its activity's emoji on a primary-light disc.
- **BalanceCard** (Yassir Cash): Yassir Pay's dark card (ink fill, white Headline amount, on-ink-secondary caption, optional round actions). Turns error-light with "Missing X DZD" and a recharge button when the balance is short. The store's available balance on its home uses the same ink treatment.
- **PriceBreakdown**: lines item total · options · delivery fee (or "Free delivery") · total in bold.

### Inputs / Fields
- `KafzaTextField`: label, helper, error and counter below; prefix support ("+213", "DZD"). Errors appear in place, under the field, with the reason in plain words.
- Every free-text field runs `contactCheck` and shows the blocking reason as its error.
- Phone and OTP fields are forced LTR.
- `QuantityStepper`: − value +, honours min/max/step and decimals (kg). Mirrors in RTL.

### Navigation
- **Client:** centred bold AppBar "Kafza by Yassir" (Yassir mini-app header), outlined round ✕ (back to Yassir) on root tabs, ← on inner screens, bell and ? actions. `NavigationBar`: Home · Search · Orders · Favourites.
- **Mock Yassir home (C1):** location header (pink chevron) and avatar, ink wallet card, "Welcome, name" headline, the Kafza tile in primary, then the 2×2 lavender service grid.
- **Launcher and side-by-side:** phones on a primary backdrop, like Yassir's store listing; white FAB.
- **Single app, full screen (phone / narrow window):** Android system bars hidden (immersive sticky); an ink tab (72% opacity, end-rounded, 48×56) on the start edge at mid-height goes back to the launcher.
- **Store:** `NavigationBar`: Home · Orders (badge) · Products · Earnings · More. Onboarding is a linear stack with a step indicator (Phone → Code → Card → Selfie).
- System Back always works and matches the on-screen ✕/←.
- Transitions ≤ 300 ms, Material patterns (fade-through between tabs, shared-axis / slide-up into the mini-app). Respect reduced motion.
- Sheets via `showKafzaSheet` (scroll-controlled, drag handle). Dialogs via `showKafzaDialog`, only for decisions that must interrupt. Transient feedback = SnackBar.

### Order lifecycle widgets
- **StatusTimeline**: status history with times; current step in primary, done steps with check, future steps muted.
- **CountdownChip**: time left to accept; warning style under 25%.
- **Money line** on every order screen: "Still in your Yassir Cash" / "Paid — held by Kafza" / "Refunded to your Yassir Cash" / "Paid" / "Nothing was taken from your wallet" / "Under review by Kafza".

### States
Every data screen has: **skeleton** (`SkeletonBox`) while loading, **EmptyState** (icon, title, one line, optional action), and an **error block with Retry**.

## Do's and Don'ts

### Do:
- Read every colour, radius, spacing and text style from `lib/core/theme/`.
- Keep one primary button per screen, and say where the money is on every money screen.
- Use the spec's exact labels: "Order now", "Order made for me", "Place order", "Cancel", "Recharge with CCP", "Cancel it and place this one", "Keep it", "Accept", "Decline", "Ready".
- Put every string in the ARB files (ar, fr). Show user content (store names, products, reviews) as written.
- Icons are Iconsax (`iconsax_plus`): Linear by default, Bold for selected/filled states. Iconsax glyphs don't mirror, so directional ones come from `KafzaIcons` (matchTextDirection). Mirror icons, arrows, steppers and progress in RTL; keep numbers, prices and phones LTR.
- Add Semantics labels to icon-only buttons and inputs.

### Don't:
- No `Colors.xxx`, `Color(0x…)` or hex outside `kafza_colors.dart`. No `fontSize:` in feature code.
- No second filled button on a screen. No stacked FABs.
- No chat, messaging, phone numbers or free-text notes between client and store.
- Never show the client's name, phone or street to the store, or the store's address to the client.
- No custom shadows, gradients, glassmorphism or decorative illustration. The logo is the only Kafza-specific mark.
- No Cupertino controls; this is a Material 3 app.
- No transitions longer than 300 ms.
