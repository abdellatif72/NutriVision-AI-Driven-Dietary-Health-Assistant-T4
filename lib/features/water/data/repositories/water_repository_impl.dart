import 'package:afia/core/error/failures.dart';
import 'package:afia/features/water/data/datasources/water_remote_datasource.dart';
import 'package:afia/features/water/domain/entities/water_entry.dart';
import 'package:afia/features/water/domain/repositories/water_repository.dart';
import 'package:dartz/dartz.dart';

class WaterRepositoryImpl implements WaterRepository {
  final WaterRemoteDataSource remoteDataSource;

  const WaterRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<WaterEntry>>> getWaterLogs(DateTime date) async {
    try {
      final logs = await remoteDataSource.getWaterLogs(date);
      return Right(logs);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WaterEntry>> addWaterLog({
    required int amountMl,
    required String preset,
  }) async {
    try {
      final entry = await remoteDataSource.addWaterLog(
        amountMl: amountMl,
        preset: preset,
      );
      return Right(entry);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteWaterLog(String id) async {
    try {
      await remoteDataSource.deleteWaterLog(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getWaterGoal() async {
    try {
      final goal = await remoteDataSource.getWaterGoal();
      return Right(goal);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
