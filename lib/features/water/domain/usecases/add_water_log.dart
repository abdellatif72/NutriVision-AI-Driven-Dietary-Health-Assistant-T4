import 'package:afia/core/error/failures.dart';
import 'package:afia/features/water/domain/entities/water_entry.dart';
import 'package:afia/features/water/domain/repositories/water_repository.dart';
import 'package:dartz/dartz.dart';

class AddWaterLog {
  final WaterRepository repository;

  const AddWaterLog(this.repository);

  Future<Either<Failure, WaterEntry>> call({
    required int amountMl,
    required String preset,
  }) {
    return repository.addWaterLog(amountMl: amountMl, preset: preset);
  }
}
