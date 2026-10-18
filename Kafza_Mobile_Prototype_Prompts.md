# Kafza by Yassir — Mobile Prototype Prompts (Flutter, client + store only)

Source: *Kafza by Yassir — Cahier des charges v0.2*. Scope: a small, clickable **Flutter** prototype of the **client mini-app** and the **Kafza Store app**. No back-office, no admin, no real backend. Requirement IDs (CLT-, STR-, PAY-…) point to the spec.

---

## 1. Screens (26)

Bottom sheets, dialogs and states live **inside** their parent screen, so they are not counted.

### Client: Kafza mini-app inside Yassir (12)
| # | Screen | What it does | Includes |
|---|---|---|---|
| C1 | Yassir home (mock) | Entry point: "Kafza" tile → opens the mini-app | Yassir Cash balance pill |
| C2 | Kafza home | Services, categories, nearby stores, new and popular products (CLT-03) | Address chip, search bar, "order waiting" banner |
| C3 | Search & results | Search products/stores, filter and sort (CLT-04/05) | Filters sheet |
| C4 | Store page | Name, logo, commune + approx. distance, ratings, reliability, products, reviews (CLT-07) | Favourite, share |
| C5 | Product page | Photos, details, ready-made and/or made-to-order blocks, CTAs (CLT-09…12) | "Only a few left", unavailable state |
| C6 | Order sheet | "Order now" (qty + address) or "Order made for me" (qty, options, date, address, live price, validation) (CLT-13…17) | Address picker |
| C7 | Order summary | Details, delivery fee, total, Yassir Cash balance, Place order / Cancel (CLT-18…22) | Low-balance state + mock recharge, "you already have a waiting order" dialog |
| C8 | Order placed | Confirmation: "money is taken when the store accepts" (CLT-22) | — |
| C9 | My orders | Current / past, amount paid, refunds (CLT-29) | — |
| C10 | Order tracking | Status timeline, money line, cancel while Placed, review, report a problem (CLT-26…31) | Cancel dialog, review sheet, dispute form |
| C11 | Favourites | Saved products and stores (CLT-08) | — |
| C12 | Help | FAQ + contact Kafza support form (CLT-32) | — |

### Store: Kafza Store app (14)
| # | Screen | What it does | Includes |
|---|---|---|---|
| S1 | Welcome & phone | Language, phone number (STR-01) | — |
| S2 | OTP | 6-digit code | Resend timer |
| S3 | Verification | Auto-entrepreneur card front/back + number + activity, then live selfie (STR-02/03) | Mock camera, no gallery |
| S4 | Pending / rejected | Can prepare store, can't publish (STR-04/06) | Resubmit |
| S5 | Home | Store status, orders needing an answer with countdowns, balance, low stock | Pause banner |
| S6 | Orders | New / In progress / History (STR-27) | — |
| S7 | Order detail | Accept (wallet debit) / Decline with reason / In preparation / Ready / Cancel with strike (STR-28…31) | Decline sheet, accept result, cancel dialog |
| S8 | Products | List, pause/resume, stock edit, delete, share (STR-16…20) | Stock sheet |
| S9 | Product editor | Category → details → selling modes → custom rules → option groups → preview & publish (STR-12…15, STR-24/25) | Option group sheet |
| S10 | Earnings | Balance, per-order breakdown, withdraw, withdrawal history (STR-33…35) | Withdraw sheet |
| S11 | Store profile & settings | Name, description, picture, commune, private pickup location, CCP details, pause store (STR-08…11, STR-26) | — |
| S12 | Reviews | Ratings per service, report a review (STR-36) | — |
| S13 | Strikes & appeal | Standing, strikes list, appeal form (STR-37) | — |
| S14 | More | Notifications list, Kafza Pro, help, language | Pro sheet |

### Prototype tooling (not app screens)
- **Launcher:** the first screen of the Flutter app. Pick Client app, Store app or Side-by-side.
- **Side-by-side mode:** best run on Chrome or Windows desktop. It shows the client phone and the store phone next to each other, sharing the same data, so an order placed on the left appears on the right.
- **Demo panel:** a floating button, outside the phone frames in side-by-side mode or long-press on the status bar on a real phone. It offers +1 h clock, courier events (Picked up / Delivered / Delivery failed), approve/reject the pending store, set client balance, and reset. It stands in for the back-office and Yassir Express, which are out of scope.

---

## 2. Rules the prototype must respect

- **Payment:** total = unit price × qty + options + delivery fee (0 if free delivery). Placing an order only **checks** the Yassir Cash balance. The debit happens when the store taps **Accept**: full debit → Accepted, or nothing → "Payment failed" (no strike, stock returned).
- **One waiting order:** a client can have one "Placed" order at a time. Placing another shows: "Cancel it and place this one" / "Keep it".
- **Cancellation:** client can cancel only while Placed. Store can cancel after acceptance only with a reason → full refund + strike.
- **Stock:** reserved at placement, consumed at accept, returned on decline / expiry / client cancel / payment failed. Stock 0 → "Order now" hidden; "Order made for me" stays if enabled.
- **Made to order:** qty ≥ min, ≤ max, on step; required options filled; date ≥ now + lead time and on an available day. "Continue" disabled until valid, errors shown in place.
- **Acceptance window:** 2 h ready-made, 24 h made to order → then "Expired" (no strike).
- **Statuses:** Placed → Accepted → In preparation → Ready → Picked up → Delivered; plus Cancelled by client, Declined, Expired, Payment failed, Cancelled after acceptance, Delivery failed, Disputed.
- **Earnings:** item total − 10% commission − delivery fee (if free delivery), credited on delivery.
- **Privacy:** store sees only the client's commune; client sees only the store's commune + approximate distance.
- **No contact:** no chat, no free-text notes. Text with phone numbers, emails, links, @handles or words like WhatsApp/Instagram is blocked with an explanation.
- **Free plan:** 1 category; Kafza Pro unlocks more.
- **Pending store:** can build its store and products, cannot publish or receive orders.

Placeholders (not set in the spec): commission 10%, minimum withdrawal 2,000 DZD, Pro 1,500 DZD/month, "Only a few left" at 3, 3 strikes = 7-day suspension, dispute window 48 h, delivery fee 250 DZD + 30 DZD/km (max 900).

---

## 3. Design (Yassir) in Flutter terms

- **Colours (only these), in one `KafzaColors` file:** primary `#6316DB`, primaryDark `#4A0FA8`, primaryLight `#F1EAFD`, text `#1F1E1B`, textSecondary `#5A5750`, background `#FFFFFF`, muted `#F3F2EE`, border `#E4E2DC`. Approximations until Yassir's tokens arrive: success `#12A150`, warning `#B76E00`, error `#D92D20`. No `Colors.xxx` anywhere else in the code.
- **Theme:** one Material 3 `ThemeData` built from these tokens (ColorScheme, text theme, button/input/chip/bottom-sheet/dialog themes), plus a `ThemeExtension` for the colours Material has no slot for (muted, success, warning).
- **Fonts:** Inter (Latin) and IBM Plex Sans Arabic (Arabic) via `google_fonts`. Placeholders until Yassir's fonts arrive.
- **Sizes:** 4-pt spacing, 16 px screen padding, radius 12 for buttons/inputs, 16 for cards, 24 for bottom-sheet tops, 52 px primary buttons, 48 px minimum touch targets.
- **One primary button per screen.**
- **Client navigation:** AppBar "Kafza by Yassir" with ✕ (back to Yassir) on main tabs and ← on inner screens. `NavigationBar` tabs: Home · Search · Orders · Favourites.
- **Store navigation:** `NavigationBar` tabs Home · Orders · Products · Earnings · More.
- **Languages:** Arabic (RTL, handled by Flutter from the locale), French, English via ARB files. Use `EdgeInsetsDirectional` / `AlignmentDirectional` so RTL works. Prices in DZD via `intl`.

---

## 4. Prompts

Run them in order, one at a time. Check the acceptance criteria before moving on. If your tool doesn't remember the project between prompts, paste this block at the top of each one.

### Shared context block
```
PROJECT: "Kafza by Yassir" — a small clickable FLUTTER prototype of a homemade-products marketplace inside the Yassir super-app (Algeria). One Flutter app with a launcher that opens: (1) the client Kafza mini-app, entered from a mock Yassir home; (2) the Kafza Store app for store owners; (3) a side-by-side mode (for Chrome/desktop) showing both apps in 390x844 phone frames. Both apps share ONE in-memory data store. No back-office, no real backend, no Firebase.
SOURCE: Kafza Cahier des charges v0.2 (in the project folder). Do not add chat or messaging, cash on delivery, card payments or client sign-up.
DESIGN: Yassir style. Colours only from lib/core/theme/kafza_colors.dart: primary #6316DB, primaryDark #4A0FA8, primaryLight #F1EAFD, text #1F1E1B, textSecondary #5A5750, background #FFFFFF, muted #F3F2EE, border #E4E2DC, success #12A150, warning #B76E00, error #D92D20. Never use Colors.xxx or hex values outside that file. Fonts Inter / IBM Plex Sans Arabic (google_fonts). Radius 12 buttons, 16 cards, 24 sheets. One primary button per screen. Reuse widgets from lib/ui/.
LANGUAGES: AR (RTL), FR, EN with flutter_localizations + ARB files (gen-l10n). Use EdgeInsetsDirectional. Prices in DZD via intl.
STACK: Flutter stable, Dart 3, Material 3, flutter_riverpod (state), go_router (navigation), intl, google_fonts. Fake services with 300–1200 ms Future.delayed. No other packages unless necessary.
```

---

### Prompt 1 — Setup, theme, shared widgets, launcher

```
[Shared context block]

Set up the Flutter project:
1. `flutter create kafza_prototype` (Android, iOS, web, windows). Add flutter_riverpod, go_router, intl, google_fonts, flutter_localizations.
2. Folders: lib/core/theme, lib/core/l10n, lib/core/format, lib/data (models, seed, services, order engine), lib/ui (shared widgets), lib/client, lib/store, lib/demo.
3. Theme: kafza_colors.dart (tokens above), kafza_theme.dart building a Material 3 ThemeData (ColorScheme from tokens, text theme 28/22/18/16/14/12 with Inter or IBM Plex Sans Arabic depending on locale, FilledButton 52 px radius 12, OutlinedButton, InputDecorationTheme with label/helper/error, ChipTheme, BottomSheetTheme with 24 top radius, DialogTheme, NavigationBarTheme), and a ThemeExtension for muted/success/warning.
4. Shared widgets in lib/ui: KafzaButton (primary, outline, text, destructive, loading state that blocks taps), KafzaTextField (label, helper, error, counter, prefix), QuantityStepper (min/max/step, decimals for kg), StatusChip, RatingStars (display + input), KafzaBadge, InfoBanner, EmptyState, SkeletonBox, PriceBreakdown, BalanceCard, CountdownChip, StatusTimeline, MockCamera (rectangle frame for ID card or oval for face; capture shows a placeholder image; NO gallery option), PhoneFrame (390x844 with status bar showing the simulated clock).
   Helpers: showKafzaSheet (showModalBottomSheet, scroll-controlled, drag handle) and showKafzaDialog.
5. Localisation: ARB files app_ar.arb, app_fr.arb, app_en.arb; a localeProvider; switching to Arabic flips direction automatically. Price formatter: "2 400 DA" (fr), "2,400 DZD" (en), Arabic format in ar.
6. Launcher screen: title "Kafza by Yassir — Prototype", buttons Client app / Store app / Side-by-side, language switch AR/FR/EN.
7. Side-by-side screen: two PhoneFrames in a Row (one per app), each with its OWN GoRouter / Navigator, inside the same ProviderScope so they share state. On narrow screens (phones), hide this option.
8. Placeholder screen in each app.

ACCEPTANCE
- [ ] `flutter run -d chrome` shows the launcher; all three options open.
- [ ] Side-by-side shows two phones that navigate independently.
- [ ] Arabic flips the layout to RTL; French/English stay LTR.
- [ ] `grep -r "Colors\.\|Color(0x" lib/` finds matches only in kafza_colors.dart.
- [ ] `flutter analyze` reports no errors.
```

### Prompt 2 — Mock data and order logic

```
[Shared context block]

Create the shared data and the only code allowed to change orders.

1. Models (immutable classes with copyWith): Service, Category, Store, Product (readyMade: price, stock, reserved, prepTime, lowStockAlert; madeToOrder: price, minQty, maxQty?, step?, leadTime, prepTime, availableDays, optionGroups), OptionGroup (single | multiple | colour | text, required, choices with price per unit or per order, maxLength), Client, Address, Order (status enum with the 13 statuses, history list of {status, time, note}, money state, itemTotal, deliveryFee, total), Review, Strike, Withdrawal, AppNotification (client | store).
2. Seed data (realistic Algerian content):
   - Services/categories: Cooking (Traditional food, Traditional sweets, Cakes & pastries, Breads), Sewing (Traditional clothing, Children's clothing), Crafts (Pottery, Jewellery).
   - 6 stores: "Dar Lalla Fatma" (sweets, Kouba), "Les Délices d'Amina" (cakes, Chéraga), "Couscous Yemma" (Blida), "Atelier Karakou Nour" (Bab Ezzouar), "Fekhar Tizi" (pottery, Tizi Ouzou), "Bijoux Thiziri" (Oran). One paused.
   - ~20 products with DZD prices. Include: Baklawa box (ready-made, stock 5); Couscous portion (stock 2 → "Only a few left"); Makrout el louz (made to order, 2,800/kg, min 1 kg, step 0.5, 48 h lead, Tue/Thu/Sat, options "Honey glaze +200/kg", "Gift box +300 per order"); Wedding cake (made to order, size S/M/L, required flavour, "Name on the cake" short text max 30); Msemen (stock 0 + made to order); one product with nothing available.
   - Client: Yacine B., Yassir Cash 6,200 DZD, 2 saved addresses (Bab Ezzouar, Alger Centre), 1 delivered order (reviewable), 1 in preparation.
   - Store owner account: "Dar Lalla Fatma", with 2 placed orders, 1 accepted and earnings history.
   - Images: bundled placeholder assets or Image.network with an errorBuilder that shows the product initial on the muted colour (never a broken image).
3. Fake services (Future.delayed 300–1200 ms): WalletService (getBalance, debit, refund, recharge; a debit never happens twice for the same order id), DeliveryService (fee = 250 + 30/km, max 900), notifications added to a list per app.
4. contactCheck(String text) → null if OK, or a reason message. Blocks phone numbers (05/06/07…, +213, with spaces/dots), emails, links, @handles, and words such as whatsapp, wtsp, insta, facebook, snap, telegram, tiktok, numéro, nmra, واتساب, انستغرام, فيسبوك, رقمي (case-insensitive).
5. Order engine (lib/data/order_engine.dart, a Riverpod Notifier), the ONLY place statuses change:
   placeOrder (check rules, stock, one waiting order, balance ≥ total, no debit; reserve stock; deadline 2 h / 24 h) · cancelByClient (Placed only) · decline(reason) · expire (on every clock tick) · accept (debit; success → Accepted, else Payment failed + stock back, no strike) · startPreparation · markReady · pickedUp · delivered (credit earnings = item total − 10% − delivery fee if free delivery) · deliveryFailed · cancelAfterAcceptance(reason) (refund + strike; 3 strikes → 7-day suspension) · openDispute · addReview.
   Every change adds a timestamped history entry and a notification for the right app.
6. Simulated clock provider (now = real time + offset) with advance(Duration); a periodic Timer ticks it so countdowns and expiry update.
7. Demo panel (floating button outside the phone frames in side-by-side mode; long-press on the status bar on a phone): +15 min, +1 h, +24 h; courier: Picked up / Delivered / Delivery failed for a chosen order; approve / reject pending store; client balance input; reset data.
8. Unit tests in test/order_engine_test.dart.

ACCEPTANCE
- [ ] `flutter test` passes and covers: no debit at placement; double accept debits once; low balance at accept → Payment failed + stock back; second waiting order rejected; client can't cancel after accept; expiry after the deadline; correct earnings with and without free delivery; contactCheck blocks "wtsp 0555 12 34 56" and allows "Gâteau au chocolat".
- [ ] Reset restores the seed data.
```

### Prompt 3 — Client: browse (C1–C5, C11)

```
[Shared context block]

Build the client discovery screens using the providers from Prompt 2.

- C1 Yassir home (mock): greeting, Yassir Cash pill, service tiles incl. "Kafza" (New badge) → slide-up page transition into the mini-app.
- C2 Kafza home: AppBar "Kafza by Yassir" (✕ back to Yassir, bell, ?), address chip, search bar, banner if an order is waiting ("Waiting for the store · 1 h 12 min left"), services, categories, stores near you (commune + "≈ 3 km"), new, popular. Skeletons while loading; RefreshIndicator.
- C3 Search: live results (products / stores TabBar), recent searches, filters bottom sheet (sort: closest, rating, price, preparation time; filters: wilaya, available now, made to order, min rating, price range), empty state.
- C4 Store page: avatar or initial, name, commune + distance (never an address), overall rating, rating per service, reliability %, description, products / reviews tabs, favourite, share (SnackBar "Link copied"). Paused store: "Not taking orders right now".
- C5 Product page: PageView photo carousel with dots, title, store row, rating, unit, description, ingredients (food only). Ready-made block (price, stock or "Only a few left" at ≤ 3, prep time) and made-to-order block (price + rules in words: "Min 1 kg, by 0.5 kg · Order 48 h ahead · Delivered Tue, Thu, Sat"). Bottom bar with "Order now" and/or "Order made for me"; if neither is possible → "Currently unavailable".
- C11 Favourites: products / stores tabs, empty state.
- NavigationBar: Home · Search · Orders · Favourites (ShellRoute in go_router).
Paused products and paused stores' products never appear in lists.

ACCEPTANCE
- [ ] Yassir home → Kafza → ✕ back to Yassir works; Android back button behaves the same.
- [ ] Search, filters and sort change results.
- [ ] The 3 product cases (stock / made to order only / unavailable) display correctly.
- [ ] Works in Arabic RTL (carousel, icons and back arrows mirrored).
```

### Prompt 4 — Client: order flow and after-order (C6–C10, C12)

```
[Shared context block]

Build ordering, following this flow exactly: Product → Order sheet → Summary → (waiting order?) → (balance enough?) → Order placed.

- C6 Order sheet (scroll-controlled bottom sheet):
  · "Order now": QuantityStepper 1…available stock, address picker, estimated delivery time, live total.
  · "Order made for me": QuantityStepper with min/max/step, option groups (single = radio tiles, multiple = FilterChips, colour = swatches, short text = KafzaTextField with counter + contactCheck), delivery date via showDatePicker with selectableDayPredicate (lead time + available days), address, live PriceBreakdown. Errors shown next to each field; "Continue" disabled until valid.
- C7 Summary page: product, type, qty, options, date, address, item total, delivery fee or "Free delivery", total, BalanceCard. Buttons "Place order" / "Cancel" (Cancel → back to product, nothing created).
  · If another order is waiting: dialog showing it, with "Cancel it and place this one" / "Keep it".
  · If balance < total: card turns red, "Missing 1,350 DZD", Place order disabled, "Recharge with CCP" → mock Yassir recharge page (amount presets, confirm, 1.5 s processing, success) → pops back to the summary with the new balance.
- C8 Order placed: order number, store deadline, "Nothing is taken yet. The amount will be taken from your Yassir Cash when the store accepts. If your balance is too low then, the order will be cancelled." Buttons Track order / Back to Kafza.
- C9 My orders: Current / Past tabs, status chip, amount paid, refund line.
- C10 Order tracking: StatusTimeline with times, a line saying where the money is ("Still in your Yassir Cash" / "Paid — held by Kafza" / "Refunded"), countdown + "Cancel order" only while Placed, courier card when picked up. After delivery: "Leave a review" (stars + comment, once) and "Report a problem" (reason, description, photos placeholder, within 48 h).
- C12 Help: FAQ (ExpansionTiles: payment, cancellation, delivery, why you can't message the store) + contact-support form.
- New client notifications show as an in-app banner at the top of the client app (MaterialBanner or custom overlay, 4 s); tap → C10.

ACCEPTANCE
- [ ] Made-to-order validation blocks bad qty, missing options, wrong dates; price updates live.
- [ ] Short text "wtsp 0555123456" is blocked with an explanation.
- [ ] Waiting-order dialog and low-balance recharge both work.
- [ ] Placing an order does not change the balance.
- [ ] Cancel only appears while Placed.
```

### Prompt 5 — Store: onboarding and products (S1–S4, S8, S9, S11)

```
[Shared context block]

- S1 Welcome: logo "Kafza by Yassir", language choice, "Get started" / "I have a store" (logs into the seeded Dar Lalla Fatma account).
- S2/S3 Phone (+213 prefix, LTR field) + OTP (6 boxes, demo code 123456, 60 s resend timer, wrong-code error).
- S3 Verification: card front, card back (MockCamera with card frame), card number, activity; then live selfie (MockCamera with face oval, no gallery). Progress indicator: Phone → Code → Card → Selfie.
- S4 Pending: "Usually checked within 24 h", what she can do now vs what is locked; rejected variant with reason + Resubmit. Approval comes from the demo panel → notification + store unlocked.
- S11 Store profile & settings: name and description (contactCheck), picture (photo / logo / none), wilaya, commune, pickup location on a static mock map image with a draggable pin and "Never shown to clients", CCP / BaridiMob details, "Pause my store" SwitchListTile with a confirmation dialog.
- S8 Products: list with status (live / paused / draft), stock badge, PopupMenu (edit, pause/resume, stock sheet, share, delete; delete blocked if an order is in progress).
- S9 Product editor (multi-step page with progress, auto-saved as draft):
  1. Service & category (free plan: other categories locked with a "Pro" badge → Pro sheet).
  2. Photos (≥ 1, placeholder picker), title, description, ingredients (food only), unit, free delivery switch ("fee deducted from your earnings").
  3. Selling modes: Ready-made (price, stock, prep time, low-stock alert) and/or Made to order (at least one).
  4. Custom rules: price, min, max, step, lead time, prep time, available days (FilterChips), prefilled "Suggested by Kafza".
  5. Option groups: name, type (single / multiple / colour / short text), required, choices with price per unit or per order.
  6. Preview (reuse the client product page widget) → Publish (disabled while pending).

ACCEPTANCE
- [ ] Onboarding completes; selfie has no gallery option.
- [ ] Pending store can create drafts but cannot publish.
- [ ] A product created here appears in client search right away (check in side-by-side) and its rules and options work in the client order sheet.
- [ ] Contact details are blocked in every text field.
```

### Prompt 6 — Store: orders, earnings and the rest (S5–S7, S10, S12–S14)

```
[Shared context block]

- S5 Home: store status, "Needs your answer" with countdowns, today's orders, balance, low-stock alert, strike warning.
- S6 Orders: New (badge) / In progress / History tabs. Card: product, type, qty, options, delivery date, client commune only, total, countdown.
- S7 Order detail:
  · Placed → Decline (reason bottom sheet, no strike) / Accept → "Securing payment…" (button locked) → "Order confirmed — payment secured" OR "Payment failed — client balance too low. Stock is back, no strike."
  · Accepted → "Start preparation" → "Mark as ready" (dialog: "Yassir Express will pick it up") → waiting for the courier → delivered.
  · Accepted / In preparation → "Cancel order": warning "Client fully refunded, you get a strike" + reason.
  · Expired while open → "This order expired".
- S10 Earnings: available, on hold, per-order breakdown (item total, commission, delivery fee deducted, net), Withdraw sheet (≥ 2,000 DZD, ≤ available) to masked CCP, history (requested / sent / failed).
- S12 Reviews: rating per service, list (no reply), Report.
- S13 Strikes: standing ("2 of 3 strikes before a 7-day suspension"), strikes list, appeal form (text + attachment placeholder). Suspended: products hidden, banner, accepted orders still manageable.
- S14 More: notifications list, Kafza Pro (Free vs Pro 1,500 DZD/month from balance), help, language, log out.
- New store notifications show as an in-app banner at the top of the store app.

ACCEPTANCE (test in side-by-side)
- [ ] Client places order → appears in store New → Accept → client balance drops once → client timeline shows Accepted.
- [ ] Draining the client balance before Accept → Payment failed on both sides.
- [ ] Mark ready → demo panel "Delivered" → earnings credited correctly.
- [ ] Cancel after accept → client refunded + strike; 3 strikes → suspended.
- [ ] Store never sees the client's name, phone or street address.
```

### Prompt 7 — Polish

```
[Shared context block]

No new features. Go through all 26 screens:
1. Loading (skeletons), empty and error states (with Retry) where relevant; buttons that move money can't be double-tapped.
2. All text from ARB files in AR / FR / EN (no hard-coded strings); Arabic fully RTL (icons, arrows, steppers mirrored; numbers and phone numbers stay LTR).
3. Visual consistency: theme tokens only, one primary button per screen, same card, chip and icon styles everywhere, page transitions ≤ 300 ms.
4. Copy: use the spec's button labels ("Order now", "Order made for me", "Place order", "Recharge with CCP", "Accept", "Decline", "Ready"); every money screen says where the money is.
5. Accessibility: Semantics labels on icons and inputs, 48 px touch targets, readable contrast, text scale 1.3 doesn't break layouts.
6. Test on an Android emulator (or device) and on Chrome side-by-side.

ACCEPTANCE
- [ ] Full client order + store accept + delivery runs smoothly in all three languages on Android.
- [ ] `flutter analyze` clean; `flutter test` passes.
- [ ] No Colors.xxx or hex colours outside kafza_colors.dart.
```
