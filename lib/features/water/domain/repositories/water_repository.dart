import 'package:afia/core/error/failures.dart';
import 'package:afia/features/water/domain/entities/water_entry.dart';
import 'package:dartz/dartz.dart';

abstract class WaterRepository {
  Future<Either<Failure, List<WaterEntry>>> getWaterLogs(DateTime date);
  Future<Either<Failure, WaterEntry>> addWaterLog({
    required int amountMl,
    required String preset,
  });
  Future<Either<Failure, void>> deleteWaterLog(String id);
  Future<Either<Failure, int>> getWaterGoal();
}
