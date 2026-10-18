# Kafza prototype: execution plan

Built from `Kafza_Mobile_Prototype_Prompts.md` (prompts 1–7), adapted to this project:

| Brief says | This project does | Why |
|---|---|---|
| `flutter create kafza_prototype` | Keep the existing `prototype` project (Android + iOS); add web + windows | Already scaffolded; side-by-side needs Chrome/Windows |
| `lib/client`, `lib/store`, `lib/data`, `lib/ui` | Feature-first: `lib/core/` (shared) + `lib/features/<app>/<feature>/` (see CLAUDE.md) | User decision |
| AR / FR / EN | **AR (default) + FR only** | User decision |
| `lib/core/theme/kafza_colors.dart` | Same path | Unchanged |

Every phase: invoke `ponytail:ponytail` before coding. UI phases also invoke `impeccable` (context + craft-floor before edits, `polish` on the phase's screens at the end). A phase is done only when its acceptance boxes are ticked, `flutter analyze` is clean and `flutter test` passes.

---

## Phase 0: Project prep
- [x] `flutter create --platforms=web,windows .` (adds platforms, keeps lib/).
- [x] `flutter pub add flutter_riverpod go_router intl google_fonts` + `flutter_localizations` (sdk); `generate: true` in pubspec.
- [x] `l10n.yaml`: arb-dir `lib/core/l10n`, template `app_ar.arb`, output class `AppLocalizations`.
- [x] Create the empty folder skeleton from CLAUDE.md only as files land (no placeholder files).

## Phase 1: Theme, shared widgets, launcher (brief Prompt 1)
**core/theme**
- [x] `kafza_colors.dart`: all DESIGN.md colour tokens.
- [x] `kafza_theme.dart`: `buildKafzaTheme(Locale)` → Material 3 `ThemeData`: ColorScheme mapping from DESIGN.md, text theme 28/22/18/16/14/12 (Plex Arabic for ar, Inter for fr), FilledButton 52 px r12, OutlinedButton, InputDecorationTheme, ChipTheme, BottomSheetTheme r24, DialogTheme r20, NavigationBarTheme; `KafzaTokens` ThemeExtension (muted, success, warning + light tints) with a `context.kafza` getter; spacing constants.

**core/l10n + format**
- [x] `app_ar.arb`, `app_fr.arb`; `localeProvider` (default `ar`). RTL flips automatically from the locale.
- [x] Price formatter: `2 400 DA` (fr), Arabic-locale format (ar), always LTR. (`core/format/price.dart`, checked by `test/price_test.dart`)

**core/widgets**
- [x] KafzaButton (primary / outline / text / destructive, loading blocks taps), KafzaTextField (label, helper, error, counter, prefix), QuantityStepper (min/max/step, decimals), StatusChip, RatingStars (display + input), KafzaBadge, InfoBanner, EmptyState, SkeletonBox, PriceBreakdown, BalanceCard, CountdownChip, StatusTimeline, MockCamera (card rectangle / face oval, capture → placeholder, no gallery), PhoneFrame (390×844, status bar with simulated clock), `showKafzaSheet`, `showKafzaDialog`.
  - Done in Phase 1: **PhoneFrame** (the only one Phase 1 needs). The rest land with their first screen (rule below).
  - Done in Phase 3: **KafzaBadge**, **InfoBanner**, **EmptyState**, **SkeletonBox** (static, no shimmer), **RatingLabel / RatingStars** (display), **showKafzaSheet**, **ProductDetailView**.
  - Done in Phase 4: **KafzaButton** (filled / outline, loading blocks taps), **KafzaTextField** (contactCheck built in), **QuantityStepper**, **RatingInput**, `order_widgets.dart` (**StatusChip**, **CountdownChip**, **StatusTimeline**, **PriceBreakdown**). BalanceCard stays client-only (`ordering/summary_screen.dart`).
  - Done in Phase 6: **NoticeBanner** (moved from the client app to core).
  - Done in the Phase 5 polish: **showKafzaDialog** (in `kafza_sheet.dart`; all 7 dialogs use it). The whole target set now exists; BalanceCard stays client-only (above).
- [x] ponytail: build each widget when its first screen needs it if it isn't needed in Phase 1; the list is the target set, not a Phase 1 obligation.

**features/launcher**
- [x] Launcher: "Kafza by Yassir — Prototype", Client app / Store app / Side-by-side, AR/FR switch. Side-by-side hidden on narrow screens.
- [x] Side-by-side: two PhoneFrames in a Row, `ClientApp` and `StoreApp` each with its own `MaterialApp.router`, same `ProviderScope`.
- [x] Placeholder home in `features/client/client_app.dart` and `features/store/store_app.dart`.

Acceptance
- [x] `flutter run -d chrome` shows the launcher; all three options open.
- [x] Side-by-side phones navigate independently.
- [x] Arabic is RTL, French is LTR; Arabic is the default.
- [x] Colour grep finds matches only in `kafza_colors.dart`.

## Phase 2: Models, seed data, order engine, demo panel (brief Prompt 2)
- [x] **core/models**: Service, Category, Store, Product (readyMade + madeToOrder blocks), OptionGroup, Client, Address, Order (13 statuses, history, money state, itemTotal, deliveryFee, total), Review, Strike, Withdrawal, AppNotification. Immutable + copyWith, no codegen. (Service/Category are enums; copyWith only on the models that change: Store, Product, ReadyMade, Client, Order.)
**core/data**
- [x] `seed.dart`: services/categories, 6 stores (one paused), ~20 products incl. the brief's required cases (Baklawa stock 5, Couscous stock 2, Makrout made-to-order rules + options, Wedding cake S/M/L + flavour + name text, Msemen stock 0 + made to order, one fully unavailable), client Yacine B. (6,200 DZD, 2 addresses, 1 delivered + 1 in preparation), Dar Lalla Fatma with 2 placed + 1 accepted + earnings history.
- [x] Fake services: WalletService (idempotent debit per order id), DeliveryService (250 + 30/km, max 900), per-app notification lists.
  - Folded into the engine (the only wallet writer): `fakeDelayProvider` (300–1200 ms, overridden in tests), `deliveryFee()` in `models/order.dart`, notifications in `AppState` with `app` + `to`.
- [x] `clock.dart`: simulated clock (real time + offset), `advance(Duration)`, periodic tick. (Landed in Phase 1 for the PhoneFrame status bar.)
- [x] Images: initial-on-muted placeholder widget (`core/widgets/initial_image.dart`); no network images (offline demos stay safe).

- [x] **core/contact_check.dart**: phones (05/06/07, +213, spaced/dotted), emails, links, @handles, blocked words in FR/AR/Latin-Darija.
- [x] **core/order_engine/order_engine.dart** (Riverpod Notifier, the only writer): placeOrder, cancelByClient, decline, expire (each tick), accept, startPreparation, markReady, pickedUp, delivered, deliveryFailed, cancelAfterAcceptance, openDispute, addReview. History entry + notification on every change. Delivery failed follows spec §9.4's proposal (made to order: store paid; ready-made: stock back, refund total − delivery fee).
- [x] **features/demo_panel**: +15 min / +1 h / +24 h, courier events per order, approve/reject pending store, set client balance, reset. Floating button outside the phones (side-by-side); long-press on the status area on a phone.
- [x] **test/order_engine_test.dart**

Acceptance
- [x] Tests cover: no debit at placement; double accept debits once; low balance at accept → Payment failed + stock back; second waiting order rejected; no client cancel after accept; expiry after deadline; earnings with and without free delivery; contactCheck blocks "wtsp 0555 12 34 56", allows "Gâteau au chocolat".
- [x] Reset restores the seed data.

## Phase 3: Client browse, C1–C5 + C11 (brief Prompt 3)
`features/client/`: `client_app.dart` (GoRouter + StatefulShellRoute: Home · Search · Orders · Favourites), `yassir_home/` (C1), `home/` (C2), `search/` (C3 + filters sheet), `store_page/` (C4), `product/` (C5, uses `core/widgets/product_detail_view.dart`), `favourites/` (C11).
- [x] Skeletons, RefreshIndicator, empty states. Paused products and paused stores' products never listed. (`AppState.listedProducts`, checked by `test/search_test.dart`)
  - Client-local state (favourites, recent searches, address, search filters) + search/sort logic in `features/client/client_providers.dart`; shared client tiles in `client_widgets.dart`.
  - Placeholders until Phase 4: Orders tab, Help page, the bell (opens Orders), "Order now / Order made for me" (SnackBar).

Acceptance
- [x] Yassir home → Kafza → ✕ back to Yassir; Android back does the same. (`test/client_navigation_test.dart`)
- [x] Search, filters and sort change results.
- [x] The 3 product cases (stock / made-to-order only / unavailable) display correctly.
- [x] Arabic RTL: carousel, icons and back arrows mirrored. User content (French titles, addresses) is bidi-isolated so punctuation stays put.
- [x] `impeccable polish` pass on these screens (AR + FR, text scale 1.0 and 1.3, no overflow).

## Phase 4: Client ordering and after-order, C6–C10 + C12 (brief Prompt 4)
`features/client/ordering/` (C6 order sheet, C7 summary + waiting-order dialog + low-balance + mock CCP recharge, C8 placed), `orders/` (C9 list, C10 tracking + cancel dialog + review sheet + dispute form), `help/` (C12). In-app notification banner (4 s, tap → C10) in the client shell.
  - Routes: `/order` (summary, draft via `extra`), `/recharge`, `/kafza/orders/:id` (+ `/placed`) on the root navigator under the Orders tab, so Back lands on Orders. Engine gained `recharge()`; the banner sits in `ClientApp`'s `builder`, above the router.
  - Checked by `test/client_ordering_test.dart` (no debit at placement, waiting-order replace, low balance → recharge → place, "wtsp 0555123456" blocked).

Acceptance
- [x] Made-to-order validation blocks bad qty, missing options, wrong dates; price updates live.
- [x] "wtsp 0555123456" is blocked with an explanation.
- [x] Waiting-order dialog and low-balance recharge both work.
- [x] Placing an order does not change the balance.
- [x] Cancel only shows while Placed.
- [x] `impeccable polish` pass (AR + FR, text scale 1.0 and 1.3, no overflow).

## Phase 5: Store onboarding and catalogue, S1–S4 + S8 + S9 + S11 (brief Prompt 5)
`features/store/`: `store_app.dart` (GoRouter + shell: Home · Orders · Products · Earnings · More), `onboarding/` (S1 welcome, S2 phone + OTP 123456, S3 card + selfie with MockCamera, S4 pending/rejected), `profile/` (S11 incl. mock-map pickup pin, CCP, pause store), `products/` (S8 + stock sheet), `product_editor/` (S9, 6 steps, auto-draft, preview via `ProductDetailView`, Pro sheet for locked categories).

Acceptance
- [x] Onboarding completes; selfie has no gallery option.
- [x] Pending store can create drafts, cannot publish.
- [x] A product created here appears in client search right away (side-by-side) and its rules/options work in the client order sheet.
- [x] Contact details blocked in every text field.
- [x] `impeccable polish` pass. (On the Android emulator, AR + FR, text scale 1.0 and 1.3, every Phase 5 screen and sheet. Fixed: `+213` and the currency landed on the wrong side of the digits in Arabic (`NumberField` swaps its affix slots in RTL); phone field autofocus; the OTP keyboard stayed closed after a wrong code; pending icon start-aligned; stray rule under the products banner; dropdown values used the 18/600 title style; profile and option-group Save were disabled without saying why (`nameRequired`). Also fixed across both apps: sheets, dialogs and the date picker opened on the launcher's Navigator, so in side-by-side they covered both phones and on Android 16+ the next Back quit the app. Modals now open on the app's own root navigator (`appRootContext`), and the launcher always lets Flutter decide Back. Checked by `test/store_catalogue_test.dart`.)

## Phase 6: Store orders, money and the rest, S5–S7 + S10 + S12–S14 (brief Prompt 6)
`features/store/`: `home/` (S5), `orders/` (S6 tabs, S7 detail with accept/decline/prepare/ready/cancel-with-strike), `earnings/` (S10 + withdraw sheet), `reviews/` (S12), `strikes/` (S13 + appeal), `more/` (S14 notifications, Pro, help, language, log out). In-app notification banner in the store shell.
  - The client's banner moved to `core/widgets/notice_banner.dart` (`NoticeBanner` + `noticeText`), shared by both apps; it replaces Phase 5's approval SnackBar. Store routes: `/orders/:id`, `/more/{notifications,reviews,strikes,help}` on the root navigator, so Back lands on their tab.
  - Engine gained `withdraw` (≥ 2,000, ≤ balance, needs a CCP), `appealStrike` (once, contactCheck), `reportReview`, `markNotificationsRead`; decline / cancel reasons now run contactCheck (they show on the client timeline).
  - `StoreOrderCard` and `EarningsBreakdown` live in `store_widgets.dart` (used by Home + Orders, and by S7 + S10).
  - Checked by `test/store_orders_test.dart` (withdraw limits, appeal, banner → accept → payment secured, Karim's low balance → payment failed, no client name / phone / street on the list or detail).

Acceptance (side-by-side)
- [x] Client places → store New → Accept → client balance drops once → client timeline shows Accepted.
- [x] Draining the client balance before Accept → Payment failed on both sides.
- [x] Mark ready → demo "Delivered" → earnings credited correctly.
- [x] Cancel after accept → refund + strike; 3 strikes → suspended.
- [x] Store never sees the client's name, phone or street.
- [x] `impeccable polish` pass. (Layout sweep of every new screen and sheet in AR + FR at text scale 1.0 and 1.3: one overflow fixed. No screenshot review: the browser wasn't available, so a visual look is still owed in Phase 7.)

## Phase 7: Polish across all 26 screens (brief Prompt 7)
- [x] `impeccable audit` (native) then `impeccable polish` on every feature folder. (Code sweep: strings, directionality, `fontSize`, `DateTime.now`, durations, icon tooltips, tap-target overrides, filled-button count: all clean. Device pass on the Android emulator (API 37) in AR + FR found and fixed:
  - **Back quit the app** from an app's root (Yassir home, store tabs), wiping the demo. Each app's `MaterialApp.router` told Android it couldn't handle Back. Now all three apps use `keepBackInFlutter` (`core/widgets/kafza_sheet.dart`), and the launcher's `_BackToMenu` observer, mounted after the apps, takes a Back they couldn't use back to its menu. Checked by `test/client_navigation_test.dart`.
  - **Demo panel unreachable on a phone**: SystemUI keeps every touch on the status bar. The long-press strip now runs through the app-bar row under it.
  - **Last line under the gesture bar** on root screens with no bottom bar (C4 reviews, C10, S7 after the last action, Notifications/Reviews/Strikes/Help). `EdgeInsets.aboveGestureBar(context)` in `kafza_theme.dart`.
  - **Amounts wrapped away from their currency** ("2,725 / د.ج"). No-break space in `formatPrice` (`test/price_test.dart`) and in the duration / distance strings.
  - **"5/4.7" in Arabic** for a service rating: LRM in `serviceRating`.
  - French "(s)" plurals: `strikeStanding` is an ICU plural; `stockReserved` reworded.
  - Text scale 1.3: the store's 5-tab bar broke "Commandes" mid-word; its labels cap at 1.15×.)
- [x] Loading / empty / error-with-Retry states; money buttons can't be double-tapped. (Skeleton on the one fake-delayed load (C2); EmptyState on 8 list screens; money buttons use `KafzaButton`'s blocking loading state (seen on the device for Place order and Accept). Error-with-Retry: no screen can fail to load (in-memory data), so there is nothing to retry; engine refusals show their reason in a SnackBar.)
- [x] No hard-coded strings; Arabic fully RTL; numbers and phones LTR.
- [x] Theme tokens only; one primary button per screen; transitions ≤ 300 ms.
- [x] Spec labels and money lines everywhere. (Money line seen on C7, C8, C9, C10, S7 in every state through Delivered.)
- [x] Semantics labels, 48 px targets, text scale 1.3 holds.
- [x] `ponytail:ponytail-audit` for leftover over-engineering. (Lean: no dead code, no single-implementation layers, all four packages required.)
- [x] Run on an Android emulator/device and on Chrome side-by-side. (Chrome: release web build in headless Chrome, side-by-side: placing on the client phone lands on the store phone with banner + badge; Accept moves both phones at once.)

Acceptance
- [x] Full client order → store accept → delivery runs in Arabic and French on Android. (Client balance 6,200 → 3,475 once at Accept; store earnings 4,640 → 6,800 at Delivered.)
- [x] `flutter analyze` clean, `flutter test` passes, colour grep clean. (32 tests.)

---

## Open points (defaults chosen; say if you want otherwise)
- **Package name** stays `prototype` (renaming touches every import later).
- **Product photos**: initial-on-muted placeholders. Drop real photos into `assets/` later if the demo needs them.
- **Fonts**: `google_fonts` fetches at runtime. For an offline demo, bundle the two font files as assets (google_fonts uses them automatically).
- **Dark mode**: out of scope.
