import 'package:afia/core/error/failures.dart';
import 'package:afia/features/more/domain/entities/user_profile.dart';
import 'package:afia/features/more/domain/repositories/more_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateUserProfile {
  const UpdateUserProfile(this.repository);
  final MoreRepository repository;

  Future<Either<Failure, UserProfile>> call(UserProfile profile) {
    return repository.updateProfile(profile);
  }
}
