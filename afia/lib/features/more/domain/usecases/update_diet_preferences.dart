import 'package:afia/core/error/failures.dart';
import 'package:afia/features/more/domain/entities/diet_preferences.dart';
import 'package:afia/features/more/domain/repositories/more_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateDietPreferences {
  const UpdateDietPreferences(this.repository);
  final MoreRepository repository;

  Future<Either<Failure, DietPreferences>> call(DietPreferences prefs) {
    return repository.updateDietPreferences(prefs);
  }
}
