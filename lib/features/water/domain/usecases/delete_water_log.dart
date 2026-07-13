import 'package:afia/core/error/failures.dart';
import 'package:afia/features/water/domain/repositories/water_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteWaterLog {
  final WaterRepository repository;

  const DeleteWaterLog(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteWaterLog(id);
  }
}
