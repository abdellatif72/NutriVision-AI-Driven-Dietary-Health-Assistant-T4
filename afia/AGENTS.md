# Afia — AI Agent Context File

> Read this file before writing any code. It contains everything you need to understand the project, its conventions, current status, and what to do next. Do not ask clarifying questions covered here.

---

## 1. What Is Afia?

Afia is a **Flutter-based nutrition and wellness mobile app** targeting **Arabic-speaking users**. It helps users track daily calorie intake, water consumption, meal logs, and health metrics (steps, heart rate, weight trends). It also includes an AI assistant for recipe/meal parsing and an explore section for food catalog browsing.

- **Platform**: Flutter (Android + iOS)
- **Target users**: Arabic-speaking adults
- **Language/RTL**: Arabic primary, RTL layout (localization infrastructure exists but is not wired yet)
- **Project type**: Graduation project (team of 4)
- **Current stage**: UI shell + mock data complete. Backend and data layer not yet started.

---

## 2. Architecture

### Pattern
**Feature-First Clean Architecture** with three layers per feature:

```
Presentation  →  Domain  →  Data
(UI / Bloc)      (Entities,   (Models, DataSources,
                 UseCases,    Repository Impls)
                 Repo Interfaces)
```

### Folder Structure

```
lib/
├── app/
│   ├── app.dart                        # Root MaterialApp widget
│   ├── di/
│   │   └── injection_container.dart    # DI setup (currently empty)
│   ├── localization/
│   │   ├── l10n.dart
│   │   └── locale_cubit.dart
│   └── router/
│       ├── app_router.dart             # onGenerateRoute switch/case
│       └── route_names.dart            # All named route strings
├── core/
│   ├── constants/app_constants.dart
│   ├── error/
│   │   ├── exceptions.dart             # ServerException, CacheException
│   │   └── failures.dart              # Failure, ServerFailure, CacheFailure
│   ├── network/
│   │   ├── api_client.dart             # STUB — not implemented
│   │   └── network_info.dart           # STUB — not implemented
│   ├── services/
│   │   ├── auth_service.dart           # STUB
│   │   ├── ai_service.dart             # STUB
│   │   └── analytics_service.dart      # STUB
│   ├── storage/
│   │   ├── local_storage.dart          # STUB
│   │   └── secure_storage.dart         # STUB
│   ├── theme/
│   │   ├── afia_colors.dart
│   │   ├── afia_typography.dart
│   │   ├── afia_spacing.dart
│   │   └── afia_theme.dart
│   ├── utils/app_logger.dart
│   └── widgets/                        # Shared reusable widgets
│       ├── feature_placeholder_page.dart
│       ├── afia_bar_chart_card.dart
│       ├── afia_metric_stat_card.dart
│       ├── afia_mini_metric_card.dart
│       ├── afia_week_calendar.dart
│       └── afia_weekly_progress_card.dart
└── features/
    ├── auth/
    ├── onboard/
    ├── main/
    ├── meals/
    ├── water/
    ├── ai/
    ├── explore/
    └── more/
```

### Single Feature Structure (use `meals` as reference)

```
features/meals/
├── data/
│   ├── datasources/
│   │   ├── meal_remote_datasource.dart
│   │   └── meal_local_datasource.dart
│   ├── models/
│   │   └── meal_model.dart             # extends / maps entity
│   └── repositories/
│       └── meal_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── meal_summary.dart           # Pure Dart, Equatable
│   ├── repositories/
│   │   └── meal_repository.dart        # Abstract interface
│   └── usecases/
│       └── search_meals.dart
└── presentation/
    ├── bloc/                           # or cubit/
    │   ├── meal_search_bloc.dart
    │   ├── meal_search_event.dart
    │   └── meal_search_state.dart
    ├── pages/
    │   └── meal_search_page.dart
    └── widgets/
        └── meal_search_tile.dart
```

---

## 3. Naming Conventions

| Item | Convention | Example |
|------|-----------|---------|
| Files | `snake_case.dart` | `meal_search_bloc.dart` |
| Classes | `PascalCase` | `MealSearchBloc` |
| Blocs | `{Feature}{Action}Bloc` | `AuthBloc`, `MealSearchBloc` |
| Cubits | `{Feature}Cubit` | `WaterRecordingCubit`, `HomeCubit` |
| Events | `PascalCase` (no "Event" suffix) | `QueryChanged`, `ResultSelected` |
| States | `{Feature}State` | `WaterRecordingState` |
| Pages | `{Feature}Page` | `AuthPage`, `HomePage` |
| Widgets | Descriptive PascalCase | `WaterPresetButton`, `AfiaBarChartCard` |
| Private view classes | `_{Name}View` | `_HomeView`, `_MainShellView` |
| Design system classes | `Afia{Name}` | `AfiaColors`, `AfiaSpacing` |

---

## 4. State Management

- **Library**: `flutter_bloc ^8.1.6` (both Bloc and Cubit)
- **Use Cubit** for simple, linear state (water recording, tab selection, locale)
- **Use Bloc** for event-driven flows (meal search, auth)
- **Equatable** is used on all state and entity classes
- **bloc_concurrency** is available for `droppable()` / `restartable()` transformers

---

## 5. Routing

**Pattern**: Manual `onGenerateRoute` switch/case (no `go_router`)

**Route names** (`lib/app/router/route_names.dart`):

```dart
abstract final class RouteNames {
  static const auth       = '/auth';
  static const onboard    = '/onboard';
  static const main       = '/main';
  static const meals      = '/meals';
  static const mealSearch = '/meals/search';
  static const water      = '/water';
  static const ai         = '/ai';
  static const explore    = '/explore';
  static const more       = '/more';
  static const profile    = '/more/profile';
  static const goals      = '/more/goals';
  static const progress   = '/more/progress';
  static const reminders  = '/more/reminders';
  static const settings   = '/more/settings';
  static const helpSupport = '/more/help-support';
}
```

**Initial route**: `/main` (temporary — skips onboarding/auth; was `/onboard`)

**Navigation**: `Navigator.pushReplacementNamed()` or `Navigator.pushNamed()` — no deep linking yet.

---

## 6. Dependency Injection

**File**: `lib/app/di/injection_container.dart`

```dart
abstract final class InjectionContainer {
  static Future<void> init() async {
    // ← Register all blocs, cubits, repos, datasources, and services here
  }
}
```

**Status**: ⚠️ Empty — nothing is registered yet. When adding a feature's data layer, register all its components here.

No third-party DI package (like `get_it`) is installed yet. Choose and add one when starting the data layer.

---

## 7. Design System

### Colors (`lib/core/theme/afia_colors.dart`)

| Token | Hex | Usage |
|-------|-----|-------|
| `green500` / `primary` | `#7FBF2E` | Brand primary, FAB, progress ring, active bars |
| `green100` / `primaryContainer` | `#DFF0C4` | Weekly progress card bg, container fills |
| `green800` / `onPrimaryContainer` | `#3D6314` | Text on green containers |
| `onPrimary` | `#FFFFFF` | White text on primary |
| `orange` | `#FF8A3D` | Steps, calories, energy metrics |
| `orangeContainer` | `#FFEADB` | Icon chip backgrounds |
| `blue` | `#3DA5F4` | Water / hydration |
| `blueContainer` | `#E2F2FE` | Water icon backgrounds |
| `red` | `#FF5C5C` | Heart rate |
| `redContainer` | `#FFE3E3` | Heart rate icon backgrounds |
| `textPrimary` | `#1A1A1A` | Main headings and body |
| `textSecondary` | `#6B7280` | Labels, secondary text |
| `textMuted` | `#9CA3AF` | Captions, disabled states |
| `divider` | `#EFEFEF` | Divider lines |
| `trackInactive` | `#E7EAE2` | Unfilled progress bars |
| `scaffoldBackground` | `#F7F8F6` | Screen backgrounds |
| `surface` | `#FFFFFF` | Cards and surfaces |

### Typography (`lib/core/theme/afia_typography.dart`)

| Style | Size | Weight | Usage |
|-------|------|--------|-------|
| `statValue` | 34 | w800 | Hero numbers ("1250 Kcal") |
| `statValueCompact` | 24 | w800 | Compact hero numbers |
| `unit` | 14 | w500 | Unit labels ("Kcal", "steps") |
| `screenTitle` | 18 | w700 | Screen headers |
| `cardTitle` | 16 | w700 | Card / section titles |
| `label` | 13 | w500 | Eyebrow labels ("Daily intake") |
| `body` | 14 | w400 | General body text |
| `caption` | 11 | w600 | Bar % labels, weekday abbreviations |
| `greetingName` | 16 | w700 | User name in greeting header |

**Font**: `Plus Jakarta Sans` via `google_fonts`. Set in `main.dart`:
```dart
AfiaTypography.fontFamily = GoogleFonts.plusJakartaSans().fontFamily;
```

### Spacing (`lib/core/theme/afia_spacing.dart`)

| Token | px | Use |
|-------|----|-----|
| `xs` | 4 | Minimal gap |
| `sm` | 8 | Icon + label gap |
| `md` | 12 | Medium gap |
| `lg` | 16 | Card padding |
| `xl` | 20 | Section gap |
| `xxl` | 24 | Large section gap |
| `xxxl` | 32 | Extra large gap |
| `pageMargin` | 20 | Screen horizontal inset |
| `sectionGap` | 20 | Vertical gap between major sections |

### Border Radius

| Token | px | Use |
|-------|----|-----|
| `sm` | 12 | Small corners |
| `md` | 16 | Medium corners |
| `lg` | 20 | Large corners |
| `xl` | 24 | Card corners |
| `pill` | 999 | FAB, chips, avatars |

### Theme
- **Material 3 enabled** (`useMaterial3: true`)
- **AppBar**: Transparent, center title
- **Cards**: White, 22px radius, no elevation
- **Buttons**: Green primary, pill shape
- **Bottom Nav**: Fixed type, Material 3

---

## 8. Key Files

| Concern | Path |
|---------|------|
| Entry point | `lib/main.dart` |
| Root widget | `lib/app/app.dart` |
| Router | `lib/app/router/app_router.dart` |
| Route names | `lib/app/router/route_names.dart` |
| DI container | `lib/app/di/injection_container.dart` |
| Theme assembly | `lib/core/theme/afia_theme.dart` |
| Colors | `lib/core/theme/afia_colors.dart` |
| Typography | `lib/core/theme/afia_typography.dart` |
| Spacing | `lib/core/theme/afia_spacing.dart` |
| Error types | `lib/core/error/exceptions.dart`, `failures.dart` |
| Shared widgets | `lib/core/widgets/` |
| Constants | `lib/core/constants/app_constants.dart` |
| Logger | `lib/core/utils/app_logger.dart` |

---

## 9. Feature Status

### ✅ Done

| Feature | What exists |
|---------|------------|
| **Design system** | Colors, typography, spacing, theme — all token files complete |
| **Routing** | All 9 named routes defined and wired |
| **Onboarding** | Logo, hero text, CTAs, navigates to auth |
| **Home dashboard** | Metrics (steps, water, heart rate), calories ring, daily progress, meals list — all with mock data |
| **Progress page** | Calories bar chart, water bar chart, macro breakdown, weight trend, weekly/monthly/yearly toggle — mock data. Charts use design system tokens. |
| **Main shell** | Simplified — renders `HomePage` directly. Removed duplicate bottom nav (`_MainBottomNav`). |
| **Water logging** | Preset buttons (250ml, 500ml, custom), progress ring, entry list — mock data via `WaterRecordingCubit` |
| **Meal search UI** | Search TextField, `MealSearchBloc`, result tiles, mock results |
| **More / profile flow** | More hub, profile entry, goals, progress, reminders, connected apps, help/support, logout flow |
| **Settings screen** | Dedicated settings page with preferences, account, and about sections |
| **Shared widgets** | `AfiaBarChartCard`, `AfiaMetricStatCard`, `AfiaMiniMetricCard`, `AfiaWeekCalendar`, `AfiaWeeklyProgressCard` |
| **Domain entity** | `MealSummary` (id, name, emoji, calories, serving) |
| **Error infrastructure** | `Failure`, `ServerFailure`, `CacheFailure`, `ServerException`, `CacheException` |

### ⚠️ Partial

| Feature | What's missing |
|---------|---------------|
| **Meals** | Main meals listing page is placeholder. No data layer, repository, or use cases |
| **Localization** | Infrastructure files exist (`l10n.dart`, `locale_cubit.dart`) but no translations and no l10n package added |
| **More screen internals** | The destination pages are UI-only mock screens; they are routed but not backed by state or data |

### ❌ Not Started

| Feature | Notes |
|---------|-------|
| **Auth** | `AuthBloc` is empty stub. Page shows placeholder. No login/register UI |
| **AI** | Feature folder exists, page is placeholder. No logic |
| **Explore** | Feature folder exists, page is placeholder |
| **Firebase** | Not added — no packages, no `google-services.json`, no init code |
| **Data layer** | No datasources, no model classes, no repository implementations anywhere |
| **DI wiring** | `InjectionContainer.init()` is empty |
| **Real API integration** | No HTTP client added, no API keys, no env config |
| **Dark theme** | Not implemented |
| **Push notifications** | Not implemented |
| **Tests** | Only one basic widget test. No unit or integration tests |

---

## 10. Backend Plan (Intended — Not Yet Implemented)

- **Auth**: Firebase Authentication (email/password + Google Sign-In)
- **Database**: Firestore
- **Storage**: Firebase Storage (meal photos, profile pictures)
- **Nutrition API**: Layered — USDA FoodData Central (primary), Nutritionix (Arabic/branded foods), Open Food Facts (fallback)
- **AI feature**: Anthropic Claude API or Gemini for recipe parsing and meal suggestions
- **HTTP client**: `dio` (to be added)
- **Local storage**: `hive` or `shared_preferences` (to be decided)
- **DI**: `get_it` + `injectable` (to be decided)

---

## 11. What to Do Before Writing Code

1. **Check feature status above** before assuming anything exists.
2. **Follow the feature folder structure** exactly as shown in section 2.
3. **Use existing design tokens** — never hardcode colors, font sizes, or spacing values.
4. **Use `FeaturePlaceholderPage`** as a temporary UI for any screen not yet implemented.
5. **Wire new blocs/cubits into `InjectionContainer.init()`** once the data layer exists.
6. **Register new routes** in both `route_names.dart` and `app_router.dart`.
7. **Do not add packages** without confirming they belong in `pubspec.yaml` (several stubs assume packages not yet installed).
8. **Mock data** lives inside cubits/blocs for now — real data sources will replace it once the data layer is built.
