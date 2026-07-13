import 'package:afia/core/error/failures.dart';
import 'package:afia/features/water/domain/entities/water_entry.dart';
import 'package:afia/features/water/domain/repositories/water_repository.dart';
import 'package:dartz/dartz.dart';

class GetWaterLogs {
  final WaterRepository repository;

  const GetWaterLogs(this.repository);

  Future<Either<Failure, List<WaterEntry>>> call(DateTime date) {
    return repository.getWaterLogs(date);
  }
}
