import 'package:afia/core/error/failures.dart';
import 'package:afia/features/water/domain/repositories/water_repository.dart';
import 'package:dartz/dartz.dart';

class GetWaterGoal {
  final WaterRepository repository;

  const GetWaterGoal(this.repository);

  Future<Either<Failure, int>> call() {
    return repository.getWaterGoal();
  }
}
