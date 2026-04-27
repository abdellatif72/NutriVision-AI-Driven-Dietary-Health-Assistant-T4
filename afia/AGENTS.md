# Afia Flutter Project Instructions

You are working on `afia`, a Flutter app organized with a feature-first, layered structure.

## Project Context
- Follow the existing structure:
  - `lib/app/`: app-wide configuration such as routing, theme, localization, and dependency injection
  - `lib/core/`: shared infrastructure, services, utilities, storage, error handling, and reusable widgets
  - `lib/features/`: feature modules organized by responsibility
- Respect the architecture documented in `lib/architecture_notes.md`.
- Prefer extending current project patterns over introducing new frameworks or paradigms.

## Interaction Guidelines
- Assume the user is comfortable with programming but may still be building Flutter-specific intuition.
- When suggesting a Flutter or Dart approach, explain the reasoning first if it is non-obvious.
- If a request conflicts with the current architecture, say so clearly and recommend the least disruptive option.
- Avoid dropping in generic Flutter boilerplate that ignores this project’s structure.
- When suggesting a new package, explain:
  - what problem it solves here
  - why the existing code is not enough
  - what architectural cost it adds

## Core Architectural Rules
- Preserve the feature-first structure:
  - `data/`: models, data sources, repository implementations
  - `domain/`: entities, contracts, use cases
  - `presentation/`: pages, widgets, blocs, and cubits
- Keep app-wide concerns out of feature modules unless they are truly feature-specific.
- All presentation state should live in `Bloc`/`Cubit` classes, not in pages except for truly local controller wiring.
- Prefer small, incremental additions that keep the app compiling, even when a feature is incomplete.
- Use placeholder pages or stub implementations only when they help maintain navigable app structure.

## State Management
- Use `flutter_bloc` as the default and required state management approach across the app.
- Do not introduce `ValueNotifier`, `ChangeNotifier`, Provider, Riverpod, GetX, or other state management approaches unless explicitly requested for a narrow technical reason.
- Each feature’s presentation layer should manage state through `Bloc` or `Cubit`.
- Prefer:
  - `Cubit` for simple state transitions driven by direct method calls
  - `Bloc` when event-driven flows, branching logic, or more complex orchestration are needed
- Keep state management consistent within a feature. Do not mix multiple state management styles in the same feature.
- Separate UI rendering from business logic:
  - widgets render state and dispatch intents
  - cubits/blocs coordinate presentation logic
  - domain/use cases hold business rules
- Avoid putting business logic, async orchestration, or validation directly inside widgets.
- Ephemeral UI state that affects user flow should also be modeled through `Cubit`/`Bloc` when possible to preserve consistency.
- Use `BlocProvider`, `MultiBlocProvider`, `BlocBuilder`, `BlocListener`, and `BlocConsumer` appropriately:
  - `BlocBuilder` for rendering
  - `BlocListener` for one-off side effects like navigation, snackbars, dialogs
  - `BlocConsumer` only when both are needed together
- Keep bloc state immutable and explicit. Prefer clear state objects over implicit flags spread across widgets.
- Model loading, success, empty, and error states intentionally rather than relying on nullable fields alone.

## Routing
- Use the project’s current routing approach based on `AppRouter` and route names unless there is a strong reason to migrate.
- Add routes centrally and keep route names explicit.
- If a route requires arguments, make argument passing and extraction type-safe and easy to trace.
- Do not introduce `go_router` just because it is popular; only recommend it if deep linking, guarded navigation, or nested navigation complexity justifies the migration cost.

## Theming and Design System
- All colors, typography, and reusable visual tokens should flow through:
  - `AppTheme`
  - `AppColors`
  - `AppTextStyles`
- Do not hardcode colors or text styles inside feature widgets unless there is a short-lived prototype reason.
- Keep Material 3 enabled and evolve the design system through centralized theme tokens.
- Prefer extending existing semantic colors over adding one-off colors.
- If adding a new reusable style, define it once in the theme layer and reuse it.
- Support future dark theme expansion, but do not force dark-theme work unless the feature needs it now.

## Widget and UI Rules
- Prefer composition over large build methods.
- Extract private widgets when a screen becomes hard to scan.
- Keep widgets immutable whenever possible.
- Use `const` constructors aggressively where valid.
- Avoid expensive work in `build()`.
- Use builder-based scrolling widgets for dynamic collections.
- Prefer clear, semantic widget trees over clever abstractions.

## Dart and Code Quality
- Follow `flutter_lints` and the project’s `analysis_options.yaml`.
- Use package imports consistently.
- Prefer sound null-safe code and avoid `!` unless the guarantee is real and obvious.
- Keep functions focused and short when practical, but do not split code so aggressively that readability gets worse.
- Use descriptive names; avoid abbreviations unless they are standard Flutter terms.
- Use `dart:developer` logging or project logging utilities instead of `print`.
- Handle failures explicitly through `core/error` patterns when writing feature or service code.

## Dependency Injection and Services
- Keep dependency wiring centralized in `lib/app/di/injection_container.dart`.
- Prefer constructor injection so dependencies stay visible and testable.
- Avoid hidden singletons scattered across the codebase.
- Shared infrastructure belongs in `core/`; feature-specific orchestration belongs in the feature.

## Networking, Storage, and Error Handling
- Reuse `core/network`, `core/storage`, and `core/error` abstractions before adding parallel patterns.
- Surface failures intentionally; do not swallow exceptions.
- When adding async code:
  - make loading/error/success states explicit
  - keep UI feedback predictable
  - avoid burying side effects in widgets

## Localization
- Keep user-facing strings ready for localization.
- Prefer routing new app-wide locale behavior through the existing localization layer in `lib/app/localization/`.
- Avoid scattering locale logic across features.

## Testing and Validation
- Run:
  - `dart format .`
  - `flutter analyze`
- Use `dart fix --apply` when it helps and does not create noisy changes.
- Add tests for logic-heavy code, especially:
  - blocs and cubits
  - use cases
  - repositories
  - parsing or mapping logic
- Test emitted state sequences for non-trivial bloc/cubit behavior.
- Do not add shallow tests that only restate implementation details.

## Change Strategy
- Prefer consistency over idealized rewrites.
- If the existing implementation is a temporary scaffold, improve it in the same style unless the user asks for a broader architectural shift.
- When recommending a larger refactor, explain:
  - what problem it solves
  - why now is the right time
  - what tradeoff or migration cost it introduces
