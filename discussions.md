# Clean Architecture & BLoC Design Discussion

> Reference document explaining the architectural choices and components of the NutriVision (Afia) application.

---

## 📁 Phase 2: The Data Layer (The Foundation)

### 1. Why do we need `AuthRemoteDataSource`?
* **Purpose:** The datasource is the only component that directly interacts with external APIs and SDKs (like `FirebaseAuth`, `GoogleSignIn`, or `SignInWithApple`).
* **Rationale:** By isolating SDK calls:
  * We protect the rest of the application from changes in third-party API contracts.
  * If we switch backend providers (e.g., from Firebase to Supabase or a custom REST API), we only update the datasource code. The rest of the app's business logic and UI remains untouched.

### 2. Why do we need `AuthUserModel`?
* **Purpose:** Maps database-specific or API-specific user formats to our domain entity.
* **Rationale:** Firebase returns a complex, platform-dependent `User` object. Our app's core domain layer should not depend on external SDK classes. The `AuthUserModel` acts as a translator, mapping the external Firebase `User` into a clean, platform-independent domain entity ([AuthUser](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/features/auth/domain/entities/auth_user.dart)).

### 3. Why do we need `AuthRepositoryImpl`?
* **Purpose:** Bridges the **Domain layer** (which defines abstract contracts) and the **Data layer** (which executes them).
* **Rationale:** 
  * It coordinates the datasource calls, catches native exceptions (like `FirebaseAuthException` for bad network or incorrect passwords), and maps them to predictable app-level errors (`Failure`).
  * By returning `Either<Failure, AuthUser>` (using `dartz`), it guarantees compile-safe error handling. Callers are forced to handle both success and failure cases, preventing unhandled runtime crashes.

---

## 🧠 Phase 3: Bloc State Management (The Brain)

### 4. Why do we need `AuthEvent` and `AuthState`?
* **Purpose:** Defines the discrete inputs and outputs of the auth business flow.
* **Rationale:** Rather than letting the UI directly command actions, the UI tells the app *what happened* (e.g., "User clicked Login Button" $\rightarrow$ `LoginRequested`). The Bloc then responds by updating the UI with *what state it's in* (e.g., `AuthLoading` then `AuthAuthenticated` or `AuthError`). This ensures a predictable, unidirectional data flow:
  $$\text{UI Button Tap} \longrightarrow \text{Event} \longrightarrow \text{Bloc Processing} \longrightarrow \text{State Change} \longrightarrow \text{UI Update}$$

### 5. Why do we need `AuthBloc`?
* **Purpose:** Orchestrates the business rules of the authentication feature.
* **Rationale:** It listens to incoming events, invokes corresponding repository use cases/methods, and publishes state changes. By decoupling logic entirely from widgets, we prevent screens from becoming bloated and hard to maintain.

---

## 🎨 Phase 4 & 5: UI & Session Guard (The Shell)

### 6. Why wire the UI to the Bloc?
* **Purpose:** Keeps the user interface widgets purely representational ("dumb").
* **Rationale:** The login screen's only job is to gather input, trigger an event, and render components (like spinner or error dialogs) based on the state. It contains no business logic, making it extremely easy to test, redesign, and reuse.

### 7. Why do we need a Session Guard?
* **Purpose:** Manages the initial landing route of the application on boot.
* **Rationale:** When the user launches the app, we check if they have a cached active session. If they do, we bypass login and onboarding, sending them straight to the main screen. If not, they are directed to the login screen.
