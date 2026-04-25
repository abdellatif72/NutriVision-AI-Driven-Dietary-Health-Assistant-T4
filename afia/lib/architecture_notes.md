# Afia feature-first structure

This project is organized around three top-level concerns:

- `app/`: app-wide setup such as routing, theme, localization, and dependency injection
- `core/`: shared infrastructure and reusable building blocks
- `features/`: business features split into `data`, `domain`, and `presentation`

Each feature follows this shape:

- `data/`: models, local or remote data sources, repository implementations
- `domain/`: entities, repository contracts, use cases
- `presentation/`: blocs, pages, and feature-specific widgets

Current feature modules:

- `auth`
- `onboard`
- `main`
- `meals`
- `water`
- `ai`
- `explore`
- `more`
