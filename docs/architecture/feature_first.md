# Feature-First Architecture

## Overview

Feature-first architecture organizes code around product capabilities instead of technical layers. In Afia, `auth`, `ai`, `meals`, `water`, `explore`, `main`, `more`, and `onboard` each own their presentation, domain, and data code where applicable.

## Problem Statement

Nutrition apps grow horizontally. Meal tracking, water logging, AI recognition, profile management, and dashboard analytics are related at the product level but have different workflows and data contracts. A layer-first structure makes developers jump between global `pages`, `blocs`, `models`, and `repositories` folders for one feature, which increases merge conflicts and slows understanding.

## Why We Chose It

The project is developed by a team, with features assigned to different members. Feature-first structure lets each developer work mostly inside one folder. It also makes partial progress explicit: Auth and More are more complete, while AI and Meals can be improved without reorganizing the whole repository.

## How It Is Used In Our Project

```text
lib/features/meals/
  data/
  domain/
  presentation/

lib/features/more/
  data/
  domain/
  presentation/
```

The shared code that genuinely crosses features lives under `lib/core`, such as theme tokens, error types, network client, and reusable widgets.

## Advantages

- **Local reasoning**: Most files needed for a feature are nearby.
- **Team parallelism**: Developers can work on separate feature folders.
- **Clear feature ownership**: A feature can be reviewed as a unit.
- **Incremental delivery**: Mock presentation can exist before data integration.
- **Reduced accidental coupling**: Shared utilities must be intentionally promoted to `core`.

## Tradeoffs

- **Duplication risk**: Similar widgets or models may be recreated across features.
- **Boundary decisions**: Teams must decide whether a utility belongs to a feature or `core`.
- **Cross-feature flows need care**: Dashboard aggregates meals, water, and profile data, so dependencies must remain explicit.
- **More folders**: The tree is wider than small-app structures.

## Alternatives Considered

| Alternative | Strength | Weakness For Afia |
|---|---|---|
| Layer-first | Easy to find all blocs or all models | Hard to understand one feature end-to-end |
| Package-per-feature | Strong isolation | Too heavy for this project stage |
| Single flat structure | Fast for prototypes | Becomes unmaintainable with many screens |

## Why This Choice Fits Our Project Better

Afia's features are independent enough to justify feature folders but still share a common design system and error/network infrastructure. Feature-first gives the team modularity without the operational overhead of splitting into Dart packages.

## Scalability Analysis

New features can be added by creating a new folder under `lib/features`. Onboarding developers is easier because they can trace one feature vertically. Testing also maps naturally to the same structure under `test/features`.

## Interview / Discussion Questions

1. **Why is `core` not a dumping ground?**  
   Shared code should only move to `core` when multiple features need it and the abstraction is stable.

2. **How does feature-first help merge conflicts?**  
   Developers usually modify separate feature folders instead of shared layer folders.

3. **Where should a reusable chart widget live?**  
   If used by multiple features, `core/widgets`; if only used by dashboard, inside that feature.

4. **Can feature-first coexist with Clean Architecture?**  
   Yes. Each feature can contain presentation, domain, and data layers.

5. **What is the risk of cross-feature imports?**  
   Features can become tightly coupled. Shared contracts should be moved carefully.

6. **Why not create separate packages now?**  
   The project is not large enough to justify package management overhead.

7. **How do you know a feature boundary is wrong?**  
   If unrelated flows constantly need each other's internal files.

8. **Where does the main dashboard belong?**  
   In `main`, because it coordinates summary views rather than owning all source data.

9. **How should tests be organized?**  
   Mirror feature folders, such as `test/features/auth/...`.

10. **What should happen when a feature is deleted?**  
   Most related code should be removable by deleting one feature folder and cleaning route/DI references.

## Common Mistakes

- Moving every helper to `core` too early.
- Importing presentation widgets from one feature into another without considering ownership.
- Assuming feature-first means no shared infrastructure.
- Creating inconsistent internal folder names across features.

## Best Practices

- Keep each feature's internal structure consistent.
- Promote shared widgets only after repeated use.
- Keep routing and dependency injection as explicit integration points.
- Review cross-feature imports during code review.

## Summary

Feature-first architecture fits Afia because the app is composed of several independent product areas built by a team. It keeps feature work local while still allowing shared infrastructure through `core`.
