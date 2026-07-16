# Afia — Technical Documentation Index

Welcome to the official engineering documentation for **Afia**, an AI-driven nutrition and wellness mobile application designed for Arabic-speaking users.

This index organizes the comprehensive architectural design, reverse engineering results, and implementation specifications for the project. The documents are organized sequentially to guide technical reviewers, graduation committee members, software engineers, and future maintainers through the system from high-level objectives down to security, testing, and challenges.

---

## Table of Contents

### 1. Introduction & Overview
*   **[00-introduction.md](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/docs/00-introduction.md)** — Project genesis, graduation context, and target audience needs.
*   **[01-system-overview.md](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/docs/01-system-overview.md)** — Core block diagram mapping mobile clients, dual backend synchronizations, and external integrations.
*   **[02-requirements.md](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/docs/02-requirements.md)** — Functional requirements (diet formulas, plate analysis, presets) and verified non-functional constraints.

### 2. Architecture & Design
*   **[03-architecture.md](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/docs/03-architecture.md)** — Deep dive into Feature-First organization, Clean Architecture layer separations, and Dependency Injection setup using `get_it`.
*   **[04-project-structure.md](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/docs/04-project-structure.md)** — Catalog of folders and core modules across `lib/app/`, `lib/core/`, and `lib/features/`.

### 3. State Management & Navigation
*   **[05-state-management.md](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/docs/05-state-management.md)** — Analysis of `flutter_bloc` state patterns, Bloc/Cubit selection criteria, reactive cubit composition, and optimistic state rollbacks.
*   **[06-navigation.md](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/docs/06-navigation.md)** — Named routing switch architecture, parameter casting, and the startup Auth Gate flow.

### 4. Data Layer & Integrations
*   **[07-data-layer.md](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/docs/07-data-layer.md)** — Repositories, models extending entities, JSON mappings, and Clean Architecture exception conversion.
*   **[08-backend.md](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/docs/08-backend.md)** — Dual backend integration: Firebase Authentication and Supabase PostgreSQL schema with RLS and trigger functions.
*   **[09-ai-module.md](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/docs/09-ai-module.md)** — AI vision plate parsing pipelines, chat state models, prompt constructions, and API fallbacks.

### 5. UI, Security & Performance
*   **[10-ui-design.md](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/docs/10-ui-design.md)** — Theme styling tokens (typography, colors, spacing) and RTL layout adaptation rules.
*   **[11-security.md](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/docs/11-security.md)** — Security patterns: JWT token swapping, client-to-backend authorization sync, and PostgreSQL RLS policies.
*   **[12-performance.md](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/docs/12-performance.md)** — Offline storage structures, rebuild control strategies, custom graphics canvas optimization.

### 6. Review & Graduation Prep
*   **[13-testing.md](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/docs/13-testing.md)** — Analysis of existing test configurations, mocking structures, and commands.
*   **[14-challenges.md](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/docs/14-challenges.md)** — Engineering bottlenecks, code-to-design compromises, and graduation presentation panel Q&A defense.
*   **[15-future-improvements.md](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/docs/15-future-improvements.md)** — Roadmap for future platform integrations (Apple Health / Google Fit), Drift SQLite offline syncer, and push notifications.

---

### Quick Reference: Cross-Cutting Discussion
*   For a compiled set of specific review questions, see the original **[discussion_questions.md](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/docs/discussion_questions.md)**.
