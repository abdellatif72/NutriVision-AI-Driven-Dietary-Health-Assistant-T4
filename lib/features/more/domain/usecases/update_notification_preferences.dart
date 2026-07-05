import 'package:afia/core/error/failures.dart';
import 'package:afia/features/more/domain/entities/notification_preferences.dart';
import 'package:afia/features/more/domain/repositories/more_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateNotificationPreferences {
  const UpdateNotificationPreferences(this.repository);
  final MoreRepository repository;

  Future<Either<Failure, NotificationPreferences>> call(
    NotificationPreferences prefs,
  ) {
    return repository.updateNotificationPreferences(prefs);
  }
}
