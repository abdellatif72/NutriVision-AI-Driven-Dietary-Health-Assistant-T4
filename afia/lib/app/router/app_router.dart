import 'package:afia/app/router/route_names.dart';
import 'package:afia/features/ai/presentation/pages/ai_page.dart';
import 'package:afia/features/auth/presentation/pages/auth_page.dart';
import 'package:afia/features/auth/presentation/pages/login_page.dart';
import 'package:afia/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:afia/features/auth/presentation/pages/goal_selection_page.dart';
import 'package:afia/features/auth/presentation/pages/physical_information_page.dart';
import 'package:afia/features/auth/presentation/pages/signup_page.dart';
import 'package:afia/features/explore/presentation/pages/explore_page.dart';
import 'package:afia/features/main/presentation/pages/main_shell_page.dart';
import 'package:afia/features/main/presentation/pages/progress_page.dart';
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
      case RouteNames.authLogin:
        return MaterialPageRoute<void>(
          builder: (_) => const LoginPage(),
          settings: settings,
        );
      case RouteNames.authSignup:
        return MaterialPageRoute<void>(
          builder: (_) => const SignupPage(),
          settings: settings,
        );
      case RouteNames.authPhysicalInformation:
        return MaterialPageRoute<void>(
          builder: (_) => const PhysicalInformationPage(),
          settings: settings,
        );
      case RouteNames.authGoalSelection:
        return MaterialPageRoute<void>(
          builder: (_) => const GoalSelectionPage(),
          settings: settings,
        );
      case RouteNames.authForgotPassword:
        return MaterialPageRoute<void>(
          builder: (_) => const ForgotPasswordPage(),
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
      case RouteNames.progress:
        return MaterialPageRoute<void>(
          builder: (_) => const ProgressPage(),
          settings: settings,
        );
      case RouteNames.profile:
      case RouteNames.goals:
      case RouteNames.reminders:
      case RouteNames.connectedApps:
      case RouteNames.helpSupport:
        return MaterialPageRoute<void>(
          builder: (_) => MoreSectionPage(title: _titleForRoute(settings.name)),
          settings: settings,
        );
      case RouteNames.settings:
        return MaterialPageRoute<void>(
          builder: (_) => const SettingsPage(),
          settings: settings,
        );
      default:
        return MaterialPageRoute<void>(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
          settings: settings,
        );
    }
  }

  static String _titleForRoute(String? routeName) {
    switch (routeName) {
      case RouteNames.profile:
        return 'Profile';
      case RouteNames.goals:
        return 'Goals';
      case RouteNames.progress:
        return 'Progress';
      case RouteNames.reminders:
        return 'Reminders';
      case RouteNames.connectedApps:
        return 'Connected Apps';
      case RouteNames.helpSupport:
        return 'Help & Support';
      default:
        return 'More';
    }
  }
}
