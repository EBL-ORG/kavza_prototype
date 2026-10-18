# Product

<!-- impeccable:product-schema 1 -->

## Platform

android

## Stack

Flutter stable (3.44 / Dart 3.12), Material 3, flutter_riverpod, go_router, intl, google_fonts, flutter_localizations, iconsax_plus (icons). Fixed by the brief (`Kafza_Mobile_Prototype_Prompts.md`). Runs on Android, iOS, Chrome and Windows; side-by-side mode targets Chrome/Windows.

## Users

Primary audience of the prototype: **Yassir / Kafza stakeholders in guided demos**, run by someone who knows the flows. The prototype must make the product's rules visible and believable in front of decision-makers.

Personas the prototype depicts:
- **Client:** a Yassir super-app user in Algeria (no Kafza account; Yassir SSO) who buys homemade food, pastries, sewing and crafts, paying 100% from Yassir Cash.
- **Store owner:** a home-based woman, registered auto-entrepreneur, who runs her store from the separate Kafza Store app.

## Product Purpose

Kafza by Yassir is a marketplace for homemade products that runs as a mini-app inside Yassir. Stores publish ready-made and made-to-order products; clients order; Yassir Express delivers; Kafza holds the money between store acceptance and delivery, then pays the store minus commission.

The prototype's job: a clickable demo of the client mini-app and the store app, sharing one in-memory state, so a stakeholder can watch an order placed on one phone arrive on the other and move through its full lifecycle. Success = every business rule in §2 of the brief can be demonstrated live without explanation slides.

## Positioning

Money-safety and trust as product mechanism: nothing is taken at placement, the debit happens only when the store accepts, stock is reserved and returned automatically, and client/store can never exchange contact details. Every money screen says where the money is.

## Operating Context

- Demos on Chrome/Windows (side-by-side, two 390×844 phone frames) and on an Android phone.
- A demo panel stands in for the back-office and Yassir Express: clock skips, courier events, approve/reject store, set balance, reset.
- No backend, no Firebase: fake services with 300–1200 ms delays.

## Capabilities and Constraints

- 26 screens: 12 client (C1–C12), 14 store (S1–S14), plus launcher, side-by-side and demo panel.
- Languages: **Arabic (default, RTL) and French only.** English is out of scope (user decision, overrides the brief's AR/FR/EN).
- Out of scope: chat/messaging, cash on delivery, card payments, client sign-up, admin back-office, dark mode.
- Placeholders not set in the spec: commission 10%, minimum withdrawal 2,000 DZD, Pro 1,500 DZD/month, "Only a few left" at 3, 3 strikes = 7-day suspension, dispute window 48 h, delivery fee 250 DZD + 30 DZD/km (max 900).

## Brand Commitments

- Name and brand line: "Kafza by Yassir". Yassir design system governs; official Yassir tokens, fonts and icons have not been delivered yet, so current values are placeholders (see DESIGN.md).
- Voice: short, warm, direct. Use the spec's exact button labels. User content (store names, products, reviews) is shown as written, never translated.

## Evidence on Hand

- `../Kafza_by_Yassir_Cahier_des_charges_v0.2.docx`: the spec (source of requirement IDs).
- `Kafza_Mobile_Prototype_Prompts.md`: the build brief (screens, rules, design, prompts).
- `../Kafza_Prototype_Prompt_Pack.md`: earlier, longer pack. Its §C (design guidance) feeds DESIGN.md.
- No real logos, testimonials or metrics. Seed data is invented and must read as demo data. Product, store and client photos are CC-licensed Wikimedia Commons stand-ins (`assets/images/CREDITS.md`).

## Product Principles

1. **Say where the money is.** Every money state is explicit: still in Yassir Cash, held by Kafza, refunded, paid.
2. **Rules are shown, not explained.** Validation, countdowns and blocked states make the spec's rules visible in the UI itself.
3. **Privacy by default.** The store sees only the client's commune; the client sees only the store's commune and approximate distance.
4. **Feels like Yassir.** Kafza adds no visual identity of its own beyond the Yassir palette and its logo (word logo + mascot).

## Accessibility & Inclusion

- Arabic first: full RTL mirroring; numbers, prices and phone numbers stay LTR.
- 48 dp touch targets, Semantics labels on icons and inputs, layouts survive text scale 1.3.
