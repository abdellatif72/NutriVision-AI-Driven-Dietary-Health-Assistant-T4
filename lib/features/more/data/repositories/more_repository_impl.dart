import 'dart:typed_data';
import 'package:afia/core/error/exceptions.dart';
import 'package:afia/core/error/failures.dart';
import 'package:afia/features/more/data/datasources/more_local_datasource.dart';
import 'package:afia/features/more/data/datasources/more_remote_datasource.dart';
import 'package:afia/features/more/domain/entities/app_preferences.dart';
import 'package:afia/features/more/domain/entities/diet_preferences.dart';
import 'package:afia/features/more/domain/entities/user_profile.dart';
import 'package:afia/features/more/domain/repositories/more_repository.dart';
import 'package:dartz/dartz.dart';

class MoreRepositoryImpl implements MoreRepository {
  final MoreRemoteDataSource remoteDataSource;
  final MoreLocalDataSource localDataSource;

  const MoreRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserProfile>> getProfile() async {
    try {
      final remoteProfile = await remoteDataSource.getProfile();
      await localDataSource.cacheProfile(remoteProfile);
      return Right(remoteProfile);
    } on ServerException {
      try {
        final localProfile = await localDataSource.getCachedProfile();
        return Right(localProfile);
      } on CacheException {
        return const Left(CacheFailure('Failed to load profile from cache.'));
      }
    } catch (e) {
      try {
        final localProfile = await localDataSource.getCachedProfile();
        return Right(localProfile);
      } catch (_) {
        return Left(ServerFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateProfile(UserProfile profile) async {
    try {
      final updatedProfile = await remoteDataSource.updateProfile(profile);
      await localDataSource.cacheProfile(updatedProfile);
      return Right(updatedProfile);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfileImage(Uint8List bytes, String fileName) async {
    try {
      final publicUrl = await remoteDataSource.uploadProfileImage(bytes, fileName);
      
      // Update local profile cache
      try {
        final cachedProfile = await localDataSource.getCachedProfile();
        final updatedProfile = cachedProfile.copyWith(photoUrl: publicUrl);
        await localDataSource.cacheProfile(updatedProfile);
      } catch (_) {
        final remoteProfile = await remoteDataSource.getProfile();
        final updatedProfile = remoteProfile.copyWith(photoUrl: publicUrl);
        await localDataSource.cacheProfile(updatedProfile);
      }
      
      return Right(publicUrl);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DietPreferences>> getDietPreferences() async {
    try {
      final remotePrefs = await remoteDataSource.getDietPreferences();
      await localDataSource.cacheDietPreferences(remotePrefs);
      return Right(remotePrefs);
    } on ServerException {
      try {
        final localPrefs = await localDataSource.getCachedDietPreferences();
        return Right(localPrefs);
      } on CacheException {
        return const Left(CacheFailure('Failed to load diet preferences from cache.'));
      }
    } catch (e) {
      try {
        final localPrefs = await localDataSource.getCachedDietPreferences();
        return Right(localPrefs);
      } catch (_) {
        return Left(ServerFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, DietPreferences>> updateDietPreferences(
    DietPreferences prefs,
  ) async {
    try {
      final updatedPrefs = await remoteDataSource.updateDietPreferences(prefs);
      await localDataSource.cacheDietPreferences(updatedPrefs);
      return Right(updatedPrefs);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppPreferences>> getAppPreferences() async {
    try {
      final remotePrefs = await remoteDataSource.getAppPreferences();
      await localDataSource.cacheAppPreferences(remotePrefs);
      return Right(remotePrefs);
    } on ServerException {
      try {
        final localPrefs = await localDataSource.getCachedAppPreferences();
        return Right(localPrefs);
      } on CacheException {
        return const Left(CacheFailure('Failed to load app preferences from cache.'));
      }
    } catch (e) {
      try {
        final localPrefs = await localDataSource.getCachedAppPreferences();
        return Right(localPrefs);
      } catch (_) {
        return Left(ServerFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, AppPreferences>> updateAppPreferences(
    AppPreferences prefs,
  ) async {
    try {
      final updatedPrefs = await remoteDataSource.updateAppPreferences(prefs);
      await localDataSource.cacheAppPreferences(updatedPrefs);
      return Right(updatedPrefs);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
