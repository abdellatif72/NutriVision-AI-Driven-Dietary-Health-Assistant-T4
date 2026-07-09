# Auth Workflow — NutriVision (Afia)

> Living document tracking the Firebase Authentication implementation.

---

## ✅ Step 1 — Create Firebase Project

**Project name:** Nutrivision

- Created via [Firebase Console](https://console.firebase.google.com)
- This is the parent project for all Firebase services (Auth, Firestore, Storage, Crashlytics)

### Next actions:
- [x] Register Android app in Firebase Console (package name: `com.example.afia`)
- [x] Register iOS app in Firebase Console (bundle ID: `com.example.afia`)
- [x] Download/create placeholder `google-services.json` → placed at [google-services.json](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/android/app/google-services.json)
- [x] Download/create placeholder `GoogleService-Info.plist` → placed at [GoogleService-Info.plist](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/ios/Runner/GoogleService-Info.plist)
- [x] Generate/create `firebase_options.dart` → placed at [firebase_options.dart](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/firebase_options.dart)
- [x] Initialize Firebase in [main.dart](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/main.dart) with `Firebase.initializeApp()`

---

## ✅ Step 2 — Enable Sign-In Methods in Firebase Console

- Navigated to **Firebase Console → Authentication → Sign-in method**
- Enabled **Email/Password** (native provider, no additional config needed)
- Enabled **Google** (configured Web client ID from OAuth consent screen)
- Apple sign-in available but not yet enabled (requires Apple Developer Program membership)

---

## ✅ Step 3 — Initialize Firebase and Configure Platforms for Compilation

To ensure the project compiles and initializes correctly with the added Firebase dependencies, the following configurations and stubs were implemented:

1. **Firebase Options (`firebase_options.dart`)**
   - Configured cross-platform options in [firebase_options.dart](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/firebase_options.dart) with placeholder configuration settings to support local Android, iOS, Web, macOS, and Windows compilation.

2. **Native Platform Configurations**
   - **Android:**
     - Created placeholder [google-services.json](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/android/app/google-services.json) file under `android/app/`.
     - Registered `google-services` plugin inside [settings.gradle.kts](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/android/settings.gradle.kts).
     - Applied `google-services` plugin inside [app/build.gradle.kts](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/android/app/build.gradle.kts).
   - **iOS:**
     - Created placeholder [GoogleService-Info.plist](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/ios/Runner/GoogleService-Info.plist) under `ios/Runner/`.

3. **Dart Entry Point Initialization**
   - Updated [main.dart](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/main.dart) to perform asynchronous binding initialization and initialize Firebase with our platform options before starting [AfiaApp](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/app/app.dart):
     ```dart
     void main() async {
       WidgetsFlutterBinding.ensureInitialized();
       await Firebase.initializeApp(
         options: DefaultFirebaseOptions.currentPlatform,
       );
       // ...
     }
     ```

---

## ✅ Step 4 — Firebase Login & FlutterFire CLI Configuration

- Logged into Firebase CLI: `firebase login`
- Installed FlutterFire CLI globally: `dart pub global activate flutterfire_cli`
- Configured the app to connect to the **Nutrivision** Firebase project: `flutterfire configure`
- This auto-generated/updated `firebase_options.dart` with the correct project configuration

---

## 📁 Current Project State (Auth Feature)

### Existing structure (`lib/features/auth/`)

```
features/auth/
├── data/
│   ├── datasources/
│   │   └── auth_remote_datasource.dart  # Integrates Firebase Auth, Google & Apple Sign-In
│   ├── models/
│   │   └── auth_user_model.dart         # Extends AuthUser domain entity, maps from Firebase
│   └── repositories/
│       └── auth_repository_impl.dart    # Implements AuthRepository contract with Failure mappings
├── domain/
│   ├── entities/
│   │   └── auth_user.dart               # AuthUser(id, email, name) — Equatable
│   └── repositories/
│       └── auth_repository.dart         # Abstract interface with all methods defined
└── presentation/
    ├── bloc/
    │   └── auth_bloc.dart               # Empty stub
    └── pages/
        ├── auth_page.dart               # Placeholder (FeaturePlaceholderPage)
        ├── login_page.dart              # Full UI built (email/password + Google/Apple buttons)
        ├── signup_page.dart             # Full UI built (name/email/password/dob/gender)
        ├── forgot_password_page.dart    # Full UI built
        ├── goal_selection_page.dart     # Full UI built (4 goal cards)
        └── physical_information_page.dart # Full UI built (gender/weight/height)
```

### Service layer stub (`lib/core/services/auth_service.dart`)

```dart
class AuthService {
  const AuthService();
}
```

---

## 🗺️ Implementation Roadmap

### Phase 1 — Firebase Setup

- [x] Run `flutterfire configure` to generate `firebase_options.dart` (created compilation options stub)
- [x] Call `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` in `main.dart`
- [x] Verify Android `build.gradle` has `google-services` plugin applied (added to settings.gradle.kts and app build.gradle.kts)
- [x] Verify iOS configurations compile (placed placeholder Plist config)

### Phase 2 — Data Layer

- [x] Create [auth_remote_datasource.dart](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/features/auth/data/datasources/auth_remote_datasource.dart)
  - Methods: `signUpWithEmailAndPassword`, `signInWithEmailAndPassword`, `signOut`, `getCurrentUser`, `resetPassword`, `signInWithGoogle`, `signInWithApple`, `authStateChanges`
  - Wraps `FirebaseAuth` and `GoogleSignIn` / `SignInWithApple`
- [x] Create [auth_user_model.dart](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/features/auth/data/models/auth_user_model.dart)
  - Extends `AuthUser` with `fromFirebaseUser(User?)` factory
- [x] Implement [auth_repository_impl.dart](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/features/auth/data/repositories/auth_repository_impl.dart) — wire datasource to domain repository interface
  - Return `Either<Failure, AuthUser>` using `dartz`
  - Catch `FirebaseAuthException` $\rightarrow$ map to `ServerFailure` or `CacheFailure`

### Phase 3 — Bloc / State Management

- [x] Define `AuthEvent` classes in [auth_event.dart](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/features/auth/presentation/bloc/auth_event.dart)
  - `SignUpRequested`, `LoginRequested`, `SignOutRequested`, `GoogleSignInRequested`, `AppleSignInRequested`, `ResetPasswordRequested`, `AuthStateChanged`, etc.
- [x] Define `AuthState` classes in [auth_state.dart](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/features/auth/presentation/bloc/auth_state.dart)
  - `AuthInitial`, `AuthLoading`, `AuthAuthenticated(AuthUser)`, `AuthUnauthenticated`, `AuthError(String)`
- [x] Implement [auth_bloc.dart](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/features/auth/presentation/bloc/auth_bloc.dart) — handle events, emit states, listen to `authStateChanges`
  - Use `StreamSubscription` for auth state listener
  - Register via `get_it` in [injection_container.dart](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/app/di/injection_container.dart)

### Phase 4 — UI Wiring

- [x] Replace `AuthPage` placeholder with real entry point in [auth_page.dart](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/features/auth/presentation/pages/auth_page.dart)
  - Check auth state $\rightarrow$ route to `/main` if authenticated, or `/auth/login` if not
- [x] Connect `LoginPage` to `AuthBloc` $\rightarrow$ dispatch `LoginRequested`, `GoogleSignInRequested`, `AppleSignInRequested`
- [x] Connect `SignupPage` to `AuthBloc` $\rightarrow$ dispatch `SignUpRequested`
- [x] Wire `ForgotPasswordPage` $\rightarrow$ dispatch `ResetPasswordRequested`
- [x] On successful signup $\rightarrow$ navigate to `/auth/physical-information` $\rightarrow$ `/auth/goal-selection` $\rightarrow$ `/main`
- [x] On successful login $\rightarrow$ navigate to `/main`
- [x] Add auth state listener in [app.dart](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/app/app.dart) via `BlocProvider` and [auth_page.dart](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/lib/features/auth/presentation/pages/auth_page.dart) landing redirects

### Phase 5 — Session Guard / Cold Start

- [x] On app cold start: `AuthBloc` checks `FirebaseAuth.instance.currentUser` (wrapped in `AuthCheckRequested` inside `AuthPage`)
- [x] If user exists $\rightarrow$ emit `AuthAuthenticated` $\rightarrow$ show `/main`
- [x] If no user $\rightarrow$ emit `AuthUnauthenticated` $\rightarrow$ show `/auth/login`
- [x] Handle token expiry / refresh automatically (Firebase handles this)

---

## 🔗 Packages (already in `pubspec.yaml`)

| Package | Version | Purpose |
|---------|---------|---------|
| `firebase_core` | ^3.12.1 | Firebase initialization |
| `firebase_auth` | ^5.5.1 | Firebase Authentication |
| `google_sign_in` | ^6.3.0 | Google Sign-In |
| `sign_in_with_apple` | ^6.1.4 | Apple Sign-In |
| `get_it` | ^8.0.3 | DI service locator |
| `injectable` | ^2.5.0 | DI code generation |
| `dartz` | ^0.10.1 | Either type for error handling |
| `equatable` | ^2.0.5 | Value equality for entities/states |
| `flutter_bloc` | ^8.1.6 | State management |

---

## 📝 Notes

- `AuthRepository` abstract has all methods defined — the contract is clear
- ✅ Created `google-services.json` and `GoogleService-Info.plist` stubs
- ✅ Created `firebase_options.dart` for cross-platform builds
- ✅ Initialized Firebase in `main.dart`
- ✅ Completed Phase 2 (Data Layer): implemented `AuthRemoteDataSource`, `AuthUserModel`, and `AuthRepositoryImpl`
- ✅ Completed Phase 3 (Bloc / State Management): implemented `AuthEvent`, `AuthState`, `AuthBloc`, and registered them in `InjectionContainer`
- ✅ Completed Phase 4 (UI Wiring): connected pages to `AuthBloc` with state transitions, loading indicators, and error snackbars
- ✅ Completed Phase 5 (Session Guard): configured `AuthPage` to intercept cold starts and dynamically redirect authenticated/unauthenticated users
