import 'package:afia/core/error/failures.dart';
import 'package:afia/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:afia/features/auth/domain/entities/auth_user.dart';
import 'package:afia/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

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

  @override
  Future<Either<Failure, AuthUser>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    return _handleException(() => _remoteDataSource.signUpWithEmailAndPassword(
          email: email,
          password: password,
          name: name,
        ));
  }

  @override
  Future<Either<Failure, AuthUser>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _handleException(() => _remoteDataSource.signInWithEmailAndPassword(
          email: email,
          password: password,
        ));
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    return _handleException(() => _remoteDataSource.signOut());
  }

  @override
  Future<Either<Failure, AuthUser?>> getCurrentUser() async {
    return _handleException(() => _remoteDataSource.getCurrentUser());
  }

  @override
  Future<Either<Failure, void>> resetPassword({required String email}) async {
    return _handleException(() => _remoteDataSource.resetPassword(email: email));
  }

  @override
  Future<Either<Failure, AuthUser>> signInWithGoogle() async {
    return _handleException(() => _remoteDataSource.signInWithGoogle());
  }

  @override
  Future<Either<Failure, AuthUser>> signInWithApple() async {
    return _handleException(() => _remoteDataSource.signInWithApple());
  }

  @override
  Stream<AuthUser?> get authStateChanges => _remoteDataSource.authStateChanges;
}
