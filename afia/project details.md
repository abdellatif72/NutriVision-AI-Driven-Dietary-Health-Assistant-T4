# Afia — Design System & App Spec

## 1. Design System

### Colors

#### Light Mode Palette (from `app_colors.dart` + `progemini_en.html`)

| Token | Hex | Usage |
|---|---|---|
| `primary` / `--afia-primary` | `#2E9E69` | Brand green — primary CTAs, active states, progress rings, calorie ring |
| `--afia-primary-light` | `#B8DEC7` | Subtle green surfaces, hover borders |
| `--afia-primary-dark` | `#1D6B3E` | Dark green — header gradients, manual action buttons, emphasis text |
| `--afia-forest-800` | `#124D2C` | Deepest green (rare) |
| `ctaFood` / `--afia-cta` | `#D05A28` | Orange — food CTAs, "Film your food" button, FAB, calorie badge bg |
| `--afia-cta-dark` | `#A0431A` | Darker orange for gradients |
| `secondary` | `#256F50` | Secondary green — secondary buttons, weight loss green, macro fill #2 |
| `--afia-secondary` (HTML) | `#2780C5` | Blue — used for `ColorScheme.secondary` but named "hydration" in code; caution: Dart `secondary` = `#256F50` |
| `hydration` / `--afia-hydration` | `#2780C5` | Blue — water ring, water tiles, water icons, toggle active |
| `--afia-hydration-600` | `#1A6DA3` | Darker blue for water icon |
| `--afia-secondary-light` | `#B0D3EE` | Light blue surfaces |
| `background` / `--afia-bg` | `#FAFAF8` | Page background |
| `surface` / `--afia-card` | `#FFFFFF` | Card/surface white |
| `--afia-surface-green` | `#E8F5ED` | Green tinted surface (calorie ring card bg) |
| `--afia-surface-warm` | `#FDF0E8` | Warm tinted surface (AI confirmation) |
| `--afia-surface-blue` | `#E3F1FA` | Blue tinted surface (water presets) |
| `textPrimary` | `#16211D` | Primary text (very dark green-black) |
| `--afia-text` (HTML) | `#2A2925` | *Note: slight mismatch from Dart code's `#16211D`* |
| `textSecondary` | `#5B6B65` | Secondary/muted text (Dart code) |
| `--afia-text-muted` (HTML) | `#888680` | *Note: HTML uses a warmer grey `#888680`* |
| `divider` (Dart) | `#E6ECE8` | Borders and dividers |
| `--afia-border` (HTML) | `#D0CFC7` | *Note: HTML uses a warmer grey `#D0CFC7`* |
| `streak` / `--afia-amber` | `#E08A0A` | Streak gold — streak days, trophy icon, macro fill #2 |
| `--afia-amber-light` | `#FEF5E0` | Streak card background |
| `--afia-red` | `#E24B4A` | Error/danger — delete actions, error state |
| `--afia-red-soft` | `#FCEBEB` | Soft red surface for errors |
| `--afia-screen-bg` | `#0D1F16` | Phone mockup bezel (very dark green) |
| `--afia-macro-protein` | `#2E9E69` | Green macro bar |
| `--afia-macro-carbs` | `#E08A0A` | Amber macro bar |
| `--afia-macro-fat` | `#D05A28` | Orange macro bar |
| `--afia-macro-remaining` | `#B5B3A9` | Remaining calorie ring |
| `--afia-explore-neutral` | `#F5F4F0` | Explore catalog neutral surface |
| `--afia-state-loading` | `#2780C5` | Loading state = hydration blue |
| `--afia-state-error` | `#E24B4A` | Error state = red |

**Dark mode**: Not defined — only `ThemeData.light()` exists.

**Semantic convention**: CSS custom property naming (`--afia-{purpose}`), Dart uses `AppColors.{camelCase}`. No numeric scale (e.g., `-500`).

---

### Typography

**Font families** (from `progemini_en.html`):
- **Primary**: `Inter` (Latin text)
- **Arabic fallback**: `Cairo` (Arabic script)
- **System fallback**: `system-ui, sans-serif`
- **Emoji**: `'Segoe UI Emoji', 'Apple Color Emoji', 'Noto Color Emoji', sans-serif`

**No custom fonts in pubspec.yaml** — fonts are currently the Flutter default (no `fonts:` section). The HTML uses Google Fonts `Inter` + `Cairo` for the design mockup only.

#### Type Scale

| Style | Size | Weight | Color | Usage |
|---|---|---|---|---|
| Title Large | 24 px | W700 (Bold) | `#16211D` | Screen titles |
| Title Medium | 18 px | W600 (Semi-Bold) | `#16211D` | Section headers |
| Body Medium | 14 px | W400 (Regular) | `#5B6B65` | Body text, descriptions |
| *Home greeting name* | 22 px | W800 (ExtraBold) | `#FFFFFF` | User name in green header |
| *Home greeting line* | 13 px | W600 (Semi-Bold) | `#FFFFFF` | "Good morning" line |
| *Home section labels* | 12–13 px | W800 (ExtraBold) | `#16211D` | "Today's calories", section titles |
| *Card values* | 16 px | W800 (ExtraBold) | `#2E9E69` | Calorie ring percentage |
| *Macro grams* | 11 px | W700 (Bold) | `#16211D` | Macro g value |
| *Macro label* | 10 px | W400 (Regular) | `#5B6B65` | "Carb", "Protein" |
| *Caption/tiny* | 9–11 px | W600 (Semi-Bold) to W700 | `#5B6B65` | Bar chart labels, water time, streak day labels |
| *Water ring value* | 30 px | W900 (Black) | `#2780C5` | Liters consumed |
| *Sheet title* | 15–16 px | W800 (ExtraBold) | `#16211D` | Bottom sheet headers |
| *Search hint* | 12 px | W400 (Regular) | `#5B6B65` | Search placeholder |
| *Meal name in tile* | 14 px | W800 (ExtraBold) | `#16211D` | Search result meal name |
| *Calorie badge* | 11 px | W800 (ExtraBold) | `#D05A28` | Kcal badge on meal tiles |
| *Button text* | 13 px | W800 (ExtraBold) | varies | Sheet buttons, primary actions |
| *AppBar title* | 16 px | W800 (ExtraBold) | `#16211D` | Navigation bar titles |

**Line heights**: Not explicitly defined in Dart code (default). In HTML: `line-height: 1.4–1.65` for body text, `line-height: 1.1` for numeric displays.

**RTL**: No RTL-specific font handling exists in code. The design HTML uses `direction: ltr` on English screens but has full Arabic screen variants in `screens_ar/`. The font stack `'Inter', 'Cairo', system-ui, sans-serif` is intended to handle both.

---

### Spacing & Layout

**Base unit**: 2 px / 4 px scale observed in code. Common values:

| Spacing | Used for |
|---|---|
| 2 px | Micro gaps between text lines |
| 3–4 px | Inner macro bar gaps, segmented control padding |
| 6–8 px | Between elements in rows, small gaps |
| 10–12 px | Between related elements, inner card padding (vertical/horizontal) |
| 14 px | Standard card padding, horizontal page margins |
| 16 px | Standard horizontal page margin (`EdgeInsets.fromLTRB(16, ...)`) |
| 18–24 px | Section spacing, bottom sheet padding, large gaps |

**Standard horizontal margin**: `16 px` (used consistently across all pages).

**Card padding**: `EdgeInsets.all(14)` or `EdgeInsets.symmetric(horizontal: 12, vertical: 10)`.

**Layout**: Single-column scrollable pages. No grid system or breakpoints defined.

#### Border Radius

| Radius | Token | Used for |
|---|---|---|
| 2 px | — | Macro progress bars, streak day dots |
| 4 px | — | Bar chart columns, small inner elements |
| 8–10 px | — | Segment buttons, streak icon bg, meal rows |
| 12 px | `--radius-sm: 12px` | Water log tiles, sheet buttons, search result emoji bg |
| 14 px | — | Cards, containers, preset buttons, text fields, quick add options |
| 16 px | `--radius-md: 16px` | Primary cards (calorie ring, streak, bar chart, macro stack) |
| 24 px | `--radius-lg: 24px` | Bottom sheets top corners, header bottom corners |
| 32 px | `--radius-xl: 32px` | Phone mockup bezel |
| 999 px | — | Fully rounded pills (calorie badge, chips) |

#### Shadows / Elevation

Not defined as a design token. Used inline:
- Segmented control active tab: `BoxShadow(color: black @6%, blurRadius: 4, offset: (0,1))`
- FAB: No shadow defined in code (Material handles default)
- Cards: Border-based (`Border.all(color: divider)`) — no elevation shadows
- HTML design: `box-shadow: 0 2px 14px rgba(45,107,62,0.08)` on spec panels, `0 3px 14px rgba(208,90,40,0.28)` on FAB

---

### Components

All values extracted from widget code:

#### 1. Cards (Primary)
- **Background**: `#FFFFFF` (surface)
- **Border**: 1 px solid `#D0CFC7` / `#E6ECE8` (divider)
- **Border radius**: 16 px (`BorderRadius.circular(16)`)
- **Padding**: 14 px all sides
- **Horizontal margin**: 16 px left/right
- **States**: None (static)

#### 2. Greeting Header
- **Background**: `#2E9E69` (primary) solid
- **Padding**: `EdgeInsets.fromLTRB(16, 16, 16, 12)`
- **Profile avatar**: 36×36 px circle, `#40FFFFFF` bg, white person icon 20 px
- **States**: None

#### 3. Meal Row
- **Background**: `#FFFFFF` (surface)
- **Border**: 1 px solid divider
- **Border radius**: 14 px
- **Padding**: `EdgeInsets.symmetric(horizontal: 12, vertical: 10)`
- **Horizontal margin**: 16 px left/right, 8 px bottom
- **Emoji**: 22 px font
- **Add button** (empty slot): 28×28 px circle, `#D05A28` bg, white `+` icon 16 px
- **Chevron** (logged): `Icons.chevron_right`, 18 px, `#5B6B65`

#### 4. Calorie Ring Card
- **Ring size**: 78×78 px
- **Ring stroke**: 6 px
- **Track color**: divider (`#D0CFC7`)
- **Progress color**: primary (`#2E9E69`)
- **Stroke cap**: Round
- **Percentage text**: 16 px, W800, primary color

#### 5. Macro Bar (nested in ring card)
- **Progress bar**: `LinearProgressIndicator`, minHeight 4 px
- **Border radius**: 2 px (via `ClipRRect`)
- **Track color**: divider
- **Fill color**: primary

#### 6. Streak Card
- **Icon container**: 36×36 px, `#E08A0A` @15% opacity bg, 10 px radius
- **Streak icon**: `Icons.emoji_events_outlined`, 20 px, streak color
- **Day dots**: 22×22 px circle
- **Completed dot**: streak gold (`#E08A0A`), white checkmark 14 px
- **Empty dot**: divider color
- **Today border**: 2 px solid primary
- **Day label text**: 10 px, W600, textSecondary

#### 7. Water Quick Tile
- **Background**: hydration blue @10% opacity
- **Border**: hydration blue @30% opacity, 1 px
- **Border radius**: 14 px
- **Padding**: 12 px all sides
- **Icon**: `Icons.water_drop_outlined`, 22 px, hydration blue
- **Progress bar**: 4 px height, hydration fill, 25% opacity track
- **Add button**: 28×28 px circle, hydration blue bg, white `+` 16 px

#### 8. Water Preset Button
- **Padding**: vertical 14 px
- **Border radius**: 14 px
- **Default**: white bg, divider border 1 px
- **Selected**: hydration @10% bg, hydration border 1.5 px
- **Icon**: 22 px, hydration color
- **Label**: 12 px W800 textPrimary
- **Sublabel**: 10 px textSecondary

#### 9. Water Log Tile
- **Border radius**: 12 px
- **Padding**: horizontal 12, vertical 10
- **Time**: 64 px wide, 11 px W700 textSecondary
- **Amount**: 12 px W700 textPrimary
- **Edit icon**: `Icons.edit_outlined`, 18 px, textSecondary
- **Delete icon**: `Icons.delete_outline`, 18 px, ctaFood

#### 10. Water Progress Ring
- **Size**: 180×180 px
- **Stroke**: 12 px
- **Track**: hydration @18% opacity
- **Progress**: hydration solid
- **Stroke cap**: Round
- **Center value**: 30 px W900 hydration
- **Subtext**: "From 2.4L", 12 px textSecondary

#### 11. Meal Search Tile
- **Emoji container**: 44×44 px, bg `#FAFAF8`, border divider, radius 12 px
- **Meal name**: 14 px W800 textPrimary
- **Serving**: 11 px textSecondary
- **Calorie badge**: pill shape (borderRadius 999), bg ctaFood @12%, text 11 px W800 ctaFood, padding horizontal 10 vertical 6
- **Padding**: horizontal 16, vertical 12

#### 12. Search TextField
- **Fill**: `#FFFFFF` (surface)
- **Border radius**: 14 px
- **Default border**: divider `#D0CFC7`
- **Focused border**: primary `#2E9E69`
- **Hint text**: 12 px textSecondary
- **Prefix icon**: `Icons.search`, textSecondary
- **Suffix icon**: `Icons.close` (clear button), textSecondary
- **Content padding**: horizontal 12

#### 13. Bottom Sheet (Quick Add / Custom Water)
- **Background**: `#FFFFFF`
- **Top corners**: 24 px radius
- **Padding**: `EdgeInsets.fromLTRB(16, 12, 16, 24)`
- **Drag handle**: 36×4 px, divider bg, radius 2 px
- **Title**: 15 px W800 textPrimary

#### 14. Quick Add Option
- **Padding**: horizontal 12, vertical 12
- **Border radius**: 14 px
- **Default**: `#FAFAF8` bg, divider border
- **Filled (CTA)**: `#D05A28` bg, ctaFood border, white text
- **Title**: 13 px W800
- **Subtitle**: 11 px
- **Icon/emoji**: 22 px

#### 15. Segmented Control (Period)
- **Background**: divider color
- **Border radius**: 12 px
- **Padding**: 4 px all sides
- **Active segment**: white bg, 8 px radius, subtle shadow
- **Inactive**: transparent
- **Label**: 12 px W700, active = primary, inactive = textSecondary

#### 16. Bar Chart Column
- **Bar width**: 3 px horizontal margin
- **Max height**: 80 px + offset
- **Filled color**: primary (emphasized) or primary @45% (dim)
- **Empty**: divider color
- **Border radius**: 4 px
- **Value label**: 9 px W600 textSecondary
- **Day label**: 10 px W600 textSecondary
- **Animation**: `AnimatedContainer`, 300 ms, easeOut

#### 17. Macro Stack Bar
- **Bar height**: 8 px
- **Border radius**: 4 px (`ClipRRECT`)
- **Colors**: [`#2E9E69` (primary), `#256F50` (secondary), `#E08A0A` (streak)]
- **Legend dot**: 8×8 px, radius 2 px
- **Legend text**: 10 px textSecondary

#### 18. Weight Trend Card
- **Chart height**: 36 px
- **Line stroke**: 2 px, primary color, round cap
- **End dot**: 3 px radius, primary
- **Delta indicator**: ▼ loss (`#256F50`), ▲ gain (`#D05A28`), 11 px W700

#### 19. Feature Placeholder Page
- **AppBar**: title only
- **Body padding**: 24 px all sides
- **Title**: `titleLarge` style
- **Description**: `bodyMedium` style
- **Gap**: 12 px between title and description

#### 20. Primary Button (HTML design)
- **Background**: `#2E9E69`
- **Color**: white
- **Border radius**: 12–16 px
- **Padding**: 10–12 px vertical
- **Font**: 11–13 px, W700–W800
- **Shadow** (CTA variants): `0 4px 14px rgba(46,158,105,0.3)`

#### 21. Secondary/Outline Button
- **Background**: white surface
- **Border**: 1.5 px divider or secondary
- **Border radius**: 12 px
- **Height**: 44 px
- **Text**: 13 px W800
- **Filled variant**: `#256F50` bg, white text

#### 22. IconButton
- **Icon size**: 18 px (delete, edit), 20 px (profile), 22 px (water icon)
- **Visual density**: `VisualDensity.compact`

#### 23. Chips (from HTML design)
- **Border radius**: 999 px (pill)
- **Padding**: 6–10 px horizontal, 6 px vertical
- **Default**: white bg, divider border, 8 px text
- **Active**: `#E8F5ED` bg, primary border, W700 text

#### 24. Toggle (from HTML design)
- **Width**: 40 px, **Height**: 22 px
- **Border radius**: 999 px
- **On**: `#2780C5` (secondary/hydration)
- **Off**: `#D8D6CE`
- **Knob**: 18×18 px white circle, shadow
- **Transition**: left position animates

---

### Icons

- **Library**: **Material Icons** (`Icons.*` from `material_design_icons_flutter`) — outlined style preferred
- **Common icons used**: `search`, `close`, `arrow_back`, `add`, `chevron_right`, `person`, `water_drop_outlined`, `local_drink_outlined`, `edit_outlined`, `delete_outline`, `emoji_events_outlined`, `home_outlined`, `show_chart`, `restaurant_menu`, `search_off`, `error_outline`
- **Emoji**: Used extensively for food (🍚, 🫘, 🌯, 🧆, 🥬, 🍗, 🍆, 🥙, ☀️, 🌤️, 🌙), water (💧), actions (📸, 📝), weight (▼/▲)
- **Icon sizing standard**: 18–22 px for UI actions, 36 px for empty states, 16 px for inline
- **HTML design**: Uses **Lucide icons** (thin stroke, 1.05em default, 15–24 px variants) — but the live Flutter app uses Material Icons

---

## 2. App Details

**App name**: **Afia** (derived from Arabic "عافية" = wellness/health)

**One-line purpose**: Health & nutrition tracking app for the Egyptian/Middle Eastern market — log meals, track water, view progress, and get AI-powered food insights.

**Target platforms**: iOS + Android (Flutter project). No web or desktop targets configured.

**Minimum screen size**: Not defined. Phone mockup in design is 200×390 px. Layout uses single-column scrollable pages, suggesting phone-first.

**Target persona**: Health-conscious Arabic/English speaking users in Egypt/MENA region who eat traditional Egyptian foods (koshary, falafel, molokhia, mahshi, ta'ameya). The mock data uses name "Ahmed".

---

### Full Screen / Flow List

From `design/screens_en/` directory (92 entries):

| # | Screen | Status in code |
|---|---|---|
| 01 | **Select Language** (EN/AR) | ❌ Stub |
| 02 | **Register an account** | ❌ Stub |
| 03 | **Log in** | ❌ Stub |
| 04 | **Onboarding 1/6** — Features intro | ❌ Stub |
| 05 | **Onboarding 2/6** | ❌ Stub |
| 05a | **Onboarding 3/6** | ❌ Stub |
| 05b | **Onboarding 4/6** | ❌ Stub |
| 05c | **Onboarding 5/6** | ❌ Stub |
| 05d | **Onboarding 6/6** | ❌ Stub |
| 06 | **Select target** (weight goal) | ❌ Stub |
| 06b | **Name entry** | ❌ Stub |
| 06c | **Age & Gender** | ❌ Stub |
| 06d | **Height & Weight** | ❌ Stub |
| 06e | **Activity level** | ❌ Stub |
| 07 | **Home / Daily streak** (Dashboard) | ✅ Built (mock data) |
| 07b | **Quick add sheet** (bottom sheet) | ✅ Built |
| 08 | **Eating recording / Meal search** | ✅ Built (search), ❌ (logging stub) |
| 09 | **Progress** (Week/Month/Year) | ✅ Built (mock data) |
| 13 | **Meal log** (edit/clear) | ❌ Not built |
| 14 | **Edit a saved meal** | ❌ Not built |
| 15 | **Manual recording** | ❌ Not built |
| 16 | **Confirm AI result** | ❌ Not built |
| 16a | **Image analysis loading** | ❌ Not built |
| 16b | **Image parsing failed / Retry** | ❌ Not built |
| 17 | **Water recording** | ✅ Built |
| 18 | **Custom water amount** | ✅ Built |
| 19 | **Recipe converter** | ❌ Not built |
| 19a | **Recipe converter loading** | ❌ Not built |
| 19b | **Recipe converter error / Retry** | ❌ Not built |
| 20 | **Snacks suggestion** | ❌ Not built |
| 20a | **Snacks loading** | ❌ Not built |
| 20b | **Snacks error / Retry** | ❌ Not built |
| 21 | **Personal data / Confirm plan update** | ❌ Not built |
| 22 | **Explore** (catalog) | ❌ Stub |
| 22b | **Meal catalog** (browsable list) | ❌ Not built |
| 22d | **Explore Snacks** | ❌ Not built |
| 22e | **Explore High protein** | ❌ Not built |
| 22f | **Explore Low calories** | ❌ Not built |
| 23 | **Meal detail** (recipe + registration) | ❌ Not built |
| 24 | **My Account / File Center** (profile) | ❌ Stub |
| 24a | **Alerts** | ❌ Not built |
| 24b | **Language** (Arabic/English) | ❌ Not built |
| 24c | **Privacy & Security** | ❌ Not built |
| 24d | **Log out confirm** | ❌ Not built |
| 24e | **Goal & Calories** | ❌ Not built |
| 24f | **Help & About** | ❌ Not built |

---

### Core User Flows

1. **Auth** → Language selection → Onboard (6 feature screens) → Set goal → Enter name → Enter age/gender → Enter height/weight → Select activity level → **Home Dashboard**

2. **Log a meal** → Tap FAB (+) → Quick add sheet → "Manual recording" → Search meals → Select meal from catalog → Confirm → Back to home with meal logged

3. **Log a meal via AI** → Tap FAB (+) → "Film your food" → Take photo → AI analyzes (loading state) → Confirm/Edit result → Logged

4. **Log water** → Tap FAB (+) → "Record water" → Water page → Tap preset (cup/pint/custom) or enter custom amount → Entry appears in log → Back to home

5. **View progress** → Home dashboard (calorie ring, streak, meals, water quick tile) → Tap Progress tab → Switch between Week/Month/Year → View bar chart, macros, weight trend, water

6. **Explore catalog** → Explore screen → Browse categories (All, Snacks, High Protein, Low Calories) → Tap meal → Meal detail page (calories, macros, serving, recipe) → Log meal

7. **Account settings** → Account screen → Edit profile / Language / Alerts / Goals / Privacy / Help → Logout

---

### RTL / Localization

- **Supported languages**: English (`en`), Arabic (`ar`) — defined in `AppLocales.supported`
- **Arabic is a primary target**: The `design/` directory has **full Arabic screen variants** (46 folders with Arabic names matching the 92 English screens)
- **Current state**: No actual translation strings exist. `LocaleCubit` is an empty stub. The app always launches in LTR mode.
- **Font handling**: The HTML design uses `Inter` for English and `Cairo` for Arabic. The Flutter code has **no font configuration** for Arabic yet.
- **Material 3**: `useMaterial3: true` — M3 has built-in RTL support, but no `Directionality` or locale wiring is done yet.

---

### Brand Assets

| Asset | Location | Status |
|---|---|---|
| App icon / Logo | Not in repo | Not defined — no `assets/` directory, no `icons/` |
| Splash screen | Not in repo | Not defined |
| Screen design PNGs | `design/screens_en/` (46+ folders) | ✅ Exists — each folder has `screen.html` + `screen.png` |
| Arabic screen PNGs | `design/screens_ar/` (46 folders) | ✅ Exists |
| Reference design HTML | `design/progemini_en.html` | ✅ Comprehensive interactive spec with all CSS variables |
| System analysis docs | `system_analysis/Afia - DEPI/` | ✅ Has SRS PDF, use case diagram, class diagram, DFD, sequence, activity, state, context diagrams |
| Play store reviews pipeline | `play_reviews_pipeline/` | ✅ Python pipeline for scraping/analyzing app reviews |

---

## 3. Existing Figma Setup

**No Figma files exist** in the repository. No `.fig` files, no `.figjam` files, no links.

The design work lives as:
- **HTML/CSS mockups** (`progemini_en.html`) — a comprehensive interactive prototype with all screens, colors, typography, and spacing defined in CSS custom properties
- **Static PNG screenshots** in `design/screens_en/` and `design/screens_ar/` — one PNG per screen per language

There is no established Figma component library, style guide, or page/frame naming convention. The `screen.html` files embed the designs inline (no external tool chain).

---

### Notable Design Tensions / Ambiguities to Flag

1. **Color mismatch**: The Dart `AppColors` and the HTML `progemini_en.html` disagree on `textSecondary` (`#5B6B65` vs `#888680`) and `divider` (`#E6ECE8` vs `#D0CFC7`). The designer should pick one canonical palette.
2. **No dark mode**: Only light mode is defined. If Arabic/AMOLED usage is expected, dark mode should be planned.
3. **Fonts not wired**: The code uses default Flutter fonts but the design uses `Inter` + `Cairo` — these need to be added to `pubspec.yaml` and `AppTheme`.
4. **Missing icon assets**: No logo, splash, or app icon anywhere in the repo.
5. **Icon library mismatch**: HTML uses Lucide, code uses Material Icons — decide which to standardize on.
