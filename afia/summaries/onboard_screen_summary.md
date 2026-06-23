# Onboard / Welcome Screen — Implementation Summary

## What was built

The first screen users see when launching Afia: a branded welcome page with hero copy, a generated character illustration, and CTAs to start onboarding or log in.

![Onboard illustration](/home/abdellatif/.gemini/antigravity/brain/a33bea70-5dfa-42e5-9627-8e1e41162f23/onboard_illustration_1782171663693.png)

## Files Changed

### New files
| File | Purpose |
|---|---|
| [onboard_logo.dart](file:///mnt/6AF6AC44F6AC11FD/DEPI/afia/lib/features/onboard/presentation/widgets/onboard_logo.dart) | Leaf icon + "Afia" wordmark |
| [onboard_hero_text.dart](file:///mnt/6AF6AC44F6AC11FD/DEPI/afia/lib/features/onboard/presentation/widgets/onboard_hero_text.dart) | "Healthy habits, smarter you." + subtitle |
| [onboard_illustration.dart](file:///mnt/6AF6AC44F6AC11FD/DEPI/afia/lib/features/onboard/presentation/widgets/onboard_illustration.dart) | Character image + 4 floating accent badges |
| [onboard_bottom_section.dart](file:///mnt/6AF6AC44F6AC11FD/DEPI/afia/lib/features/onboard/presentation/widgets/onboard_bottom_section.dart) | "Get Started" button, login link, page dots |
| `assets/images/onboard_illustration.png` | Generated 3D character illustration |

### Modified files

```diff:onboard_page.dart
import 'package:afia/core/widgets/feature_placeholder_page.dart';
import 'package:flutter/material.dart';

class OnboardPage extends StatelessWidget {
  const OnboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderPage(
      title: 'Onboarding',
      description: 'Intro, profile setup, and guided onboarding flow screens live here.',
    );
  }
}
===
import 'package:afia/app/router/route_names.dart';
import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/features/onboard/presentation/widgets/onboard_bottom_section.dart';
import 'package:afia/features/onboard/presentation/widgets/onboard_hero_text.dart';
import 'package:afia/features/onboard/presentation/widgets/onboard_illustration.dart';
import 'package:afia/features/onboard/presentation/widgets/onboard_logo.dart';
import 'package:flutter/material.dart';

/// First screen the user sees. A visual welcome introducing the Afia
/// brand and value proposition, with a CTA to start onboarding or log in.
class OnboardPage extends StatelessWidget {
  const OnboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AfiaColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AfiaSpacing.pageMargin,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AfiaSpacing.xl),

              // ── Afia branding logo ──
              const OnboardLogo(),

              const SizedBox(height: AfiaSpacing.xxl),

              // ── Headline + subtitle ──
              const OnboardHeroText(),

              // ── Central illustration (expands to fill) ──
              const Expanded(
                child: Center(
                  child: OnboardIllustration(),
                ),
              ),

              // ── Bottom CTA area ──
              OnboardBottomSection(
                onGetStarted: () {
                  Navigator.of(context).pushReplacementNamed(
                    RouteNames.auth,
                  );
                },
                onLogIn: () {
                  Navigator.of(context).pushReplacementNamed(
                    RouteNames.auth,
                  );
                },
              ),

              const SizedBox(height: AfiaSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

```

```diff:main.dart
import 'package:afia/app/app.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AfiaApp());
}
===
import 'package:afia/app/app.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AfiaTypography.fontFamily = GoogleFonts.plusJakartaSans().fontFamily;
  runApp(const AfiaApp());
}
```

```diff:app_router.dart
import 'package:afia/app/router/route_names.dart';
import 'package:afia/features/ai/presentation/pages/ai_page.dart';
import 'package:afia/features/auth/presentation/pages/auth_page.dart';
import 'package:afia/features/explore/presentation/pages/explore_page.dart';
import 'package:afia/features/main/presentation/pages/main_shell_page.dart';
import 'package:afia/features/meals/presentation/pages/meal_search_page.dart';
import 'package:afia/features/meals/presentation/pages/meals_page.dart';
import 'package:afia/features/more/presentation/pages/more_page.dart';
import 'package:afia/features/onboard/presentation/pages/onboard_page.dart';
import 'package:afia/features/water/presentation/pages/water_recording_page.dart';
import 'package:flutter/material.dart';

abstract final class AppRouter {
  static const initialRoute = RouteNames.auth;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.auth:
        return MaterialPageRoute<void>(
          builder: (_) => const AuthPage(),
          settings: settings,
        );
      case RouteNames.onboard:
        return MaterialPageRoute<void>(
          builder: (_) => const OnboardPage(),
          settings: settings,
        );
      case RouteNames.main:
        return MaterialPageRoute<void>(
          builder: (_) => const MainShellPage(),
          settings: settings,
        );
      case RouteNames.meals:
        return MaterialPageRoute<void>(
          builder: (_) => const MealsPage(),
          settings: settings,
        );
      case RouteNames.mealSearch:
        return MaterialPageRoute<void>(
          builder: (_) => const MealSearchPage(),
          settings: settings,
        );
      case RouteNames.water:
        return MaterialPageRoute<void>(
          builder: (_) => const WaterRecordingPage(),
          settings: settings,
        );
      case RouteNames.ai:
        return MaterialPageRoute<void>(
          builder: (_) => const AiPage(),
          settings: settings,
        );
      case RouteNames.explore:
        return MaterialPageRoute<void>(
          builder: (_) => const ExplorePage(),
          settings: settings,
        );
      case RouteNames.more:
        return MaterialPageRoute<void>(
          builder: (_) => const MorePage(),
          settings: settings,
        );
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
          settings: settings,
        );
    }
  }
}
===
import 'package:afia/app/router/route_names.dart';
import 'package:afia/features/ai/presentation/pages/ai_page.dart';
import 'package:afia/features/auth/presentation/pages/auth_page.dart';
import 'package:afia/features/explore/presentation/pages/explore_page.dart';
import 'package:afia/features/main/presentation/pages/main_shell_page.dart';
import 'package:afia/features/meals/presentation/pages/meal_search_page.dart';
import 'package:afia/features/meals/presentation/pages/meals_page.dart';
import 'package:afia/features/more/presentation/pages/more_page.dart';
import 'package:afia/features/onboard/presentation/pages/onboard_page.dart';
import 'package:afia/features/water/presentation/pages/water_recording_page.dart';
import 'package:flutter/material.dart';

abstract final class AppRouter {
  static const initialRoute = RouteNames.onboard;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.auth:
        return MaterialPageRoute<void>(
          builder: (_) => const AuthPage(),
          settings: settings,
        );
      case RouteNames.onboard:
        return MaterialPageRoute<void>(
          builder: (_) => const OnboardPage(),
          settings: settings,
        );
      case RouteNames.main:
        return MaterialPageRoute<void>(
          builder: (_) => const MainShellPage(),
          settings: settings,
        );
      case RouteNames.meals:
        return MaterialPageRoute<void>(
          builder: (_) => const MealsPage(),
          settings: settings,
        );
      case RouteNames.mealSearch:
        return MaterialPageRoute<void>(
          builder: (_) => const MealSearchPage(),
          settings: settings,
        );
      case RouteNames.water:
        return MaterialPageRoute<void>(
          builder: (_) => const WaterRecordingPage(),
          settings: settings,
        );
      case RouteNames.ai:
        return MaterialPageRoute<void>(
          builder: (_) => const AiPage(),
          settings: settings,
        );
      case RouteNames.explore:
        return MaterialPageRoute<void>(
          builder: (_) => const ExplorePage(),
          settings: settings,
        );
      case RouteNames.more:
        return MaterialPageRoute<void>(
          builder: (_) => const MorePage(),
          settings: settings,
        );
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
          settings: settings,
        );
    }
  }
}
```

```diff:pubspec.yaml
name: afia
description: "A new Flutter project."
# The following line prevents the package from being accidentally published to
# pub.dev using `flutter pub publish`. This is preferred for private packages.
publish_to: 'none' # Remove this line if you wish to publish to pub.dev

# The following defines the version and build number for your application.
# A version number is three numbers separated by dots, like 1.2.43
# followed by an optional build number separated by a +.
# Both the version and the builder number may be overridden in flutter
# build by specifying --build-name and --build-number, respectively.
# In Android, build-name is used as versionName while build-number used as versionCode.
# Read more about Android versioning at https://developer.android.com/studio/publish/versioning
# In iOS, build-name is used as CFBundleShortVersionString while build-number is used as CFBundleVersion.
# Read more about iOS versioning at
# https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html
# In Windows, build-name is used as the major, minor, and patch parts
# of the product and file versions while build-number is used as the build suffix.
version: 1.0.0+1

environment:
  sdk: ^3.10.7

# Dependencies specify other packages that your package needs in order to work.
# To automatically upgrade your package dependencies to the latest versions
# consider running `flutter pub upgrade --major-versions`. Alternatively,
# dependencies can be manually updated by changing the version numbers below to
# the latest version available on pub.dev. To see which dependencies have newer
# versions available, run `flutter pub outdated`.
dependencies:
  flutter:
    sdk: flutter

  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^1.0.8
  flutter_bloc: ^8.1.6
  equatable: ^2.0.5
  bloc_concurrency: ^0.2.5
  stream_transform: ^2.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter

  # The "flutter_lints" package below contains a set of recommended lints to
  # encourage good coding practices. The lint set provided by the package is
  # activated in the `analysis_options.yaml` file located at the root of your
  # package. See that file for information about deactivating specific lint
  # rules and activating additional ones.
  flutter_lints: ^6.0.0

# For information on the generic Dart part of this file, see the
# following page: https://dart.dev/tools/pub/pubspec

# The following section is specific to Flutter packages.
flutter:

  # The following line ensures that the Material Icons font is
  # included with your application, so that you can use the icons in
  # the material Icons class.
  uses-material-design: true

  # To add assets to your application, add an assets section, like this:
  # assets:
  #   - images/a_dot_burr.jpeg
  #   - images/a_dot_ham.jpeg

  # An image asset can refer to one or more resolution-specific "variants", see
  # https://flutter.dev/to/resolution-aware-images

  # For details regarding adding assets from package dependencies, see
  # https://flutter.dev/to/asset-from-package

  # To add custom fonts to your application, add a fonts section here,
  # in this "flutter" section. Each entry in this list should have a
  # "family" key with the font family name, and a "fonts" key with a
  # list giving the asset and other descriptors for the font. For
  # example:
  # fonts:
  #   - family: Schyler
  #     fonts:
  #       - asset: fonts/Schyler-Regular.ttf
  #       - asset: fonts/Schyler-Italic.ttf
  #         style: italic
  #   - family: Trajan Pro
  #     fonts:
  #       - asset: fonts/TrajanPro.ttf
  #       - asset: fonts/TrajanPro_Bold.ttf
  #         weight: 700
  #
  # For details regarding fonts from package dependencies,
  # see https://flutter.dev/to/font-from-package
===
name: afia
description: "A new Flutter project."
# The following line prevents the package from being accidentally published to
# pub.dev using `flutter pub publish`. This is preferred for private packages.
publish_to: 'none' # Remove this line if you wish to publish to pub.dev

# The following defines the version and build number for your application.
# A version number is three numbers separated by dots, like 1.2.43
# followed by an optional build number separated by a +.
# Both the version and the builder number may be overridden in flutter
# build by specifying --build-name and --build-number, respectively.
# In Android, build-name is used as versionName while build-number used as versionCode.
# Read more about Android versioning at https://developer.android.com/studio/publish/versioning
# In iOS, build-name is used as CFBundleShortVersionString while build-number is used as CFBundleVersion.
# Read more about iOS versioning at
# https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html
# In Windows, build-name is used as the major, minor, and patch parts
# of the product and file versions while build-number is used as the build suffix.
version: 1.0.0+1

environment:
  sdk: ^3.10.7

# Dependencies specify other packages that your package needs in order to work.
# To automatically upgrade your package dependencies to the latest versions
# consider running `flutter pub upgrade --major-versions`. Alternatively,
# dependencies can be manually updated by changing the version numbers below to
# the latest version available on pub.dev. To see which dependencies have newer
# versions available, run `flutter pub outdated`.
dependencies:
  flutter:
    sdk: flutter

  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^1.0.8
  google_fonts: ^6.2.1
  flutter_bloc: ^8.1.6
  equatable: ^2.0.5
  bloc_concurrency: ^0.2.5
  stream_transform: ^2.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter

  # The "flutter_lints" package below contains a set of recommended lints to
  # encourage good coding practices. The lint set provided by the package is
  # activated in the `analysis_options.yaml` file located at the root of your
  # package. See that file for information about deactivating specific lint
  # rules and activating additional ones.
  flutter_lints: ^6.0.0

# For information on the generic Dart part of this file, see the
# following page: https://dart.dev/tools/pub/pubspec

# The following section is specific to Flutter packages.
flutter:

  # The following line ensures that the Material Icons font is
  # included with your application, so that you can use the icons in
  # the material Icons class.
  uses-material-design: true

  assets:
    - assets/images/

  # An image asset can refer to one or more resolution-specific "variants", see
  # https://flutter.dev/to/resolution-aware-images

  # For details regarding adding assets from package dependencies, see
  # https://flutter.dev/to/asset-from-package

  # To add custom fonts to your application, add a fonts section here,
  # in this "flutter" section. Each entry in this list should have a
  # "family" key with the font family name, and a "fonts" key with a
  # list giving the asset and other descriptors for the font. For
  # example:
  # fonts:
  #   - family: Schyler
  #     fonts:
  #       - asset: fonts/Schyler-Regular.ttf
  #       - asset: fonts/Schyler-Italic.ttf
  #         style: italic
  #   - family: Trajan Pro
  #     fonts:
  #       - asset: fonts/TrajanPro.ttf
  #       - asset: fonts/TrajanPro_Bold.ttf
  #         weight: 700
  #
  # For details regarding fonts from package dependencies,
  # see https://flutter.dev/to/font-from-package
```

## Architecture Decisions

| Decision | Rationale |
|---|---|
| **No Cubit/Bloc** for this screen | Purely static UI with no state to manage — a `StatelessWidget` is appropriate per AGENTS.md |
| **Callbacks for navigation** | `OnboardBottomSection` receives `onGetStarted` / `onLogIn` callbacks so routing stays in the page layer |
| **Font wired in `main.dart`** | Follows `DESIGN_SYSTEM.md` recommendation; `AfiaTypography.fontFamily` is set once before `runApp` |
| **`WidgetsFlutterBinding.ensureInitialized()`** | Required before `google_fonts` accesses platform channels |
| **Initial route → `/onboard`** | So the welcome screen is the first thing users see |
| **Both CTAs → `/auth`** | Temporary — "Get Started" should eventually navigate to the onboarding questionnaire once built |

## Verification

- ✅ `flutter analyze` — no issues
- ✅ `dart format` — all files formatted
- ✅ `flutter run -d linux` — builds and launches successfully
