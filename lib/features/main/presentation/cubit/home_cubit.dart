import 'dart:async';
import 'package:afia/features/meals/data/datasources/meal_remote_datasource.dart';
import 'package:afia/features/water/data/datasources/water_remote_datasource.dart';
import 'package:afia/features/more/data/datasources/more_remote_datasource.dart';
import 'package:afia/features/meals/presentation/cubit/meals_cubit.dart';
import 'package:afia/features/meals/presentation/cubit/meals_state.dart';
import 'package:afia/features/water/presentation/cubit/water_recording_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum HomeStatus { initial, loading, success, failure }

enum MealSlot { breakfast, lunch, dinner }

class MacroSummary extends Equatable {
  const MacroSummary({
    required this.label,
    required this.grams,
    required this.fillPercent,
  });

  final String label;
  final int grams;
  final double fillPercent;

  @override
  List<Object?> get props => [label, grams, fillPercent];
}

class CalorieSummary extends Equatable {
  const CalorieSummary({
    required this.percent,
    required this.macros,
    required this.consumed,
    required this.goal,
  });

  final double percent;
  final List<MacroSummary> macros;
  final int consumed;
  final int goal;

  @override
  List<Object?> get props => [percent, macros, consumed, goal];
}

class StreakSummary extends Equatable {
  const StreakSummary({
    required this.consecutiveDays,
    required this.dayLabels,
    required this.completed,
    required this.todayIndex,
  });

  final int consecutiveDays;
  final List<String> dayLabels;
  final List<bool> completed;
  final int todayIndex;

  @override
  List<Object?> get props =>
      [consecutiveDays, dayLabels, completed, todayIndex];
}

class WaterSummary extends Equatable {
  const WaterSummary({
    required this.consumedLiters,
    required this.goalLiters,
  });

  final double consumedLiters;
  final double goalLiters;

  double get percent =>
      goalLiters <= 0 ? 0 : (consumedLiters / goalLiters).clamp(0.0, 1.0);

  @override
  List<Object?> get props => [consumedLiters, goalLiters];
}

class MealEntry extends Equatable {
  const MealEntry({
    required this.slot,
    required this.title,
    required this.emoji,
    this.imagePath,
    this.description,
    this.calories,
  });

  final MealSlot slot;
  final String title;
  final String emoji;
  final String? imagePath;
  final String? description;
  final int? calories;

  bool get isLogged => calories != null;

  @override
  List<Object?> get props => [slot, title, emoji, imagePath, description, calories];
}

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.greeting = '',
    this.userName = '',
    this.calories,
    this.streak,
    this.water,
    this.steps,
    this.stepsGoal,
    this.heartRate,
    this.heartRateStatus,
    this.meals = const [],
  });

  final HomeStatus status;
  final String greeting;
  final String userName;
  final CalorieSummary? calories;
  final StreakSummary? streak;
  final WaterSummary? water;
  final int? steps;
  final int? stepsGoal;
  final int? heartRate;
  final String? heartRateStatus;
  final List<MealEntry> meals;

  HomeState copyWith({
    HomeStatus? status,
    String? greeting,
    String? userName,
    CalorieSummary? calories,
    StreakSummary? streak,
    WaterSummary? water,
    int? steps,
    int? stepsGoal,
    int? heartRate,
    String? heartRateStatus,
    List<MealEntry>? meals,
  }) {
    return HomeState(
      status: status ?? this.status,
      greeting: greeting ?? this.greeting,
      userName: userName ?? this.userName,
      calories: calories ?? this.calories,
      streak: streak ?? this.streak,
      water: water ?? this.water,
      steps: steps ?? this.steps,
      stepsGoal: stepsGoal ?? this.stepsGoal,
      heartRate: heartRate ?? this.heartRate,
      heartRateStatus: heartRateStatus ?? this.heartRateStatus,
      meals: meals ?? this.meals,
    );
  }

  @override
  List<Object?> get props => [
        status,
        greeting,
        userName,
        calories,
        streak,
        water,
        steps,
        stepsGoal,
        heartRate,
        heartRateStatus,
        meals,
      ];
}

class HomeCubit extends Cubit<HomeState> {
  final MealRemoteDataSource _mealDataSource;
  final WaterRemoteDataSource _waterDataSource;
  final MoreRemoteDataSource _moreDataSource;
  final MealsCubit _mealsCubit;
  final WaterRecordingCubit _waterRecordingCubit;
  final String? userName;
  late final StreamSubscription<MealsState> _mealsSubscription;
  late final StreamSubscription<WaterRecordingState> _waterSubscription;

  HomeCubit({
    required MealRemoteDataSource mealDataSource,
    required WaterRemoteDataSource waterDataSource,
    required MoreRemoteDataSource moreDataSource,
    required MealsCubit mealsCubit,
    required WaterRecordingCubit waterRecordingCubit,
    this.userName,
  })  : _mealDataSource = mealDataSource,
        _waterDataSource = waterDataSource,
        _moreDataSource = moreDataSource,
        _mealsCubit = mealsCubit,
        _waterRecordingCubit = waterRecordingCubit,
        super(const HomeState()) {
    _mealsSubscription = _mealsCubit.stream.listen((mealsState) {
      if (mealsState.status == MealsStatus.success || mealsState.status == MealsStatus.empty) {
        loadDashboardData();
      }
    });
    _waterSubscription = _waterRecordingCubit.stream.listen((waterState) {
      loadDashboardData();
    });
  }

  Future<void> loadDashboardData() async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final today = DateTime.now();

      // 1. Fetch calorie goal & diet preferences
      final dietPrefs = await _moreDataSource.getDietPreferences();
      final calorieGoal = dietPrefs.calorieTarget ?? 2000;
      final carbsPct = dietPrefs.carbsPct ?? 50;
      final proteinPct = dietPrefs.proteinPct ?? 20;
      final fatPct = dietPrefs.fatPct ?? 30;

      // 2. Fetch today's logged meals
      final loggedMeals = await _mealDataSource.getLoggedMeals(today);

      // Sum calories & macros consumed
      int consumedCalories = 0;
      int consumedCarbs = 0;
      int consumedProtein = 0;
      int consumedFat = 0;

      for (final meal in loggedMeals) {
        consumedCalories += meal.calories;
        consumedProtein += meal.proteinG ?? (meal.calories * 0.25 / 4).round();
        consumedCarbs += meal.carbsG ?? (meal.calories * 0.50 / 4).round();
        consumedFat += meal.fatG ?? (meal.calories * 0.25 / 9).round();
      }

      final goalCarbs = (calorieGoal * carbsPct / 100 / 4).round();
      final goalProtein = (calorieGoal * proteinPct / 100 / 4).round();
      final goalFat = (calorieGoal * fatPct / 100 / 9).round();

      // 3. Fetch today's water logs
      final waterGoal = await _waterDataSource.getWaterGoal();
      final waterLogs = await _waterDataSource.getWaterLogs(today);
      final waterConsumedMl = waterLogs.fold<int>(0, (sum, e) => sum + e.amountMl);

      // 4. Fetch user profile streak
      final profile = await _moreDataSource.getProfile();
      final streakDays = profile.streakDays ?? 0;

      // 5. Map meals to slot entries
      final breakfastMeals = loggedMeals.where((m) => m.slotType == 'breakfast').toList();
      final lunchMeals = loggedMeals.where((m) => m.slotType == 'lunch').toList();
      final dinnerMeals = loggedMeals.where((m) => m.slotType == 'dinner').toList();

      final mealsList = [
        MealEntry(
          slot: MealSlot.breakfast,
          title: 'Breakfast',
          emoji: '☀️',
          description: breakfastMeals.isEmpty ? null : breakfastMeals.map((m) => m.name).join(', '),
          calories: breakfastMeals.isEmpty ? null : breakfastMeals.fold<int>(0, (sum, m) => sum + m.calories),
        ),
        MealEntry(
          slot: MealSlot.lunch,
          title: 'Lunch',
          emoji: '🌤️',
          description: lunchMeals.isEmpty ? null : lunchMeals.map((m) => m.name).join(', '),
          calories: lunchMeals.isEmpty ? null : lunchMeals.fold<int>(0, (sum, m) => sum + m.calories),
        ),
        MealEntry(
          slot: MealSlot.dinner,
          title: 'Dinner',
          emoji: '🌙',
          description: dinnerMeals.isEmpty ? null : dinnerMeals.map((m) => m.name).join(', '),
          calories: dinnerMeals.isEmpty ? null : dinnerMeals.fold<int>(0, (sum, m) => sum + m.calories),
        ),
      ];

      emit(
        HomeState(
          status: HomeStatus.success,
          greeting: "Let's make today amazing!",
          userName: (userName == null || userName!.isEmpty) ? 'User' : userName!,
          calories: CalorieSummary(
            percent: calorieGoal <= 0 ? 0.0 : consumedCalories / calorieGoal,
            consumed: consumedCalories,
            goal: calorieGoal,
            macros: [
              MacroSummary(label: 'Carb', grams: consumedCarbs, fillPercent: goalCarbs <= 0 ? 0.0 : (consumedCarbs / goalCarbs).clamp(0.0, 1.0)),
              MacroSummary(label: 'Protein', grams: consumedProtein, fillPercent: goalProtein <= 0 ? 0.0 : (consumedProtein / goalProtein).clamp(0.0, 1.0)),
              MacroSummary(label: 'Fat', grams: consumedFat, fillPercent: goalFat <= 0 ? 0.0 : (consumedFat / goalFat).clamp(0.0, 1.0)),
            ],
          ),
          streak: StreakSummary(
            consecutiveDays: streakDays,
            dayLabels: const ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
            completed: List.generate(7, (i) => i < streakDays),
            todayIndex: 6,
          ),
          water: WaterSummary(consumedLiters: waterConsumedMl / 1000.0, goalLiters: waterGoal / 1000.0),
          steps: 0,
          stepsGoal: 10000,
          heartRate: null,
          heartRateStatus: null,
          meals: mealsList,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }

  @override
  Future<void> close() {
    _mealsSubscription.cancel();
    _waterSubscription.cancel();
    return super.close();
  }
}
