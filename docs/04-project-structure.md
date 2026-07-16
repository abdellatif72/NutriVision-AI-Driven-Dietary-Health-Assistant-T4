# Project Structure of Afia

## Purpose
This document details the file organization, directory layout, core widgets, and shared utilities in the **Afia** project. It serves as a directory reference for the codebase, explaining where to find or add modules.

## Overview
The Afia project is divided into three major top-level directories under `lib/`:
1.  **`lib/app/`**: Application bootstrapping, global routes, dependency registration, and global state providers (like locale and user-theme preferences).
2.  **`lib/core/`**: Foundational modules, shared services, error types, network configuration, and cross-cutting design system widgets.
3.  **`lib/features/`**: The core application logic grouped into modular product capabilities using Clean Architecture boundaries.

## Design Decisions
1.  **Module Isolation (Feature-First)**: Grouping files by vertical product context (e.g., `water`, `meals`, `ai`) instead of technical types ensures that features can be developed, refactored, or even deleted as modular units with minimal cross-feature side effects.
2.  **Strict Global-Local Scoping**: Widgets and utilities are kept local to their features until a reuse requirement elsewhere is verified. Only after a component is explicitly required by multiple features is it promoted to `lib/core/widgets/` to avoid polluting the global namespace.
3.  **Encapsulation of Configurations in `lib/app/`**: High-level bootstrap logic (routing maps, localization infrastructure) is placed in `lib/app/` to keep root-level directories clean and highlight the application's configuration entry points.

## Internal Architecture
The codebase is structured under three main directories:

### 1. `lib/app/`
Contains global routing configurations, dependency injection logic, and high-level wrappers:
*   [app.dart](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/app/app.dart): Initializer for `MaterialApp`, providing global BLoCs (`AuthBloc`, `LocaleCubit`, `AppPreferencesCubit`) and locale settings.
*   `di/`: Hosts [injection_container.dart](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/app/di/injection_container.dart) which serves as the application's Composition Root.
*   `localization/`: Handles RTL layout configuration and Arabic/English language toggling via the `LocaleCubit`.
*   `router/`: Contains [app_router.dart](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/app/router/app_router.dart) and [route_names.dart](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/app/router/route_names.dart), mapping all 31 system routes to their respective pages.

### 2. `lib/core/`
The foundational framework that powers all features:
*   `constants/`: App configurations (e.g., Supabase/Firebase credentials).
*   `error/`: Standardizes app errors with classes like [failures.dart](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/core/error/failures.dart) (`ServerFailure`, `CacheFailure`) and [exceptions.dart](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/core/error/exceptions.dart) (`ServerException`, `CacheException`).
*   `network/`: Contains [api_client.dart](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/core/network/api_client.dart), a Dio-based HTTP client pre-configured with interceptors, timeouts, and automatic retry policies.
*   `services/`: Shared services like the token swapper.
*   `theme/`: Implements the Afia design system. Colors, typography, custom layouts, and spacing parameters are stored here:
    *   [afia_colors.dart](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/core/theme/afia_colors.dart): Design tokens for brand green, blue (water), red (heart rate), orange (calories), backgrounds, and surfaces.
    *   [afia_spacing.dart](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/core/theme/afia_spacing.dart): Defines spacing variables from `xs` (4px) to `xxl` (24px) alongside standard page margins.
    *   [afia_typography.dart](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/core/theme/afia_typography.dart): Implements the Plus Jakarta Sans font sizes and weights for titles, labels, and statistics.
    *   [afia_theme.dart](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/core/theme/afia_theme.dart): Exposes the system-wide Material 3 light theme.
*   `widgets/`: Contains global reusable UI widgets.

### 3. `lib/features/`
Individual product domains containing business logic, databases, and pages:
*   `auth`: Signup, sign-in, onboarding setups, and daily calorie target calculators.
*   `onboard`: Splash screens and introduction slides.
*   `main`: The primary shells, dashboard grids, home page calorie progress charts, and weekly weight trends.
*   `meals`: Meal details, logging sheets, and categories.
*   `water`: Hydration logger, intake tracking grids, and presets.
*   `ai`: Chat assistants and picture-based plate analysis dashboards.
*   `explore`: Catalog searches for foods and logging utilities.
*   `more`: Preferences settings, personal forms, and support pages.

## Workflow
Here is how page components inside features interact with shared utilities:
1.  **Rendering Widgets**: A feature widget (e.g., `_HomeView`) queries design tokens from [afia_colors.dart](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/core/theme/afia_colors.dart) and [afia_spacing.dart](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/core/theme/afia_spacing.dart) to apply padding, alignment, and coloring.
2.  **Using Reusable Cards**: The dashboard screen imports shared cards (like [AfiaWeeklyProgressCard](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/core/widgets/afia_weekly_progress_card.dart) or [AfiaMetricStatCard](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/core/widgets/afia_metric_stat_card.dart)) to display metrics, passing the data returned by the feature's bloc.
3.  **Making API Calls**: A feature datasource queries the global `ApiClient` registered in GetIt. If the query throws, the client maps the Dio error to a standard `ServerException`, which the repository maps to a `ServerFailure` before passing it to the UI.

## Important Classes
The core components under `lib/core/widgets/` include:
*   **[AfiaWeeklyProgressCard](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/core/widgets/afia_weekly_progress_card.dart)**: A custom card presenting the user's weekly target compliance with green progress rings.
*   **[AfiaBarChartCard](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/core/widgets/afia_bar_chart_card.dart)**: A modular bar chart card displaying weight variations and trends over a seven-day cycle.
*   **[AfiaMetricStatCard](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/core/widgets/afia_metric_stat_card.dart)**: Displays summary values for primary stats (steps, hydration, sleep, heart rate) using configured colors.
*   **[AfiaMiniMetricCard](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/core/widgets/afia_mini_metric_card.dart)**: A compact layout card highlighting quick sub-metrics.
*   **[AfiaWeekCalendar](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/core/widgets/afia_week_calendar.dart)**: A horizontal weekly calendar strip allowing users to scroll and tap days to log metrics on different dates.
*   **[AfiaEmptyState](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/core/widgets/afia_empty_state.dart)** & **[AfiaErrorState](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/core/widgets/afia_error_state.dart)**: Standardized components displaying uniform illustrations and call-to-actions for empty or broken layouts.
*   **[FeaturePlaceholderPage](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/core/widgets/feature_placeholder_page.dart)**: A fallback page showing placeholder UI for pages currently under development.

## Folder Structure
Below is the directory tree of the `lib/` folder:

```text
lib/
├── app/
│   ├── app.dart                        # Root application configuration
│   ├── di/
│   │   └── injection_container.dart    # Dependency Injection registry
│   ├── localization/
│   │   ├── l10n.dart                   # Locale values and files configuration
│   │   └── locale_cubit.dart           # Cubit coordinating UI translation languages
│   └── router/
│       ├── app_router.dart             # Named routes mapping router
│       └── route_names.dart            # Standard definitions for all 31 page routes
├── core/
│   ├── constants/
│   │   └── app_constants.dart          # System credential variables and URLs
│   ├── error/
│   │   ├── exceptions.dart             # System database exceptions mapping
│   │   └── failures.dart              # Domain-level failure mappings
│   ├── network/
│   │   ├── api_client.dart             # Custom Dio configuration layer
│   │   └── retry_on_429_interceptor.dart # Interceptor backing off on 429 warnings
│   ├── services/
│   │   ├── token_swap_service.dart     # Coordinates tokens between auth contexts
│   │   └── app_logger.dart             # Core system logger helper
│   ├── theme/
│   │   ├── afia_colors.dart            # Design tokens for primary colors
│   │   ├── afia_spacing.dart           # Design tokens for margins and paddings
│   │   ├── afia_typography.dart        # Design tokens for fonts and sizes
│   │   └── afia_theme.dart             # Material 3 light theme config
│   └── widgets/                        # Shared reusable widgets
│       ├── afia_bar_chart_card.dart
│       ├── afia_empty_state.dart
│       ├── afia_error_state.dart
│       ├── afia_metric_stat_card.dart
│       ├── afia_mini_metric_card.dart
│       ├── afia_week_calendar.dart
│       ├── afia_weekly_progress_card.dart
│       └── feature_placeholder_page.dart
└── features/
    ├── ai/                             # Gemini recipe/chat analytics
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    ├── auth/                           # Login, Signup, and setup
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    ├── explore/                        # Food searching catalog
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    ├── main/                           # Coordinates bottom tabs and navigation shell
    │   └── presentation/
    ├── meals/                          # Breakfast, lunch, dinner, snack records
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    ├── onboard/                        # Initial onboarding presentation slides
    │   └── presentation/
    ├── water/                          # Water logging metrics
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    └── more/                           # Settings, password edit, profiles
        ├── data/
        ├── domain/
        └── presentation/
```

## Advantages
1.  **High Cohesion**: Feature-first structure keeps related code together, allowing developers to quickly locate and edit widgets, controllers, and models for a single feature.
2.  **UI Consistency**: Centralizing design tokens in `lib/core/theme/` and widgets in `lib/core/widgets/` ensures that new pages follow design specifications by default.
3.  **Low Risk of Merge Conflicts**: Since developers work in distinct feature folders, simultaneous changes rarely touch the same files.
4.  **Separation of Infrastructure**: Core network and storage clients remain decoupled from features, allowing for global upgrades (like implementing cache decorators) in one place.

## Trade-offs
1.  **Deep File Hierarchy**: Finding files can require expanding several nested subdirectories, which can feel heavy for simpler pages.
2.  **Feature Integration Complexity**: Main pages (like the home dashboard) require coordination between multiple feature controllers, resulting in complex cross-feature imports or state linkages.
3.  **Boilerplate Overhead**: Promoting components (like moving a local widget to `core/widgets`) requires rewriting import paths across multiple files.

## Limitations
1.  **Direct Feature Coupling**: There are instances where features import components from other features (e.g., `MealsCubit` directly imports `MoreRemoteDataSource` from `more`). Ideally, features should only communicate through a decoupled mediator or share contracts in `core/`.
2.  **No Package-Level Enforcement**: The boundary separation relies on developer discipline. The project does not use independent Dart packages to strictly enforce imports, leaving room for architectural drift.
3.  **Lack of Health Integration**: Steps and heart rate metrics are registered in core widgets, but the background health package linking (Apple Health / Google Fit) is not yet wired, leaving the stats cards with mock data.

## Future Improvements
1.  **Establish a Shared Feature Layer**: Create a `core/shared/` module to house contracts that cross feature boundaries (such as a shared user profile data model), eliminating direct imports between feature folders.
2.  **Automate Folder Structure Auditing**: Add a CI script or custom linter rule to prevent widgets or data layers from violating clean architecture dependency directions.
3.  **Integrate Health Sync Service**: Implement a dedicated syncing data module under `lib/core/services/health/` to feed real data from Apple Health and Google Fit into the steps and heart rate widgets.
