# System Requirements

## Purpose
The purpose of this document is to catalog and verify the functional and non-functional requirements of the Afia mobile application. It details how these requirements are implemented and verified in the codebase.

## Overview
Afia is designed to meet strict functional and non-functional requirements to ensure utility, reliability, and security for the target Arabic-speaking demographic.

### 1. Functional Requirements (FR)
- **FR-1: User Authentication:** Support email/password registration, login, session persistence, and social sign-in (Google/Apple).
- **FR-2: Intake Target Calculation:** Automatically calculate daily Basal Metabolic Rate (BMR), Total Daily Energy Expenditure (TDEE), and Calorie targets using the Mifflin-St Jeor equation.
- **FR-3: Meal Logging:** Log meals with a breakdown of calories, protein, carbohydrates, and fats across meal slots (Breakfast, Lunch, Dinner, Snacks).
- **FR-4: Hydration Logging:** Record daily water consumption using standard size presets (e.g., 250ml, 500ml) or custom input.
- **FR-5: AI Visual Analysis ("Snap Your Plate"):** Analyze a food plate photo, extract food names, estimate weight, and provide nutrition estimates.
- **FR-6: Food Catalog Search:** Query local databases and external API catalogs (USDA, Nutritionix) for item details.

### 2. Non-Functional Requirements (NFR)
- **NFR-1: RTL / Arabic Interface:** Native Right-to-Left (RTL) directional layout flow without overlapping components or text overflows.
- **NFR-2: Relational Data Security:** Ensure users can only read, write, or update their own files and profile columns (implemented via Supabase RLS).
- **NFR-3: Performance Caching:** Fallback local caches for profiles, enabling offline screen rendering.

## Design Decisions
- **Verification of Calorie Boundaries:** In [calculate_daily_calories.dart](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/features/auth/domain/usecases/calculate_daily_calories.dart), the calorie deficit calculation prevents targets from dropping below safe physiological limits: 1200 kcal/day for females and 1500 kcal/day for males.
- **AI Estimate User Control:** Visual estimates can be incorrect. The system mandates a confirmation card step before persisting AI estimates. Users can adjust calories, food names, and weight values prior to database insertion.
- **RTL-First Styling:** All layout views avoid hardcoded `padding: EdgeInsets.only(left: ...)` values. Instead, they use directional constructs like `EdgeInsetsDirectional.only(start: ...)` to adapt automatically to language shifts.

## Internal Architecture
Functional requirements are isolated into single-purpose **Use Cases** in the domain layer, ensuring they remain decoupled from data access methods:

```
[Presentation: Blocs/Cubits] ──> [Domain: Use Cases] ──> [Domain: Repository Interface]
                                          │
                            Calculations (Mifflin-St Jeor)
```

## Workflow
### 1. Calorie Target Verification Workflow
- The user inputs weight, height, age, gender, activity level, and weight goal.
- The UI triggers `CalculateDailyCalories`.
- The class evaluates equations based on gender inputs:
  - *Male:* $BMR = 10 \times \text{weight} + 6.25 \times \text{height} - 5 \times \text{age} + 5$
  - *Female:* $BMR = 10 \times \text{weight} + 6.25 \times \text{height} - 5 \times \text{age} - 161$
- Multipliers translate BMR to TDEE (1.2 for sedentary to 1.725 for very active).
- Safe deficit threshold is evaluated and target calories are returned.

### 2. Hydration Tracking Workflow
- The user taps a preset on [water_page.dart](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/features/water/presentation/pages/water_page.dart).
- `WaterRecordingCubit` triggers `RecordWaterLog`.
- The entry is appended to Supabase and the daily progress ring updates.

## Important Classes
- [CalculateDailyCalories](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/features/auth/domain/usecases/calculate_daily_calories.dart): Implements target metabolic equations.
- [AnalyzePlate](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/features/ai/domain/usecases/analyze_plate.dart): Directs image analysis to the repository layer.
- [WaterRecordingCubit](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/features/water/presentation/cubit/water_recording_cubit.dart): Manages daily water logs and limits.

## Folder Structure
```
lib/features/
├── auth/domain/usecases/
│   └── calculate_daily_calories.dart   # FR-2 (Calorie calculation engine)
├── meals/domain/usecases/
│   ├── log_meal.dart                   # FR-3 (Meal entry logger)
│   └── delete_meal.dart
├── water/domain/usecases/
│   ├── get_water_logs.dart             # FR-4 (Hydration records query)
│   └── add_water_log.dart
└── ai/domain/usecases/
    └── analyze_plate.dart              # FR-5 (Image food analysis engine)
```

## Advantages
- **Unit Testable Logic:** Pure Dart classes like `CalculateDailyCalories` are verified using simple Dart mocks without loading the Flutter UI environment.
- **Modularity:** Modifying nutrition calculation algorithms does not impact database operations or layout widgets.

## Trade-offs
- **Divergent Objects:** Splitting logic into single-purpose use case files increases total project file count, requiring developers to maintain multiple classes for a single feature.

## Limitations
- **Health SDK Scope:** Steps and heart rate metrics lack native sync integration.
- **Removed Reminder Feature:** The dynamic schedule reminder module (water alarm/meal alarms) has been removed from the system scope.

## Future Improvements
- **Native Health SDK Sync:** Implement Apple HealthKit and Google Health Connect integrations to automate daily calorie burned calculations.
- **Visual Barcode Scanner:** Add barcode parsing support in `lib/features/explore` to identify grocery products in real time.
