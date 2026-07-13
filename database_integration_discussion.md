# Database Integration Discussion - NutriVision (Afia)

This document tracks all discussions, plans, and architectural decisions made during the integration of the database (Supabase/PostgreSQL) with the Afia application.

---

## 📅 Initial Setup (2026-07-13)

### Goal
Integrate the database layers for the features in the Afia app, transitioning from mock/stub interfaces to concrete database implementations communicating with Supabase.

### Architectural Constraints
* **Pattern**: Feature-First Clean Architecture (`Presentation → Domain → Data`).
* **State Management**: `flutter_bloc` (Blocs and Cubits).
* **DI**: Wiring up data sources, repositories, and use cases using `GetIt` and `injectable`.
* **Database**: Supabase (PostgreSQL) with tables defined in [database_design.md](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/database_design.md).
