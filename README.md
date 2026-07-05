# Afia

Afia is a Flutter app organized with:

- `feature-first architecture`
- `BLoC` for presentation state management
- `repository pattern` for data access
- a simple separation between `app`, `core`, and `features`

This README explains the project structure in an easy way, so when you open the codebase you know where things belong and why.

## 1. Big picture

The app is divided into three main parts inside `lib/`:

```text
lib/
├── app/
├── core/
├── features/
└── main.dart
```

Think about them like this:

- `main.dart`: the entry point of the whole app
- `app/`: global app setup
- `core/`: shared code used by many features
- `features/`: the real business modules of the app

If you are building a screen for login, meals, water, AI, or account, most of your work should go inside `features/`, not inside `core/`.

## 2. Why this structure?

This app uses `feature-first` architecture because the project has many product areas:

- auth
- onboarding
- main
- meals
- water
- ai
- explore
- more

If we grouped everything by technical type only, we would end up with folders like:

- `screens/`
- `blocs/`
- `repositories/`
- `models/`

That becomes hard to manage as the app grows, because files from completely different features get mixed together.

With feature-first structure, each feature keeps its own:

- UI
- BLoC
- models
- repository implementation
- use cases

This makes the code easier to find, easier to test, and easier to scale.

## 3. Top-level folders

### `lib/main.dart`

This is the app entry point.

Its job is very small:

- start Flutter
- load the root app widget

You should keep `main.dart` clean and simple.

### `lib/app/`

This folder contains app-wide setup.

Current purpose of this folder:

- app widget
- routing
- theme
- localization setup
- dependency injection setup

Structure:

```text
app/
├── app.dart
├── di/
├── localization/
├── router/
└── theme/
```

What each part means:

- `app.dart`: the root `MaterialApp`
- `router/`: route names and navigation setup
- `theme/`: colors, text styles, and theme config
- `localization/`: language-related setup
- `di/`: dependency injection registration

### `lib/core/`

This folder contains code shared across multiple features.

Use `core/` only for things that are truly reusable.

Examples:

- constants
- network helpers
- storage helpers
- common error classes
- shared widgets
- shared services

Structure:

```text
core/
├── constants/
├── error/
├── models/
├── network/
├── services/
├── storage/
├── utils/
└── widgets/
```

Good rule:

- if only one feature needs it, keep it inside that feature
- if many features need it, move it to `core/`

### `lib/features/`

This is the heart of the app.

Each business area gets its own folder:

```text
features/
├── auth/
├── onboard/
├── main/
├── meals/
├── water/
├── ai/
├── explore/
└── more/
```

This means when you work on a feature, most related files are in one place.

## 4. Inside each feature

Each feature follows this structure:

```text
feature_name/
├── data/
├── domain/
└── presentation/
```

This is a simple clean architecture style.

### `presentation/`

This is the UI layer.

It contains:

- pages
- widgets
- BLoC classes

Structure:

```text
presentation/
├── bloc/
├── pages/
└── widgets/
```

What goes here:

- `pages/`: full screens
- `widgets/`: smaller reusable UI pieces for that feature
- `bloc/`: state management logic for that feature

Example:

- login screen
- register screen
- auth bloc
- login form widget

### `domain/`

This is the business logic layer.

It contains:

- entities
- repository contracts
- use cases

Structure:

```text
domain/
├── entities/
├── repositories/
└── usecases/
```

What goes here:

- `entities/`: pure business objects
- `repositories/`: abstract contracts only
- `usecases/`: one action or business operation per class

Examples:

- `User`
- `Meal`
- `AuthRepository`
- `LoginUser`
- `GetMeals`

Important idea:

The `domain` layer should not depend on Flutter UI or API implementation details.

### `data/`

This is the data layer.

It contains:

- models
- data sources
- repository implementations

Structure:

```text
data/
├── datasources/
├── models/
└── repositories/
```

What goes here:

- `models/`: JSON or storage models
- `datasources/`: local database, API, cache, secure storage, etc.
- `repositories/`: concrete implementation of domain repository contracts

Example flow:

- `AuthRepository` is declared in `domain/repositories`
- `AuthRepositoryImpl` is implemented in `data/repositories`
- the implementation may use API, local storage, or secure storage

## 5. How BLoC, repository, and feature-first work together

This is the main mental model of the app:

```text
UI/Page
-> Bloc
-> Use Case
-> Repository (abstract contract)
-> Repository Implementation
-> Data Source
```

More simply:

1. The user taps something on the screen.
2. The page sends an event to a `Bloc`.
3. The `Bloc` decides what business action is needed.
4. That action is handled by a `use case`.
5. The use case calls a `repository`.
6. The repository implementation fetches or saves data.
7. The `Bloc` emits a new state.
8. The UI rebuilds.

This separation helps because:

- UI stays cleaner
- business logic is easier to test
- API and storage logic stay out of screens
- features are easier to change later

## 6. Current feature mapping

The app is planned around these areas:

### `auth`

Contains:

- language selection
- register account
- login

### `onboard`

Contains:

- onboarding intro flow
- profile setup
- early personal data collection

### `main`

Contains:

- home
- path
- progress

This feature may later grow enough to split internally into submodules.

### `meals`

Contains:

- meal registration
- meal logging
- saved meals
- manual entry
- meal editing

### `water`

Contains:

- water logging
- daily water target

### `ai`

Contains:

- recipe parsing
- snack suggestions
- image analysis
- AI result confirmation
- retry/error AI screens

### `explore`

Contains:

- meal catalog
- browse lists
- category exploration
- recipe/meal discovery

### `more`

Contains:

- profile and account
- alerts
- goals
- language settings
- help and about
- logout

## 7. How to decide where a file should go

When creating a new file, ask these questions:

### Is it for the whole app?

Put it in `app/`.

Examples:

- routes
- theme
- localization setup

### Is it shared by many features?

Put it in `core/`.

Examples:

- reusable button
- error class
- network helper

### Is it specific to one business area?

Put it inside that feature.

Examples:

- `features/meals/presentation/pages/meals_page.dart`
- `features/water/presentation/bloc/water_bloc.dart`
- `features/auth/data/repositories/auth_repository_impl.dart`

## 8. Simple practical examples

### Example 1: add a new login screen

Place the files here:

- `features/auth/presentation/pages/login_page.dart`
- `features/auth/presentation/widgets/login_form.dart`
- `features/auth/presentation/bloc/auth_bloc.dart`

If login needs actual business logic:

- `features/auth/domain/usecases/login_user.dart`
- `features/auth/domain/repositories/auth_repository.dart`
- `features/auth/data/repositories/auth_repository_impl.dart`
- `features/auth/data/datasources/auth_remote_data_source.dart`

### Example 2: add meal fetching from API

Possible files:

- `features/meals/domain/entities/meal.dart`
- `features/meals/domain/usecases/get_meals.dart`
- `features/meals/domain/repositories/meals_repository.dart`
- `features/meals/data/models/meal_model.dart`
- `features/meals/data/datasources/meals_remote_data_source.dart`
- `features/meals/data/repositories/meals_repository_impl.dart`
- `features/meals/presentation/bloc/meals_bloc.dart`

## 9. What should not happen

To keep the structure clean, avoid these mistakes:

- do not put feature-specific widgets in `core/widgets`
- do not put API code directly inside pages
- do not put business logic directly inside UI widgets
- do not put repository implementations inside `domain`
- do not create giant shared folders for unrelated screens

## 10. Recommended working style

When building a feature, a good order is:

1. create the screen in `presentation/pages`
2. create the feature widgets in `presentation/widgets`
3. create the bloc in `presentation/bloc`
4. define domain entities and repository contract
5. add use cases
6. implement repository in `data`
7. connect data source
8. register dependencies in `app/di`

This order helps you move from visible UI to business logic without losing structure.

## 11. About dependency injection

`lib/app/di/injection_container.dart` is where dependencies will be registered.

Later, this file will usually contain things like:

- blocs
- repositories
- use cases
- data sources
- services

The purpose of dependency injection is to:

- connect layers together cleanly
- avoid creating everything manually inside widgets
- make testing easier

## 12. About routing

Routing lives in:

- `lib/app/router/route_names.dart`
- `lib/app/router/app_router.dart`

This keeps navigation centralized.

Benefits:

- routes stay consistent
- navigation is easier to manage
- feature pages are easier to wire together

## 13. About localization

Localization-related files live in:

- `lib/app/localization/l10n.dart`
- `lib/app/localization/locale_cubit.dart`

This area is meant for language setup and language state management.

Since the app includes Arabic and English, it makes sense to keep localization as an app-level concern, not a single-feature concern.

## 14. About the current scaffold

Right now, the project contains a starter scaffold:

- root app setup
- route setup
- theme setup
- placeholder pages for each feature
- starter bloc files
- starter auth repository contract and implementation

This scaffold is not the final business implementation.

Its purpose is to:

- establish a clean folder structure early
- make future development more consistent
- prevent restructuring later when the app becomes bigger

## 15. Summary

If you remember only one thing, remember this:

- `app/` = app-wide setup
- `core/` = shared reusable code
- `features/` = actual business modules

And inside each feature:

- `presentation/` = UI + BLoC
- `domain/` = business rules
- `data/` = implementation and data access

That gives you a structure that is:

- easy to read
- easy to scale
- easy to test
- easier to maintain with many screens and features
