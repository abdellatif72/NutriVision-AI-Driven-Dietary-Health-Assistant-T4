import 'package:afia/features/ai/domain/entities/plate_analysis_result.dart';

abstract class MealRepository {
  Future<void> saveMealFromAi(PlateAnalysisResult result, String slotType);
}
