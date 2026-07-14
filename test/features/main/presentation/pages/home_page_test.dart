import 'package:afia/app/router/route_names.dart';
import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/features/main/presentation/cubit/home_cubit.dart';
import 'package:afia/features/main/presentation/pages/home_page.dart';
import 'package:afia/features/meals/presentation/pages/meals_page.dart';
import 'package:afia/features/meals/presentation/cubit/meals_cubit.dart';
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
import 'package:afia/features/meals/data/datasources/meal_remote_datasource.dart';
import 'package:afia/features/meals/data/models/meal_model.dart';
import 'package:afia/features/water/data/datasources/water_remote_datasource.dart';
import 'package:afia/features/water/data/models/water_entry_model.dart';
import 'package:afia/features/water/domain/entities/water_entry.dart';
import 'package:afia/features/more/data/datasources/more_remote_datasource.dart';
import 'package:afia/features/more/domain/entities/diet_preferences.dart';
import 'package:afia/features/more/domain/entities/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get_it/get_it.dart';

class FakeAuthBloc extends Bloc<AuthEvent, AuthState> implements AuthBloc {
  FakeAuthBloc(AuthState initialState) : super(initialState);
}

class MockMealRemoteDataSource extends Mock implements MealRemoteDataSource {}
class MockWaterRemoteDataSource extends Mock implements WaterRemoteDataSource {}
class MockMoreRemoteDataSource extends Mock implements MoreRemoteDataSource {}

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
  late MockMealRemoteDataSource mockMealDS;
  late MockWaterRemoteDataSource mockWaterDS;
  late MockMoreRemoteDataSource mockMoreDS;

  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
    registerFallbackValue(DateTime.now());
  });

  setUp(() {
    mockMealDS = MockMealRemoteDataSource();
    mockWaterDS = MockWaterRemoteDataSource();
    mockMoreDS = MockMoreRemoteDataSource();

    final tDate = DateTime.now();

    // Stub common behaviors
    when(() => mockMoreDS.getDietPreferences()).thenAnswer((_) async => const DietPreferences(calorieTarget: 2000));
    when(() => mockMoreDS.getProfile()).thenAnswer((_) async => UserProfile(id: '1', name: 'Sara', streakDays: 7));
    when(() => mockWaterDS.getWaterGoal()).thenAnswer((_) async => 2500);
    when(() => mockWaterDS.getWaterLogs(any())).thenAnswer((_) async => [
      WaterEntryModel(id: 'w1', timestamp: tDate, amountMl: 1000, preset: WaterPreset.pint),
      WaterEntryModel(id: 'w2', timestamp: tDate, amountMl: 600, preset: WaterPreset.custom),
    ]);

    when(() => mockMealDS.getLoggedMeals(any())).thenAnswer((_) async => [
      MealModel(id: 'm1', name: 'Oatmeal with berries', emoji: '☀️', servingLabel: '1 bowl', calories: 420, slotType: 'breakfast'),
      MealModel(id: 'm2', name: 'Koshari + salad', emoji: '🌤️', servingLabel: '1 plate', calories: 680, slotType: 'lunch'),
    ]);

    // Register them in GetIt sl:
    final sl = GetIt.instance;
    sl.reset(); // Clear old registrations
    
    sl.registerLazySingleton<MealRemoteDataSource>(() => mockMealDS);
    sl.registerLazySingleton<WaterRemoteDataSource>(() => mockWaterDS);
    sl.registerLazySingleton<MoreRemoteDataSource>(() => mockMoreDS);
    
    sl.registerFactoryParam<HomeCubit, String?, void>(
      (userName, _) => HomeCubit(
        mealDataSource: sl(),
        waterDataSource: sl(),
        moreDataSource: sl(),
        userName: userName,
      ),
    );
    sl.registerFactory<MealsCubit>(() => MealsCubit(remoteDataSource: mockMealDS));
  });

  group('HomePage', () {
    test(
      'HomeCubit emits success state with data after loadDashboardData',
      () async {
        final cubit = HomeCubit(
          mealDataSource: mockMealDS,
          waterDataSource: mockWaterDS,
          moreDataSource: mockMoreDS,
          userName: 'Sara',
        );
        expect(cubit.state.status, HomeStatus.initial);

        await cubit.loadDashboardData();
        expect(cubit.state.status, HomeStatus.success);
        expect(cubit.state.userName, 'Sara');
        expect(cubit.state.streak?.consecutiveDays, 7);
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

      // Metric cards
      expect(find.byType(MetricCard), findsNWidgets(3));
      expect(find.text('Steps'), findsOneWidget);
      expect(find.text('Water'), findsOneWidget);
      expect(find.text('1.6'), findsOneWidget);
      expect(find.text('/2.5 L'), findsOneWidget);
      expect(find.text('Heart Rate'), findsOneWidget);

      // Calories card
      expect(find.byType(CaloriesProgressCard), findsOneWidget);
      expect(find.text('Calories'), findsOneWidget);
      expect(find.text('1100'), findsOneWidget); // 420 + 680 = 1100
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
