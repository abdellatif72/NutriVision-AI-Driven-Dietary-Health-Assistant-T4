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
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
          settings: settings,
        );
    }
  }
}
