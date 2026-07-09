import 'package:equatable/equatable.dart';

class CalculateDailyCaloriesParams extends Equatable {
  final double weightKg;
  final double heightCm;
  final int age;
  final String gender; // 'male', 'female', 'other'
  final String activityLevel; // 'sedentary', 'lightly_active', 'moderately_active', 'very_active'
  final String goal; // 'lose', 'gain', 'maintain'

  const CalculateDailyCaloriesParams({
    required this.weightKg,
    required this.heightCm,
    required this.age,
    required this.gender,
    required this.activityLevel,
    required this.goal,
  });

  @override
  List<Object?> get props => [weightKg, heightCm, age, gender, activityLevel, goal];
}

class CalculateDailyCaloriesResult extends Equatable {
  final int bmr;
  final int tdee;
  final int calorieTarget;

  const CalculateDailyCaloriesResult({
    required this.bmr,
    required this.tdee,
    required this.calorieTarget,
  });

  @override
  List<Object?> get props => [bmr, tdee, calorieTarget];
}

class CalculateDailyCalories {
  CalculateDailyCaloriesResult call(CalculateDailyCaloriesParams params) {
    // 1. Calculate BMR using Mifflin-St Jeor Equation
    double bmrValue;
    
    // Normalize gender
    final genderClean = params.gender.toLowerCase().trim();
    
    if (genderClean == 'male') {
      bmrValue = (10 * params.weightKg) + (6.25 * params.heightCm) - (5 * params.age) + 5;
    } else if (genderClean == 'female') {
      bmrValue = (10 * params.weightKg) + (6.25 * params.heightCm) - (5 * params.age) - 161;
    } else {
      // Default / Other: Average of male and female offset
      bmrValue = (10 * params.weightKg) + (6.25 * params.heightCm) - (5 * params.age) - 78;
    }

    // 2. Calculate TDEE (Total Daily Energy Expenditure) based on activity multiplier
    double multiplier = 1.2; // default sedentary
    switch (params.activityLevel.toLowerCase().trim()) {
      case 'sedentary':
        multiplier = 1.2;
        break;
      case 'lightly_active':
        multiplier = 1.375;
        break;
      case 'moderately_active':
        multiplier = 1.55;
        break;
      case 'very_active':
        multiplier = 1.725;
        break;
      default:
        multiplier = 1.2;
    }
    
    final double tdeeValue = bmrValue * multiplier;

    // 3. Calculate target calories based on goal
    double targetValue = tdeeValue;
    switch (params.goal.toLowerCase().trim()) {
      case 'lose':
        // Standard safe 500 kcal deficit
        targetValue = tdeeValue - 500;
        // Never let calorie target drop below safe absolute minimums
        final minSafe = genderClean == 'female' ? 1200.0 : 1500.0;
        if (targetValue < minSafe) {
          targetValue = minSafe;
        }
        break;
      case 'gain':
        // Standard 350 kcal surplus for clean bulk
        targetValue = tdeeValue + 350;
        break;
      case 'maintain':
      default:
        targetValue = tdeeValue;
    }

    return CalculateDailyCaloriesResult(
      bmr: bmrValue.round(),
      tdee: tdeeValue.round(),
      calorieTarget: targetValue.round(),
    );
  }
}
