import 'package:afia/app/router/route_names.dart';
import 'package:afia/features/ai/presentation/pages/ai_page.dart';
import 'package:afia/features/auth/presentation/pages/auth_page.dart';
import 'package:afia/features/auth/presentation/pages/login_page.dart';
import 'package:afia/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:afia/features/auth/presentation/pages/goal_selection_page.dart';
import 'package:afia/features/auth/presentation/pages/physical_information_page.dart';
import 'package:afia/features/auth/presentation/pages/signup_page.dart';
import 'package:afia/features/explore/presentation/pages/explore_page.dart';
import 'package:afia/features/main/presentation/cubit/main_shell_cubit.dart';
import 'package:afia/features/main/presentation/pages/main_shell_page.dart';
import 'package:afia/features/main/presentation/pages/progress_page.dart';
import 'package:afia/features/meals/presentation/pages/meal_search_page.dart';
import 'package:afia/features/more/presentation/pages/about_page.dart';
import 'package:afia/features/more/presentation/pages/change_password_page.dart';
import 'package:afia/features/more/presentation/pages/diet_preferences_page.dart';
import 'package:afia/features/more/presentation/pages/edit_profile_page.dart';
import 'package:afia/features/more/presentation/pages/faqs_page.dart';
import 'package:afia/features/more/presentation/pages/help_page.dart';
import 'package:afia/features/more/presentation/pages/notifications_page.dart';
import 'package:afia/features/more/presentation/pages/personal_information_page.dart';
import 'package:afia/features/more/presentation/pages/profile_page.dart';
import 'package:afia/features/more/presentation/pages/settings_page.dart';
import 'package:afia/features/onboard/presentation/pages/onboard_page.dart';
import 'package:afia/features/water/presentation/pages/water_recording_page.dart';
import 'package:flutter/material.dart';

abstract final class AppRouter {
  static const initialRoute = '/';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
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
          builder: (_) => const MainShellPage(initialTab: MainTab.meals),
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
      case RouteNames.chat:
        return MaterialPageRoute<void>(
          builder: (_) => const MainShellPage(initialTab: MainTab.chat),
          settings: settings,
        );
      case RouteNames.explore:
        return MaterialPageRoute<void>(
          builder: (_) => const ExplorePage(),
          settings: settings,
        );
      case RouteNames.more:
        return MaterialPageRoute<void>(
          builder: (_) => const MainShellPage(initialTab: MainTab.more),
          settings: settings,
        );
      case RouteNames.progress:
        return MaterialPageRoute<void>(
          builder: (_) => const ProgressPage(),
          settings: settings,
        );
      case RouteNames.profile:
        return MaterialPageRoute<void>(
          builder: (_) => const ProfilePage(),
          settings: settings,
        );
      case RouteNames.editProfile:
        return MaterialPageRoute<void>(
          builder: (_) => const EditProfilePage(),
          settings: settings,
        );
      case RouteNames.personalInformation:
        return MaterialPageRoute<void>(
          builder: (_) => const PersonalInformationPage(),
          settings: settings,
        );
      case RouteNames.dietPreferences:
        return MaterialPageRoute<void>(
          builder: (_) => const DietPreferencesPage(),
          settings: settings,
        );
      case RouteNames.settings:
        return MaterialPageRoute<void>(
          builder: (_) => const SettingsPage(),
          settings: settings,
        );
      case RouteNames.notifications:
        return MaterialPageRoute<void>(
          builder: (_) => const NotificationsPage(),
          settings: settings,
        );
      case RouteNames.changePassword:
        return MaterialPageRoute<void>(
          builder: (_) => const ChangePasswordPage(),
          settings: settings,
        );
      case RouteNames.faqs:
        return MaterialPageRoute<void>(
          builder: (_) => const FaqsPage(),
          settings: settings,
        );
      case RouteNames.help:
        return MaterialPageRoute<void>(
          builder: (_) => const HelpPage(),
          settings: settings,
        );
      case RouteNames.about:
        return MaterialPageRoute<void>(
          builder: (_) => const AboutPage(),
          settings: settings,
        );
      case RouteNames.goals:
      case RouteNames.reminders:
      case RouteNames.connectedApps:
      case RouteNames.helpSupport:
        return MaterialPageRoute<void>(
          builder: (_) => const MainShellPage(initialTab: MainTab.more),
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
}
