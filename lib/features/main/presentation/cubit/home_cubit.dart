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
  HomeCubit() : super(const HomeState());

  void loadMockDashboard() {
    emit(
      const HomeState(
        status: HomeStatus.success,
        greeting: "Let's make today amazing!",
        userName: 'Sara',
        calories: CalorieSummary(
          percent: 0.71,
          consumed: 1420,
          goal: 2000,
          macros: [
            MacroSummary(label: 'Carb', grams: 142, fillPercent: 0.70),
            MacroSummary(label: 'Protein', grams: 89, fillPercent: 0.60),
            MacroSummary(label: 'Fat', grams: 38, fillPercent: 0.45),
          ],
        ),
        streak: StreakSummary(
          consecutiveDays: 7,
          dayLabels: ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
          completed: [true, true, true, true, true, true, true],
          todayIndex: 6,
        ),
        water: WaterSummary(consumedLiters: 1.6, goalLiters: 2.5),
        steps: 8432,
        stepsGoal: 10000,
        heartRate: 72,
        heartRateStatus: 'Resting',
        meals: [
          MealEntry(
            slot: MealSlot.breakfast,
            title: 'Breakfast',
            emoji: '☀️',
            imagePath: 'assets/images/breakfast_oatmeal.png',
            description: 'Oatmeal with berries',
            calories: 420,
          ),
          MealEntry(
            slot: MealSlot.lunch,
            title: 'Lunch',
            emoji: '🌤️',
            description: 'Koshari + salad',
            calories: 680,
          ),
          MealEntry(
            slot: MealSlot.dinner,
            title: 'Dinner',
            emoji: '🌙',
          ),
        ],
      ),
    );
  }
}
