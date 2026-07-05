import 'package:equatable/equatable.dart';

class DietPreferences extends Equatable {
  const DietPreferences({
    this.dietStyle = 'balanced',
    this.goalType = 'maintain',
    this.calorieTarget,
    this.carbsPct = 50,
    this.proteinPct = 20,
    this.fatPct = 30,
    this.allergies = const [],
    this.dislikedFoods = const [],
    this.preferredCuisines = const [],
    this.mealsPerDay = 3,
    this.fastingEnabled = false,
    this.waterGoalMl = 2500,
  });

  final String dietStyle;
  final String goalType;
  final int? calorieTarget;
  final int carbsPct;
  final int proteinPct;
  final int fatPct;
  final List<String> allergies;
  final List<String> dislikedFoods;
  final List<String> preferredCuisines;
  final int mealsPerDay;
  final bool fastingEnabled;
  final int waterGoalMl;

  DietPreferences copyWith({
    String? dietStyle,
    String? goalType,
    int? calorieTarget,
    int? carbsPct,
    int? proteinPct,
    int? fatPct,
    List<String>? allergies,
    List<String>? dislikedFoods,
    List<String>? preferredCuisines,
    int? mealsPerDay,
    bool? fastingEnabled,
    int? waterGoalMl,
  }) {
    return DietPreferences(
      dietStyle: dietStyle ?? this.dietStyle,
      goalType: goalType ?? this.goalType,
      calorieTarget: calorieTarget ?? this.calorieTarget,
      carbsPct: carbsPct ?? this.carbsPct,
      proteinPct: proteinPct ?? this.proteinPct,
      fatPct: fatPct ?? this.fatPct,
      allergies: allergies ?? this.allergies,
      dislikedFoods: dislikedFoods ?? this.dislikedFoods,
      preferredCuisines: preferredCuisines ?? this.preferredCuisines,
      mealsPerDay: mealsPerDay ?? this.mealsPerDay,
      fastingEnabled: fastingEnabled ?? this.fastingEnabled,
      waterGoalMl: waterGoalMl ?? this.waterGoalMl,
    );
  }

  @override
  List<Object?> get props => [
    dietStyle,
    goalType,
    calorieTarget,
    carbsPct,
    proteinPct,
    fatPct,
    allergies,
    dislikedFoods,
    preferredCuisines,
    mealsPerDay,
    fastingEnabled,
    waterGoalMl,
  ];
}
