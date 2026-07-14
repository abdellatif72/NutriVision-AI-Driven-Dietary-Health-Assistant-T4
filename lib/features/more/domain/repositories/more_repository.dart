import 'dart:typed_data';
import 'package:afia/features/more/domain/entities/app_preferences.dart';
import 'package:afia/features/more/domain/entities/diet_preferences.dart';
import 'package:afia/features/more/domain/entities/user_profile.dart';
import 'package:afia/core/error/failures.dart';
import 'package:dartz/dartz.dart';

abstract class MoreRepository {
  Future<Either<Failure, UserProfile>> getProfile();
  Future<Either<Failure, UserProfile>> updateProfile(UserProfile profile);
  Future<Either<Failure, String>> uploadProfileImage(Uint8List bytes, String fileName);
  Future<Either<Failure, DietPreferences>> getDietPreferences();
  Future<Either<Failure, DietPreferences>> updateDietPreferences(
    DietPreferences prefs,
  );
  Future<Either<Failure, AppPreferences>> getAppPreferences();
  Future<Either<Failure, AppPreferences>> updateAppPreferences(
    AppPreferences prefs,
  );
}
