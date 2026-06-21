# Afia Design System 

## Color tokens

| Token | Hex | Used for |
|---|---|---|
| `green500` (primary) | `#7FBF2E` | FAB, progress ring, peak bar, selected states |
| `green100` (primaryContainer) | `#DFF0C4` | Weekly progress hero card background |
| `orange` | `#FF8A3D` | steps / calories icon chips |
| `blue` | `#3DA5F4` | water icon chip |
| `red` | `#FF5C5C` | heart-rate icon + sparkline |
| `textPrimary` | `#1A1A1A` | headings, big numbers |
| `textSecondary` | `#6B7280` | labels, eyebrow text |
| `textMuted` | `#9CA3AF` | unselected nav, captions |
| `scaffoldBackground` | `#F7F8F6` | screen background |
| `surface` | `#FFFFFF` | cards |

Each accent has a paired pale "container" color for icon-chip
backgrounds (`orangeContainer`, `blueContainer`, `redContainer`) — see
`AfiaColors.accentFor(AfiaMetricKind)` to fetch the right pair from
data instead of hardcoding per screen.

**Not yet defined:** a dark theme. The reference is light-only; if
Afia needs dark mode, mirror the same token names with adjusted
values rather than inventing a parallel system.

## Typography

The reference's bold, rounded numerals don't map to a default system
font particularly well. `AfiaTypography.fontFamily` is left `null`
(platform default) so the file compiles standalone — wire up a
rounded geometric font via `google_fonts` for a closer match:

```dart
import 'package:google_fonts/google_fonts.dart';
AfiaTypography.fontFamily = GoogleFonts.plusJakartaSans().fontFamily;
```

Good candidates: **Plus Jakarta Sans**, **Sora**, or **Lexend** — all
have the rounded-but-geometric, heavy-weight numeral style seen in
"1250", "5,500", "86".

| Style | Size / weight | Example |
|---|---|---|
| `statValue` | 34 / w800 | "1250" |
| `statValueCompact` | 24 / w800 | "6", "86" |
| `screenTitle` | 18 / w700 | "Statistic" |
| `cardTitle` | 16 / w700 | "Calories", "Breakfast" |
| `label` | 13 / w500 | "Step to walk" |
| `body` | 14 / w400 | greeting text |
| `caption` | 11 / w600 | bar chart "%", weekday letters |

## Spacing & radius

8px-ish grid: `4, 8, 12, 16, 20, 24, 32`. Cards round at **22-24px**;
icon chips and the FAB are full circles. Page content sits at a
**20px** horizontal margin.

## Components — what they map to in the reference

- **AfiaMetricStatCard** — the two-up "Step to walk" / "Drink Water" cards.
- **AfiaWeeklyProgressCard** — the big light-green card with the circular "6 days" ring.
- **AfiaWeekCalendar** — the "August 2025" week strip with the highlighted Wed.
- **AfiaBottomNav** — bottom tab bar with the raised center FAB (expand icon).
- **AfiaMealTile** — Breakfast / Lunch rows with thumbnail + add button.
- **AfiaWeeklyBarChartCard** — the Calories card's 7-day bar chart with per-bar percentages and a highlighted peak day. Built with plain `Container`s (no chart dependency) since it's a fixed 7-bar layout — swap to `fl_chart` only if you need tooltips/scrubbing later.
- **AfiaMiniMetricCard** + **AfiaSparkline** — Exercise / BPM / Weight / Water cards, with an optional sparkline slot (used for BPM in the reference).

## Known gaps / next steps

- No dark theme tokens yet.
- Bottom nav icons are Material icons as placeholders — swap for Afia's actual icon set once finalized.
- The bar chart card assumes exactly 7 days; generalize if you need variable-length ranges.
- Font is unset by default — pick and wire up the actual brand font before shipping.
