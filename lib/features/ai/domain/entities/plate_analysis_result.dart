import 'package:equatable/equatable.dart';

class PlateAnalysisResult extends Equatable {
  const PlateAnalysisResult({
    required this.foodName,
    required this.estimatedQuantityG,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.calciumMg,
    required this.vitamins,
  });

  final String foodName;
  final int estimatedQuantityG;
  final int calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final int calciumMg;
  final List<String> vitamins;

  PlateAnalysisResult copyWith({
    String? foodName,
    int? estimatedQuantityG,
    int? calories,
    double? proteinG,
    double? carbsG,
    double? fatG,
    int? calciumMg,
    List<String>? vitamins,
  }) {
    return PlateAnalysisResult(
      foodName: foodName ?? this.foodName,
      estimatedQuantityG: estimatedQuantityG ?? this.estimatedQuantityG,
      calories: calories ?? this.calories,
      proteinG: proteinG ?? this.proteinG,
      carbsG: carbsG ?? this.carbsG,
      fatG: fatG ?? this.fatG,
      calciumMg: calciumMg ?? this.calciumMg,
      vitamins: vitamins ?? this.vitamins,
    );
  }

  @override
  List<Object?> get props => [
        foodName,
        estimatedQuantityG,
        calories,
        proteinG,
        carbsG,
        fatG,
        calciumMg,
        vitamins,
      ];
}
