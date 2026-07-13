import 'package:afia/app/router/route_names.dart';
import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/features/main/presentation/cubit/home_cubit.dart';
import 'package:afia/features/main/presentation/pages/home_page.dart';
import 'package:afia/features/meals/presentation/pages/meals_page.dart';
import 'package:afia/features/main/presentation/widgets/afia_bottom_nav.dart';
import 'package:afia/features/main/presentation/widgets/calories_progress_card.dart';
import 'package:afia/features/main/presentation/widgets/daily_progress_card.dart';
import 'package:afia/features/main/presentation/widgets/greeting_header.dart';
import 'package:afia/features/main/presentation/widgets/metric_card.dart';
import 'package:afia/features/main/presentation/widgets/todays_meals_list.dart';
import 'package:afia/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:afia/features/auth/presentation/bloc/auth_event.dart';
import 'package:afia/features/auth/presentation/bloc/auth_state.dart';
import 'package:afia/features/auth/domain/entities/auth_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

class FakeAuthBloc extends Bloc<AuthEvent, AuthState> implements AuthBloc {
  FakeAuthBloc(AuthState initialState) : super(initialState);
}

Widget wrapInApp(Widget child) {
  return MaterialApp(
    home: BlocProvider<AuthBloc>.value(
      value: FakeAuthBloc(
        const AuthAuthenticated(
          AuthUser(id: '1', email: 'sara@example.com', name: 'Sara'),
        ),
      ),
      child: child,
    ),
  );
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('HomePage', () {
    test(
      'HomeCubit emits success state with mock data after loadMockDashboard',
      () {
        final cubit = HomeCubit();
        expect(cubit.state.status, HomeStatus.initial);

        cubit.loadMockDashboard();
        expect(cubit.state.status, HomeStatus.success);
        expect(cubit.state.userName, 'Sara');
        expect(cubit.state.steps, 8432);
        expect(cubit.state.meals.length, 3);
      },
    );

    testWidgets('renders all main sections with mock data', (tester) async {
      await tester.pumpWidget(wrapInApp(const HomePage()));
      await tester.pumpAndSettle();

      // Greeting header
      expect(find.byType(GreetingHeader), findsOneWidget);
      expect(find.text('Hi, Sara'), findsOneWidget);
      expect(find.text("Let's make today amazing!"), findsOneWidget);

      // Daily progress card
      expect(find.byType(DailyProgressCard), findsOneWidget);
      expect(find.text('Daily Progress'), findsOneWidget);
      expect(find.text('78'), findsOneWidget);

      // Metric cards
      expect(find.byType(MetricCard), findsNWidgets(3));
      expect(find.text('Steps'), findsOneWidget);
      expect(find.text('8,432'), findsOneWidget);
      expect(find.text('/10,000'), findsOneWidget);
      expect(find.text('Water'), findsOneWidget);
      expect(find.text('1.6'), findsOneWidget);
      expect(find.text('/2.5 L'), findsOneWidget);
      expect(find.text('Heart Rate'), findsOneWidget);
      expect(find.text('72'), findsOneWidget);
      expect(find.text('bpm'), findsOneWidget);
      expect(find.text('Resting'), findsOneWidget);

      // Calories card
      expect(find.byType(CaloriesProgressCard), findsOneWidget);
      expect(find.text('Calories'), findsOneWidget);
      expect(find.text('1420'), findsOneWidget);
      expect(find.text('/ 2000 kcal'), findsOneWidget);

      // Scroll down to meals section
      final listView = find.byType(ListView);
      await tester.drag(listView, const Offset(0, -500));
      await tester.pumpAndSettle();

      // Meals section
      expect(find.byType(TodaysMealsList), findsOneWidget);
      expect(find.text("Today's Meals"), findsOneWidget);
      expect(find.text('See all'), findsOneWidget);
    });

    testWidgets('renders meal entries correctly', (tester) async {
      await tester.pumpWidget(wrapInApp(const HomePage()));
      await tester.pumpAndSettle();

      // Scroll down to meals section
      final listView = find.byType(ListView);
      await tester.drag(listView, const Offset(0, -500));
      await tester.pumpAndSettle();

      // Meal titles
      expect(find.text('Breakfast'), findsOneWidget);
      expect(find.text('Lunch'), findsOneWidget);
      expect(find.text('Dinner'), findsOneWidget);

      // Logged meals show calories
      expect(find.text('420 kcal'), findsOneWidget);
      expect(find.text('680 kcal'), findsOneWidget);

      // Unlogged dinner shows placeholder
      expect(find.text('Not logged yet'), findsOneWidget);

      // Descriptions for logged meals
      expect(find.text('Oatmeal with berries'), findsOneWidget);
      expect(find.text('Koshari + salad'), findsOneWidget);
    });

    testWidgets('shows notification icon in greeting header', (tester) async {
      await tester.pumpWidget(wrapInApp(const HomePage()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
    });

    testWidgets('shows eco icon in daily progress card', (tester) async {
      await tester.pumpWidget(wrapInApp(const HomePage()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.eco), findsOneWidget);
    });

    testWidgets('shows fire icon in calories card', (tester) async {
      await tester.pumpWidget(wrapInApp(const HomePage()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.local_fire_department_rounded), findsOneWidget);
    });

    testWidgets('shows metric card icons', (tester) async {
      await tester.pumpWidget(wrapInApp(const HomePage()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.directions_walk_rounded), findsOneWidget);
      expect(find.byIcon(Icons.water_drop_rounded), findsOneWidget);
      expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
    });

    testWidgets('renders bottom navigation bar with 4 tabs', (tester) async {
      await tester.pumpWidget(wrapInApp(const HomePage()));
      await tester.pumpAndSettle();

      expect(find.byType(AfiaBottomNav), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Meals'), findsOneWidget);
      expect(find.text('Chat'), findsOneWidget);
      expect(find.text('More'), findsOneWidget);
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
    });

    testWidgets('bottom nav highlights Home tab by default', (tester) async {
      await tester.pumpWidget(wrapInApp(const HomePage()));
      await tester.pumpAndSettle();

      final homeTab = tester.widget<Icon>(find.byIcon(Icons.home_rounded));
      expect(homeTab.color, AfiaColors.primary);
    });

    testWidgets('tapping Meals tab navigates to the meals screen', (
      tester,
    ) async {
      await tester.pumpWidget(
        BlocProvider<AuthBloc>.value(
          value: FakeAuthBloc(
            const AuthAuthenticated(
              AuthUser(id: '1', email: 'sara@example.com', name: 'Sara'),
            ),
          ),
          child: MaterialApp(
            home: const HomePage(),
            routes: {
              RouteNames.meals: (_) => const MealsPage(),
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Meals'));
      await tester.pumpAndSettle();

      expect(find.byType(MealsPage), findsOneWidget);
      expect(find.text('Meals'), findsWidgets);
    });
  });
}
