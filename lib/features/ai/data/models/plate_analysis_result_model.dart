import 'package:afia/features/ai/domain/entities/plate_analysis_result.dart';

class PlateAnalysisResultModel extends PlateAnalysisResult {
  const PlateAnalysisResultModel({
    required super.foodName,
    required super.estimatedQuantityG,
    required super.calories,
    required super.proteinG,
    required super.calciumMg,
    required super.vitamins,
  });

  factory PlateAnalysisResultModel.fromJson(Map<String, dynamic> json) {
    return PlateAnalysisResultModel(
      foodName: json['name_en']?.toString() ??
          json['food_name']?.toString() ??
          'Unknown meal',
      estimatedQuantityG:
          (json['estimated_quantity_g'] as num?)?.toInt() ??
          (json['portion_g'] as num?)?.toInt() ??
          0,
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      proteinG: (json['protein_g'] as num?)?.toDouble() ?? 0.0,
      calciumMg: (json['calcium_mg'] as num?)?.toInt() ?? 0,
      vitamins: (json['vitamins'] as List<dynamic>?)
              ?.map((v) => v.toString())
              .where((v) => v.isNotEmpty)
              .toList() ??
          const <String>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'food_name': foodName,
      'estimated_quantity_g': estimatedQuantityG,
      'calories': calories,
      'protein_g': proteinG,
      'calcium_mg': calciumMg,
      'vitamins': vitamins,
    };
  }
}
