import 'package:afia/features/more/domain/entities/diet_preferences.dart';

class DietPreferencesModel extends DietPreferences {
  const DietPreferencesModel({
    super.dietStyle = 'balanced',
    super.goalType = 'maintain',
    super.calorieTarget,
    super.carbsPct = 50,
    super.proteinPct = 20,
    super.fatPct = 30,
    super.allergies = const [],
    super.dislikedFoods = const [],
    super.preferredCuisines = const [],
    super.mealsPerDay = 3,
    super.fastingEnabled = false,
    super.waterGoalMl = 2500,
  });

  factory DietPreferencesModel.fromJson(Map<String, dynamic> json) {
    return DietPreferencesModel(
      dietStyle: json['dietStyle'] as String? ?? 'balanced',
      goalType: json['goalType'] as String? ?? 'maintain',
      calorieTarget: json['calorieTarget'] as int?,
      carbsPct: json['carbsPct'] as int? ?? 50,
      proteinPct: json['proteinPct'] as int? ?? 20,
      fatPct: json['fatPct'] as int? ?? 30,
      allergies:
          (json['allergies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      dislikedFoods:
          (json['dislikedFoods'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      preferredCuisines:
          (json['preferredCuisines'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      mealsPerDay: json['mealsPerDay'] as int? ?? 3,
      fastingEnabled: json['fastingEnabled'] as bool? ?? false,
      waterGoalMl: json['waterGoalMl'] as int? ?? 2500,
    );
  }

  Map<String, dynamic> toJson() => {
    'dietStyle': dietStyle,
    'goalType': goalType,
    'calorieTarget': calorieTarget,
    'carbsPct': carbsPct,
    'proteinPct': proteinPct,
    'fatPct': fatPct,
    'allergies': allergies,
    'dislikedFoods': dislikedFoods,
    'preferredCuisines': preferredCuisines,
    'mealsPerDay': mealsPerDay,
    'fastingEnabled': fastingEnabled,
    'waterGoalMl': waterGoalMl,
  };

  factory DietPreferencesModel.fromEntity(DietPreferences entity) {
    return DietPreferencesModel(
      dietStyle: entity.dietStyle,
      goalType: entity.goalType,
      calorieTarget: entity.calorieTarget,
      carbsPct: entity.carbsPct,
      proteinPct: entity.proteinPct,
      fatPct: entity.fatPct,
      allergies: entity.allergies,
      dislikedFoods: entity.dislikedFoods,
      preferredCuisines: entity.preferredCuisines,
      mealsPerDay: entity.mealsPerDay,
      fastingEnabled: entity.fastingEnabled,
      waterGoalMl: entity.waterGoalMl,
    );
  }
}
