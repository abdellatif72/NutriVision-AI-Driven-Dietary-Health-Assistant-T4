import 'package:afia/features/meals/domain/entities/meal_summary.dart';
import 'package:equatable/equatable.dart';

enum MealsStatus { initial, loading, success, empty, failure }

class MealSlotDetail extends Equatable {
  final String name;
  final String emoji;
  final String type;
  final List<MealSummary> loggedMeals;

  const MealSlotDetail({
    required this.name,
    required this.emoji,
    required this.type,
    required this.loggedMeals,
  });

  bool get isLogged => loggedMeals.isNotEmpty;

  int get totalCalories => loggedMeals.fold(0, (sum, m) => sum + m.calories);

  int get totalCarbs => loggedMeals.fold(0, (sum, m) => sum + (m.calories * 0.5 / 4).round());
  int get totalProtein => loggedMeals.fold(0, (sum, m) => sum + (m.calories * 0.25 / 4).round());
  int get totalFat => loggedMeals.fold(0, (sum, m) => sum + (m.calories * 0.25 / 9).round());

  MealSlotDetail copyWith({
    List<MealSummary>? loggedMeals,
  }) {
    return MealSlotDetail(
      name: name,
      emoji: emoji,
      type: type,
      loggedMeals: loggedMeals ?? this.loggedMeals,
    );
  }

  @override
  List<Object?> get props => [name, emoji, type, loggedMeals];
}

class MealsState extends Equatable {
  final DateTime selectedDate;
  final int calorieGoal;
  final int consumedCalories;
  final int remainingCalories;
  final List<MealSlotDetail> slots;
  final MealsStatus status;
  final int carbs;
  final int protein;
  final int fat;
  final int carbsGoal;
  final int proteinGoal;
  final int fatGoal;

  const MealsState({
    required this.selectedDate,
    this.calorieGoal = 2000,
    this.consumedCalories = 0,
    this.remainingCalories = 2000,
    this.slots = const [],
    this.status = MealsStatus.initial,
    this.carbs = 0,
    this.protein = 0,
    this.fat = 0,
    this.carbsGoal = 250,
    this.proteinGoal = 130,
    this.fatGoal = 70,
  });

  factory MealsState.create({
    required DateTime selectedDate,
    int calorieGoal = 2000,
    List<MealSlotDetail> slots = const [],
    MealsStatus status = MealsStatus.initial,
    int carbsGoal = 250,
    int proteinGoal = 130,
    int fatGoal = 70,
  }) {
    final consumed = slots.fold<int>(0, (sum, slot) => sum + slot.totalCalories);
    final remaining = (calorieGoal - consumed).clamp(0, 99999);
    final carbsVal = slots.fold<int>(0, (sum, slot) => sum + slot.totalCarbs);
    final proteinVal = slots.fold<int>(0, (sum, slot) => sum + slot.totalProtein);
    final fatVal = slots.fold<int>(0, (sum, slot) => sum + slot.totalFat);

    return MealsState(
      selectedDate: selectedDate,
      calorieGoal: calorieGoal,
      consumedCalories: consumed,
      remainingCalories: remaining,
      slots: slots,
      status: status,
      carbs: carbsVal,
      protein: proteinVal,
      fat: fatVal,
      carbsGoal: carbsGoal,
      proteinGoal: proteinGoal,
      fatGoal: fatGoal,
    );
  }

  double get progress =>
      calorieGoal <= 0 ? 0.0 : (consumedCalories / calorieGoal).clamp(0.0, 1.0);

  MealsState copyWith({
    DateTime? selectedDate,
    int? calorieGoal,
    List<MealSlotDetail>? slots,
    MealsStatus? status,
    int? carbsGoal,
    int? proteinGoal,
    int? fatGoal,
  }) {
    return MealsState.create(
      selectedDate: selectedDate ?? this.selectedDate,
      calorieGoal: calorieGoal ?? this.calorieGoal,
      slots: slots ?? this.slots,
      status: status ?? this.status,
      carbsGoal: carbsGoal ?? this.carbsGoal,
      proteinGoal: proteinGoal ?? this.proteinGoal,
      fatGoal: fatGoal ?? this.fatGoal,
    );
  }

  @override
  List<Object?> get props => [
        selectedDate,
        calorieGoal,
        consumedCalories,
        remainingCalories,
        slots,
        status,
        carbs,
        protein,
        fat,
        carbsGoal,
        proteinGoal,
        fatGoal,
      ];
}
