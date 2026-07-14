# Afia — AI Agent Context File

> Read this file before writing any code. It contains everything you need to understand the project, its conventions, current status, and what to do next. Do not ask clarifying questions covered here.

---

## 1. What Is Afia?

Afia is a **Flutter-based nutrition and wellness mobile app** targeting **Arabic-speaking users**. It helps users track daily calorie intake, water consumption, meal logs, and health metrics (steps, heart rate, weight trends). It also includes an AI assistant for recipe/meal parsing and an explore section for food catalog browsing.

- **Platform**: Flutter (Android + iOS)
- **Target users**: Arabic-speaking adults
- **Language/RTL**: Arabic primary, RTL layout (localization infrastructure exists but is not wired yet)
- **Project type**: Graduation project (team of 4)
- **Current stage**: Most features fully implemented with real Supabase backend. Auth, Meals, Water, Explore, AI Chat, Home dashboard, Progress page — all wired to real data. Localization infrastructure wired (ARB files added). Reminders feature removed from scope.

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

### Feature Structure: `ai`

```
features/ai/
├── data/
│   ├── datasources/
│   │   └── ai_remote_datasource.dart    # Abstract & Impl for Gemini REST
│   ├── models/
│   │   ├── ai_chat_message_model.dart
│   │   └── plate_analysis_result_model.dart
│   └── repositories/
│       └── ai_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── ai_chat_message.dart
│   │   └── plate_analysis_result.dart
│   ├── repositories/
│   │   └── ai_repository.dart
│   └── usecases/
│       ├── get_chat_response.dart
│       └── analyze_plate.dart
└── presentation/
    ├── bloc/
    │   ├── ai_bloc.dart
    │   ├── ai_event.dart
    │   └── ai_state.dart
    └── pages/
        └── ai_page.dart
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

**Route names** (`lib/app/router/route_names.dart`) — 31 routes:

```dart
abstract final class RouteNames {
  // Auth
  static const auth                  = '/auth';
  static const authLogin             = '/auth/login';
  static const authSignup            = '/auth/signup';
  static const authPhysicalInformation = '/auth/physical-information';
  static const authGoalSelection     = '/auth/goal-selection';
  static const authForgotPassword    = '/auth/forgot-password';
  // Onboard
  static const onboard               = '/onboard';
  // Main
  static const main                  = '/main';
  // Meals
  static const meals                 = '/meals';
  static const mealSearch            = '/meals/search';
  // Water
  static const water                 = '/water';
  // AI
  static const ai                    = '/ai';
  // Explore
  static const explore               = '/explore';
  // More
  static const more                  = '/more';
  static const profile               = '/more/profile';
  static const editProfile           = '/more/profile/edit';
  static const personalInformation   = '/more/personal-information';
  static const dietPreferences       = '/more/diet-preferences';
  static const goals                 = '/more/goals';
  static const progress              = '/more/progress';
  static const reminders             = '/more/reminders';
  static const notifications         = '/more/notifications';
  static const connectedApps         = '/more/connected-apps';
  static const settings              = '/more/settings';
  static const changePassword        = '/more/change-password';
  static const helpSupport           = '/more/help-support';
  static const faqs                  = '/more/faqs';
  static const help                  = '/more/help';
  static const about                 = '/more/about';
}
```

**Initial route**: `/onboard` (set in `app_router.dart:31`)

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

**Status**: ⚠️ Partially complete. `get_it` and `injectable` are installed. Currently, only the **Auth** feature is registered (manually). As we build out the remaining data layers (Meals, Water, Explore, More), we need to transition to using `@injectable` annotations and `build_runner` to auto-generate the DI graph.

**Packages already in pubspec.yaml**: `google_fonts ^6.2.1`, `flutter_bloc ^8.1.6`, `equatable ^2.0.5`, `bloc_concurrency ^0.2.5`, `stream_transform ^2.1.0`, `shared_preferences ^2.5.5`, `image_picker ^1.2.3`, `speech_to_text ^7.4.0`, `dartz ^0.10.1`, `dio`, `get_it`, `injectable`, `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`, `firebase_crashlytics`, `intl`, `flutter_localizations`, `connectivity_plus`, `flutter_secure_storage`, `google_sign_in`, `sign_in_with_apple`. Dev: `flutter_lints ^6.0.0`, `flutter_launcher_icons ^0.13.1`, `mocktail ^1.0.4`, `injectable_generator`, `build_runner`.

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
| **Routing** | All 31 named routes defined and wired |
| **Onboarding** | Logo, hero text, CTAs, navigates to auth. Full `OnboardBloc`, 4 widget files |
| **Home dashboard** | Metrics (steps, water, heart rate), calories ring, daily progress wired to real Supabase data. `DailyProgressCard` shows real calorie %. Meal rows now tappable — open `MealCategoryDetailPage`. |
| **Progress page** | Wired to `weight_history` and `daily_metrics` from Supabase. |
| **Main shell** | `MainShellPage` with `MainShellCubit` and `AfiaBottomNav` (5 tabs: home, meals, water, ai, more) |
| **Water logging** | Full data layer wired to Supabase. `WaterRecordingCubit` reads/writes real data. |
| **Meals** | Full data layer (`MealModel`, `MealRemoteDataSource`, `MealRepositoryImpl`). UI wired via `MealsCubit`. Add/delete meals persisted to Supabase. `MealCategoryDetailPage` shows per-slot meal lists with macros. |
| **AI Chat** | Gemini API integrated (`AiBloc`, `AiService`). Snap Your Plate (image recognition). AI confirmation bottom sheet. Logic moved out of `ai_page.dart` into proper Clean Architecture layers. |
| **Explore** | `ExploreBloc` implemented and connected to Nutritionix/USDA APIs. |
| **More / profile** | Most complete feature. Full data + domain + presentation layers. Supabase + SharedPreferences. |
| **Localization** | `flutter_localizations` wired. `app_en.arb` and `app_ar.arb` added. RTL audit done. |
| **DI wiring** | Auth, Meals, Water, Explore, More, AI — all registered in `InjectionContainer`. |
| **Shared widgets** | `AfiaBarChartCard`, `AfiaMetricStatCard`, `AfiaMiniMetricCard`, `AfiaWeekCalendar`, `AfiaWeeklyProgressCard`, `AfiaEmptyState`, `AfiaErrorState` |
| **Error infrastructure** | `Failure`, `ServerFailure`, `CacheFailure`, `ServerException`, `CacheException` |
| **Auth** | Fully implemented. Firebase + Supabase. All screens wired. |

### ⚠️ Partial

| Feature | What's remaining |
|---------|------------------|
| **Steps / Health** | Steps metric on home still shows 0. No Apple Health / Google Fit integration yet. |
| **Dark theme** | Not implemented |
| **Push notifications** | Not implemented |

### ❌ Not Started

| Feature | Notes |
|---------|-------|
| **Health Package** | Sync steps/heart rate from Apple Health/Google Fit to `daily_metrics`. |

### 🔧 Known Issues / Risks

None outstanding.

---

## 10. Backend Plan (Intended — Not Yet Implemented)

- **Auth**: Firebase Authentication (email/password + Google Sign-In)
- **Database**: Firestore
- **Storage**: Firebase Storage (meal photos, profile pictures)
- **Nutrition API**: Layered — USDA FoodData Central (primary), Nutritionix (Arabic/branded foods), Open Food Facts (fallback)
- **AI feature**: Anthropic Claude API or Gemini for recipe parsing and meal suggestions
- **HTTP client**: `dio` (to be added)
- **Local storage**: `shared_preferences` ^2.5.5 (already added, used by AI page). `hive` (not added).
- **DI**: `get_it` + `injectable` (to be decided)

---

## 11. What to Do Before Writing Code

1. **Check feature status above** before assuming anything exists.
2. **Follow the feature folder structure** exactly as shown in section 2.
3. **Use existing design tokens** — never hardcode colors, font sizes, or spacing values.
4. **Use `FeaturePlaceholderPage`** as a temporary UI for any screen not yet implemented.
5. **Wire new blocs/cubits into `InjectionContainer.init()`** once the data layer exists.
6. **Register new routes** in both `route_names.dart` and `app_router.dart`.
7. **Do not add packages** without confirming they belong in `pubspec.yaml`.
8. **Reminders feature has been removed** from the app — do not add it back.


---

## What's Next to Work On

> Last updated: 2026-07-14. Final sprint — Day 3 remaining tasks.

### 🔴 Day 1 — Core Data Layers & Backend Integrations ✅ ALL DONE

| Assignee | Task | Notes |
|----------|------|-------|
| **Abdellatif** | ✅ Supabase Setup | DONE |
| **Abdellatif** | ✅ API Configuration | DONE |
| **Abdellatif** | ✅ Dio Client | DONE |
| **Abdellatif** | ✅ BMR Logic | DONE |
| **Yusuf** | ✅ Gemini Text API | DONE |
| **Yusuf** | ✅ "Snap Your Plate" | DONE |
| **Yusuf** | ✅ AI UI Refactoring | DONE |
| **Mario** | ✅ Meals Data Layer | DONE |
| **Mario** | ✅ Meals UI Wiring | DONE |
| **Mario** | ✅ Water Data Layer | DONE |

### 🟡 Day 2 — Polish, Localization, and UI Completion ✅ ALL DONE

| Assignee | Task | Notes |
|----------|------|-------|
| **Abdellatif** | ✅ Profile Persistence | DONE |
| **Abdellatif** | ✅ Progress Page | DONE |
| **Abdellatif** | ✅ UI Polish | DONE |
| **Yusuf** | ✅ AI Confirmation | DONE |
| **Yusuf** | ✅ Localization Wiring | DONE |
| **Yusuf** | ✅ RTL Audit | DONE |
| **Mario** | ✅ Explore Feature | DONE |
| **Mario** | ✅ Health Package | DONE |
| **Mario** | ✅ Shimmer Loading | DONE |

### 🟢 Day 3 — Testing, Documentation, & Presentation

| Assignee | Task | Notes |
|----------|------|-------|
| **Abdellatif** | ✅ Integration Test | DONE |
| **Abdellatif** | Performance Audit | Run Flutter DevTools. Ensure smooth scrolling and no memory leaks. |
| **Abdellatif** | Bug Squashing | Fix any final crashes. |
| **Yusuf** | Demo Seeding | Seed a Demo User account in Supabase with realistic mock data for the demo. |
| **Yusuf** | Presentation | Draft final presentation slides (Architecture, Supabase, Gemini AI). |
| **Yusuf** | Demo Rehearsal | Rehearse live demo. Test "Snap Your Plate" on a real device. |
| **Mario** | Widget Testing | Write widget tests for Home, Meals, and Water pages. |
| **Mario** | Documentation | Finalize DEPI project document and update `README.md`. |
