# Cross-Cutting Discussion Questions

This document collects instructor-style questions that connect multiple architecture decisions. Use it after reading the individual decision files.

## Architecture

1. **How do Feature-First and Clean Architecture work together in Afia?**  
   Feature-first decides where code is grouped; Clean Architecture decides dependency direction inside each feature. A feature owns its presentation, domain, and data layers, while domain remains independent from data implementations.

2. **Why is the domain layer important in a Flutter app?**  
   Flutter is a UI framework, but Afia also has business rules such as calorie calculation, profile updates, and food logging. Domain code keeps those rules testable without rendering widgets.

3. **What is the risk of putting backend calls inside widgets?**  
   Widgets would mix rendering, side effects, parsing, and error handling. This makes testing harder and increases regression risk when a backend changes.

4. **When is it acceptable not to use a full Clean Architecture stack?**  
   Static or very simple screens may not need entities, repositories, and use cases. Architecture should reduce coupling, not create unnecessary ceremony.

5. **How would you add a new Exercise Tracking feature?**  
   Create `features/exercise`, define domain entities/use cases, add repository interfaces, implement data sources, register dependencies, add routes, and connect presentation state through Bloc or Cubit.

## State Management

6. **Why does Afia use both Bloc and Cubit?**  
   Bloc is better for complex event-driven flows, while Cubit is more direct for simple linear state. Using both avoids unnecessary boilerplate while keeping state structured.

7. **How should a Bloc expose errors to the UI?**  
   It should emit a state containing a user-safe message or failure type, not raw provider exceptions.

8. **What makes a state class well-designed?**  
   It is immutable, comparable, focused on UI needs, and represents loading/success/error conditions clearly.

9. **How can event concurrency affect meal search?**  
   Rapid typing can trigger overlapping searches. A restartable search strategy can cancel stale requests so only the latest query matters.

10. **Why should BuildContext not be stored in Bloc or Cubit?**  
   It ties state logic to widget lifecycle and can cause memory and navigation issues.

## Backend and Data

11. **Why use Firebase Auth and Supabase together?**  
   Firebase provides managed identity; Supabase provides relational app data and storage. The split is acceptable if identity mapping is handled carefully.

12. **What should happen if Supabase is unavailable but profile cache exists?**  
   The repository can return cached profile data and optionally mark it as stale, allowing the UI to remain useful.

13. **Why should API keys not be stored directly in client source for production?**  
   Mobile clients can be inspected. Sensitive provider access should be protected through backend mediation or restricted keys.

14. **How does repository pattern help with AI provider fallback?**  
   The UI calls one repository method while datasource/provider logic decides whether to use Groq, Gemini, or another provider.

15. **What is the difference between authentication and authorization?**  
   Authentication proves identity. Authorization determines what data or actions that identity can access.

## AI

16. **Why should AI meal analysis require confirmation before saving?**  
   AI estimates can be wrong. Health-related logs should allow user correction before affecting daily totals.

17. **How do we reduce hallucinated nutrition data?**  
   Use structured prompts, validate response schema, cross-check with nutrition data where possible, and let users edit values.

18. **What is the limitation of asking the model for exact calories?**  
   The model estimates from visual appearance and cannot know precise ingredients, cooking oil, or serving mass.

19. **Why is JSON output preferred for AI responses?**  
   It lets the app parse fields deterministically and map them to domain models.

20. **What would you monitor in production AI usage?**  
   Latency, failure rate, invalid JSON rate, user correction rate, and provider rate-limit responses.

## Quality and Maintenance

21. **How do tests support the architecture?**  
   Unit tests validate use cases and blocs; widget tests validate UI behavior; integration tests validate full user flows.

22. **What is the main maintenance risk in the current DI setup?**  
   Manual registration can drift from constructors. Missing registrations appear at runtime.

23. **Why is localization not only text translation?**  
   Arabic support also affects directionality, alignment, typography, spacing, and text overflow.

24. **How should the team review new feature code?**  
   Check layer boundaries, DI registration, error handling, route wiring, token usage, and tests for failure paths.

25. **What is the strongest argument for this architecture in Afia?**  
   The app combines multiple features and providers. Separation lets the team evolve one part without rewriting unrelated screens.

## Known Implementation Caveats

- Some features are more complete than others. Architecture should be evaluated by both intended structure and current implementation.
- AI UI logic should continue moving out of page widgets and into Bloc/use case/repository layers.
- Manual `get_it` registration is pragmatic now but should be watched as the graph grows.
- Offline support currently fits small cached records; full meal/history offline sync would require a stronger local database and conflict policy.
