# Kafza by Yassir: Flutter prototype

A clickable Flutter prototype of the **Kafza client mini-app** (inside a mock Yassir) and the **Kafza Store app**. Both apps share ONE in-memory state. It's for guided stakeholder demos. No backend, no Firebase, no back-office.

Source of truth, in this order:
1. `Kafza_Mobile_Prototype_Prompts.md`: screens, business rules, build prompts.
2. `PLAN.md`: execution plan and current phase. Tick its checkboxes as work lands.
3. `DESIGN.md`: visual rules and tokens. `PRODUCT.md`: product context.
4. `../Kafza_by_Yassir_Cahier_des_charges_v0.2.docx`: the spec (requirement IDs CLT-, STR-, PAY-…).

## Mandatory skills (rule)

- **Every coding task: invoke the `ponytail:ponytail` skill first** (level `full`). Laziest solution that works, no speculative abstractions, fewest files, reuse what's already in `lib/core/`. Ponytail never removes requested features, validation, accessibility basics or the order-engine tests.
- **Every UI task (a screen, widget, theme, copy, states, motion): also invoke the `impeccable` skill** before editing. Follow its setup (`impeccable context`), read `reference/craft-floor.md` before UI edits, and run `impeccable polish` / `impeccable audit` on a feature's screens before calling a phase done.
- If the two conflict: the brief and `DESIGN.md` win, then impeccable decides UI quality, then ponytail decides code size.

## Commands

```sh
flutter pub get
flutter gen-l10n                # after editing ARB files
flutter run -d chrome           # launcher; side-by-side works best here or on -d windows
flutter analyze                 # must be clean
flutter test                    # order engine + contactCheck + price tests
grep -rnE "\bColors\.|Color\(0x" lib/ | grep -v kafza_colors.dart   # must print nothing (\b skips KafzaColors.)
```

## Architecture: feature-first with a shared core

```
lib/
  main.dart                      ProviderScope + launcher MaterialApp
  core/                          shared by every feature. Features import core, never each other.
    theme/                       kafza_colors.dart (ONLY place for colours), kafza_theme.dart, tokens extension, spacing
    l10n/                        app_ar.arb (template, default), app_fr.arb, generated code, locale_provider.dart
    format/                      price formatter (intl), date/duration formatting
    models/                      immutable models with copyWith (one file per aggregate: order, product, store…)
    data/                        seed.dart, fake services (wallet, delivery), clock.dart, app_state providers
    order_engine/                order_engine.dart: the ONLY code that changes order status, stock, wallet, earnings, strikes
    contact_check.dart           contact-detail blocking for all free text
    widgets/                     shared UI kit: KafzaButton, KafzaTextField, QuantityStepper, StatusChip, PhoneFrame, MockCamera, ProductDetailView, showKafzaSheet/Dialog…
  features/
    launcher/                    launcher screen, side-by-side screen
    demo_panel/                  demo panel (clock, courier events, approve store, balance, reset)
    client/                      client app: client_app.dart (MaterialApp.router + GoRouter + shell)
      yassir_home/  home/  search/  store_page/  product/  ordering/  orders/  favourites/  help/
    store/                       store app: store_app.dart (MaterialApp.router + GoRouter + shell)
      onboarding/  home/  orders/  products/  product_editor/  earnings/  profile/  reviews/  strikes/  more/
test/
  order_engine_test.dart
```

Rules:
- **A feature folder is flat**: its screens, plus a `*_providers.dart` only if it has local state. No data/domain/presentation layers per feature.
- **Features never import other features.** Something needed by two features moves to `core/` (for example `ProductDetailView` is used by the client product page and the store editor preview, so it lives in `core/widgets/`).
- **Shared state lives in core** (Riverpod `Notifier`s, no code generation). Feature-local UI state stays in the feature.
- **Each app owns its router.** `ClientApp` and `StoreApp` each build their own `MaterialApp.router` + `GoRouter`, so in side-by-side mode both phones navigate independently inside the same `ProviderScope`.
- **The order engine is the only writer** of order status, stock, wallet, earnings and strikes. Screens call engine methods; they never mutate models. Every change adds a timestamped history entry and a notification for the right app.
- **Time comes from the simulated clock provider** (`now = real time + offset`), never `DateTime.now()` in features.
- Fake services use `Future.delayed` of 300–1200 ms.

## Design rules (summary; full rules in DESIGN.md)

- Colours only from `lib/core/theme/kafza_colors.dart`. No `Colors.xxx`, `Color(0x…)` or hex anywhere else. Read colours via `Theme.of(context).colorScheme` / `context.kafza`.
- Text styles only from `Theme.of(context).textTheme`. No `fontSize:` in features.
- Fonts: IBM Plex Sans Arabic (ar) / Plus Jakarta Sans (fr) via `google_fonts`, stand-ins for Yassir's licensed Gellix / TheSansArab.
- Pill buttons and chips, radius 12 inputs, 16 cards, 20 dialogs, 24 sheet tops. 4-pt spacing, 16 px screen padding, 52 px primary button, 48 px touch targets.
- **One primary button per screen.** Money-moving buttons use the loading state that blocks double taps.
- Material 3 only, light theme only, transitions ≤ 300 ms.
- Reuse `lib/core/widgets/` before writing a new widget.

## Languages

- **Arabic (default, RTL) and French only.** No English (user decision; overrides the brief's AR/FR/EN).
- Every UI string comes from ARB files (`app_ar.arb` is the template). No hard-coded strings in widgets.
- Use `EdgeInsetsDirectional` / `AlignmentDirectional`, `start`/`end`. Never `left`/`right`.
- Numbers, prices and phone numbers stay LTR. Prices go only through the core formatter.

## Business rules (must hold; details in the brief §2)

- Placing an order only **checks** the balance. Debit happens on store **Accept**: full debit → Accepted, or nothing → Payment failed (stock back, no strike). A debit never happens twice for the same order.
- One "Placed" order per client at a time. Client cancels only while Placed. Store cancels after acceptance only with a reason → full refund + strike; 3 strikes → 7-day suspension.
- Stock: reserved at placement, consumed at accept, returned on decline / expiry / client cancel / payment failed.
- Acceptance window: 2 h ready-made, 24 h made to order, then Expired (no strike).
- Earnings = item total − 10% − delivery fee (if free delivery), credited on delivery.
- Privacy: the store sees only the client's commune; the client sees only the store's commune + approx. distance.
- Contact details are blocked in every free-text field (`contactCheck`).

## Never

- Chat or messaging, cash on delivery, card payments, client sign-up, back-office screens.
- New packages beyond flutter_riverpod, go_router, intl, google_fonts, flutter_localizations, iconsax_plus unless truly necessary. Ask first.
- `DateTime.now()` in features, status changes outside the order engine, hard-coded colours or strings.
