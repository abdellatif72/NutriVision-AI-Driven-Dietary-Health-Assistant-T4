# Build Issues Log

> Log of issues encountered while building the project and their resolutions.

---

## Issue #1 — CMake Cache Directory Mismatch (Linux)

**Date:** 2026-07-09

**Error:**
```
CMake Error: The current CMakeCache.txt directory .../build/linux/x64/debug/
is different than the directory .../afia/build/linux/x64/debug/ where
CMakeCache.txt was created.
```

**Cause:** The project was previously built from a different directory path (likely the old `afia/` directory name before the repo was moved or renamed), and CMake cached the old source path in `build/linux/x64/debug/CMakeCache.txt`.

**Fix:**
```bash
rm -rf build/linux/
flutter clean
flutter pub get
```

This removes the stale CMake cache so it regenerates with the correct source directory on the next build.

**Status:** ✅ Resolved (Executed `flutter clean && flutter pub get` successfully in the current workspace session).

---

## Issue #2 — Crashlytics Plugin Not Found in Gradle Repositories (Android)

**Date:** 2026-07-09

**Error:**
```
Build file '.../android/app/build.gradle.kts' line: 1
Plugin [id: 'com.google.firebase.crashlytics'] was not found in any of the following sources:
- Gradle Core Plugins
- Included Builds
- Plugin Repositories
```

**Cause:** The Firebase Crashlytics plugin was applied in [android/app/build.gradle.kts](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/android/app/build.gradle.kts), but its dependency and version were not declared in the project settings file [android/settings.gradle.kts](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/android/settings.gradle.kts) for the Gradle Kotlin DSL plugin management.

**Fix:**
Add the plugin declaration in [android/settings.gradle.kts](file:///mnt/6AF6AC44F6AC11FD/anaT3bt/NutriVision-AI-Driven-Dietary-Health-Assistant-T4/android/settings.gradle.kts):
```kotlin
plugins {
    ...
    id("com.google.firebase.crashlytics") version "3.0.2" apply false
}
```

**Status:** ✅ Resolved (Verified by building the debug APK successfully).

---

## Issue #3 — Missing `libsecret-1` System Dependency (Linux)

**Date:** 2026-07-09

**Error:**
```
CMake Error at /usr/share/cmake/Modules/FindPkgConfig.cmake:645 (message):
  The following required packages were not found:

   - libsecret-1>=0.18.4
```

**Cause:** The `flutter_secure_storage_linux` plugin requires `libsecret-1` to store credentials securely on Linux. Fedora doesn't ship it by default.

**Fix:**
```bash
sudo dnf install libsecret-devel
```

This installs the development headers and pkg-config file for `libsecret-1`, allowing CMake to find the package.

**Status:** ✅ Resolved
