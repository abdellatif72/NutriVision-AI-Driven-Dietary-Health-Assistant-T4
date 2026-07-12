import 'package:afia/core/error/failures.dart';
import 'package:afia/features/more/domain/entities/diet_preferences.dart';
import 'package:afia/features/more/domain/repositories/more_repository.dart';
import 'package:dartz/dartz.dart';

class GetDietPreferences {
  const GetDietPreferences(this.repository);
  final MoreRepository repository;

  Future<Either<Failure, DietPreferences>> call() {
    return repository.getDietPreferences();
  }
}
