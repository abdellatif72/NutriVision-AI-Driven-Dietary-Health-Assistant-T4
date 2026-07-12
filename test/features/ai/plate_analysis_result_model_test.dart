import 'package:afia/features/ai/data/models/plate_analysis_result_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PlateAnalysisResultModel', () {
    test('parses the Gemini JSON payload into a domain model', () {
      const payload = {
        'food_name': 'سلطة فواكه',
        'estimated_quantity_g': 250,
        'calories': 180,
        'protein_g': 4,
        'calcium_mg': 60,
        'vitamins': ['فيتامين سي', 'فيتامين أ'],
      };

      final model = PlateAnalysisResultModel.fromJson(payload);

      expect(model.foodName, 'سلطة فواكه');
      expect(model.estimatedQuantityG, 250);
      expect(model.calories, 180);
      expect(model.proteinG, 4);
      expect(model.calciumMg, 60);
      expect(model.vitamins, containsAll(['فيتامين سي', 'فيتامين أ']));
    });
  });
}
