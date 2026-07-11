import 'package:afia/core/error/failures.dart';
import 'package:afia/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:afia/features/auth/domain/entities/auth_user.dart';
import 'package:afia/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthUser;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  Future<Either<Failure, T>> _handleException<T>(Future<T> Function() action) async {
    try {
      final result = await action();
      return Right(result);
    } on firebase.FirebaseAuthException catch (e) {
      return Left(ServerFailure(e.message ?? 'Authentication error occurred.'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<void> _syncSupabaseSession() async {
    final firebaseUser = firebase.FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      final firebaseToken = await firebaseUser.getIdToken();
      if (firebaseToken != null) {
        await Supabase.instance.client.auth.setSession(firebaseToken);
      }
    }
  }

  @override
  Future<Either<Failure, AuthUser>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    final result = await _handleException(() => _remoteDataSource.signUpWithEmailAndPassword(
          email: email,
          password: password,
          name: name,
        ));
    return result.fold(
      (failure) => Left(failure),
      (user) async {
        await _syncSupabaseSession();
        return Right(user);
      },
    );
  }

  @override
  Future<Either<Failure, AuthUser>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final result = await _handleException(() => _remoteDataSource.signInWithEmailAndPassword(
          email: email,
          password: password,
        ));
    return result.fold(
      (failure) => Left(failure),
      (user) async {
        await _syncSupabaseSession();
        return Right(user);
      },
    );
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    final result = await _handleException(() => _remoteDataSource.signOut());
    return result.fold(
      (failure) => Left(failure),
      (_) async {
        try {
          await Supabase.instance.client.auth.signOut();
        } catch (_) {}
        return const Right(null);
      },
    );
  }

  @override
  Future<Either<Failure, AuthUser?>> getCurrentUser() async {
    final result = await _handleException(() => _remoteDataSource.getCurrentUser());
    return result.fold(
      (failure) => Left(failure),
      (user) async {
        if (user != null) {
          await _syncSupabaseSession();
        }
        return Right(user);
      },
    );
  }

  @override
  Future<Either<Failure, void>> resetPassword({required String email}) async {
    return _handleException(() => _remoteDataSource.resetPassword(email: email));
  }

  @override
  Future<Either<Failure, AuthUser>> signInWithGoogle() async {
    final result = await _handleException(() => _remoteDataSource.signInWithGoogle());
    return result.fold(
      (failure) => Left(failure),
      (user) async {
        await _syncSupabaseSession();
        return Right(user);
      },
    );
  }

  @override
  Future<Either<Failure, AuthUser>> signInWithApple() async {
    final result = await _handleException(() => _remoteDataSource.signInWithApple());
    return result.fold(
      (failure) => Left(failure),
      (user) async {
        await _syncSupabaseSession();
        return Right(user);
      },
    );
  }

  @override
  Stream<AuthUser?> get authStateChanges => _remoteDataSource.authStateChanges;
}

