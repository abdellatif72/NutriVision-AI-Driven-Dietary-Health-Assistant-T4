import 'package:afia/features/ai/domain/entities/plate_analysis_result.dart';
import 'package:afia/features/meals/data/datasources/meal_remote_datasource.dart';
import 'package:afia/features/meals/domain/repositories/meal_repository.dart';

class MealRepositoryImpl implements MealRepository {
  const MealRepositoryImpl({required this.remoteDataSource});

  final MealRemoteDataSource remoteDataSource;

  @override
  Future<void> saveMealFromAi(PlateAnalysisResult result, String slotType) {
    return remoteDataSource.saveMealFromAi(result, slotType);
  }
}
