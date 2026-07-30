# Glow Lab

A 2D casual beauty-sim game built with Flutter. You run a small beauty studio: a customer
walks in with a vibe they want, you pick the right **Foundation / Blush / Lip / Glow**
before the timer runs out, and you earn stars and coins for how well the look matches.

Portrait-only, mobile-first (Android + iOS). No login, no backend, no 3D.

---

## Core loop

1. A customer appears with a request (e.g. *"Clean girl look for brunch ☕"*) plus visible
   tags: skin tone · undertone · occasion.
2. A painted face preview shows their skin tone and updates live as you pick products.
3. Pick one product from each of the four categories. You have **30 seconds**.
4. Tap **Reveal look** to score.
5. The result screen breaks the score down per criterion, awards stars and coins.
6. Coins unlock premium products. Next customer.

One customer takes roughly 20–40 seconds. Five customers make a "day", then you're back home.

## Scoring

Maximum is **125 points**. Foundation is punished hardest, like real life.

| Criterion | Points |
|---|---|
| Foundation — exact tone | +30 |
| Foundation — off by one shade | +10 |
| Foundation — two or more shades off | **−20** |
| Foundation — undertone correct | +10 |
| Blush / Lip / Glow — exactly the preferred product | +20 each |
| Blush / Lip / Glow — same colour temperature as preferred | +8 each |
| Blush / Lip / Glow — anything else | +3 each |
| Colour harmony — all non-neutral temps agree | +10 |
| Time bonus | up to +15, scaled by seconds left |

Stars: ≥95 → 3, ≥65 → 2, ≥35 → 1. Coins earned = `round(total / 4)`.

> Note: not every customer can reach 125. Mai's preferred blush is warm (peach) while her
> preferred glow is cool (pearl), so even the perfect look forfeits the harmony bonus and
> caps at 115. That's intentional, and it's covered in the tests.

## Content

- **20 products** — 17 base plus 3 unlockable (Foundation `1W Amber` 30c, Blush `Mauve` 40c,
  Glow `Holo` 50c). Names are original; nothing is branded after a real cosmetics line.
- **5 customers**, each with a hidden set of preferences the player has to infer from the
  request and tags.

Coins and unlocked products persist across launches via `shared_preferences`.

## Project layout

```
lib/
  main.dart                     app shell — swaps Home/Game/Result, no Navigator
  data/
    palette.dart                design tokens, Temp enum, skin-tone ladder
    models.dart                 Product, Customer, Category
    catalog.dart                all products + customers (const data)
  logic/
    score_calculator.dart       pure scoring — no UI, no state, fully unit-tested
  state/
    game_controller.dart        ChangeNotifier: selection, timer, coins, unlocks
  widgets/
    face_preview.dart           CustomPaint face that reacts to the current selection
    top_bar.dart                title + coin counter
  screens/
    home_screen.dart            logo, coins, Open Studio, unlock shop
    game_screen.dart            request card, face, swatch rows, timer, Reveal
    result_screen.dart          score breakdown, stars, coins, Next
prototype/
  Glow_Lab_GDD.md               game design document (Vietnamese)
  glow_lab_prototype.html       self-contained web prototype
test/
  score_calculator_test.dart    scoring rules
  widget_test.dart              smoke test
```

The design rule the codebase follows: **logic and data stay independent of the UI.**
`ScoreCalculator` is pure Dart with no Flutter imports, which is what makes it cheap to test.

`prototype/glow_lab_prototype.html` is a standalone browser version — open it directly in a
browser, no build step. It is the reference implementation for the data and the scoring
formula; the Flutter app is a 1:1 port of it.

## Running it

Requires the Flutter SDK (Dart `^3.12.2`).

```bash
flutter pub get
flutter run                 # attached device or emulator
flutter test                # unit + widget tests
flutter analyze             # lints
flutter build apk --release
```

## Roadmap

Post-MVP, roughly in order:

- Polish: transition animations, tap/score sounds
- More customers and products, difficulty ramp
- Rewarded ads (`google_mobile_ads`) and cosmetic packs (`in_app_purchase`)
- Daily challenge and limited-time events ("Wedding Makeup Week")
- Vanity room decor, studio star/level progression
