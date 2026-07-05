import 'package:afia/core/error/failures.dart';
import 'package:afia/features/more/domain/entities/app_preferences.dart';
import 'package:afia/features/more/domain/repositories/more_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateAppPreferences {
  const UpdateAppPreferences(this.repository);
  final MoreRepository repository;

  Future<Either<Failure, AppPreferences>> call(AppPreferences prefs) {
    return repository.updateAppPreferences(prefs);
  }
}
