import 'package:afia/features/auth/domain/usecases/calculate_daily_calories.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CalculateDailyCalories useCase;

  setUp(() {
    useCase = CalculateDailyCalories();
  });

  group('CalculateDailyCalories Mifflin-St Jeor math tests', () {
    test('should calculate correct BMR, TDEE, and calorie target for a sedentary male maintaining weight', () {
      // Mifflin: (10 * 80) + (6.25 * 180) - (5 * 25) + 5 = 800 + 1125 - 125 + 5 = 1805 BMR
      // TDEE: 1805 * 1.2 = 2166
      // Maintain Target: 2166
      const params = CalculateDailyCaloriesParams(
        weightKg: 80,
        heightCm: 180,
        age: 25,
        gender: 'male',
        activityLevel: 'sedentary',
        goal: 'maintain',
      );

      final result = useCase(params);

      expect(result.bmr, equals(1805));
      expect(result.tdee, equals(2166));
      expect(result.calorieTarget, equals(2166));
    });

    test('should calculate correct BMR, TDEE, and calorie target for a very active female losing weight', () {
      // Mifflin: (10 * 60) + (6.25 * 165) - (5 * 30) - 161 = 600 + 1031.25 - 150 - 161 = 1320.25 (rounds to 1320)
      // TDEE: 1320.25 * 1.725 = 2277.43 (rounds to 2277)
      // Deficit Target: 2277 - 500 = 1777
      const params = CalculateDailyCaloriesParams(
        weightKg: 60,
        heightCm: 165,
        age: 30,
        gender: 'female',
        activityLevel: 'very_active',
        goal: 'lose',
      );

      final result = useCase(params);

      expect(result.bmr, equals(1320));
      expect(result.tdee, equals(2277));
      expect(result.calorieTarget, equals(1777));
    });

    test('should apply clean bulk surplus for a moderately active male gaining weight', () {
      // Mifflin: (10 * 70) + (6.25 * 175) - (5 * 22) + 5 = 700 + 1093.75 - 110 + 5 = 1688.75 (rounds to 1689)
      // TDEE: 1688.75 * 1.55 = 2617.56 (rounds to 2618)
      // Surplus Target: 2618 + 350 = 2968
      const params = CalculateDailyCaloriesParams(
        weightKg: 70,
        heightCm: 175,
        age: 22,
        gender: 'male',
        activityLevel: 'moderately_active',
        goal: 'gain',
      );

      final result = useCase(params);

      expect(result.bmr, equals(1689));
      expect(result.tdee, equals(2618));
      expect(result.calorieTarget, equals(2968));
    });

    test('should clamp target calories to minimum safe limit of 1200 for a female with low TDEE trying to lose weight', () {
      // Mifflin: (10 * 45) + (6.25 * 150) - (5 * 40) - 161 = 450 + 937.5 - 200 - 161 = 1026.5 (rounds to 1027)
      // TDEE: 1026.5 * 1.2 = 1231.8 (rounds to 1232)
      // Deficit Target: 1232 - 500 = 732 (should be clamped to female min 1200)
      const params = CalculateDailyCaloriesParams(
        weightKg: 45,
        heightCm: 150,
        age: 40,
        gender: 'female',
        activityLevel: 'sedentary',
        goal: 'lose',
      );

      final result = useCase(params);

      expect(result.calorieTarget, equals(1200));
    });

    test('should clamp target calories to minimum safe limit of 1500 for a male with low TDEE trying to lose weight', () {
      // Mifflin: (10 * 55) + (6.25 * 160) - (5 * 50) + 5 = 550 + 1000 - 250 + 5 = 1305
      // TDEE: 1305 * 1.2 = 1566
      // Deficit Target: 1566 - 500 = 1066 (should be clamped to male min 1500)
      const params = CalculateDailyCaloriesParams(
        weightKg: 55,
        heightCm: 160,
        age: 50,
        gender: 'male',
        activityLevel: 'sedentary',
        goal: 'lose',
      );

      final result = useCase(params);

      expect(result.calorieTarget, equals(1500));
    });

    test('should handle other/unknown gender gracefully by using average gender offset', () {
      // Mifflin: (10 * 70) + (6.25 * 170) - (5 * 30) - 78 = 700 + 1062.5 - 150 - 78 = 1534.5 (rounds to 1535)
      const params = CalculateDailyCaloriesParams(
        weightKg: 70,
        heightCm: 170,
        age: 30,
        gender: 'other',
        activityLevel: 'sedentary',
        goal: 'maintain',
      );

      final result = useCase(params);

      expect(result.bmr, equals(1535));
    });
    group('Case Sensitivity and Whitespace tests', () {
      test('should trim and normalize case for inputs', () {
        const params = CalculateDailyCaloriesParams(
          weightKg: 80,
          heightCm: 180,
          age: 25,
          gender: ' MALE  ',
          activityLevel: ' SEDENTARY ',
          goal: ' MAINTAIN ',
        );

        final result = useCase(params);

        expect(result.bmr, equals(1805));
        expect(result.tdee, equals(2166));
        expect(result.calorieTarget, equals(2166));
      });
    });
  });
}
