import 'package:afia/core/error/failures.dart';
import 'package:afia/features/auth/domain/entities/auth_user.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthUser>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<Failure, AuthUser>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, AuthUser?>> getCurrentUser();

  Future<Either<Failure, void>> resetPassword({required String email});

  Future<Either<Failure, AuthUser>> signInWithGoogle();

  Future<Either<Failure, AuthUser>> signInWithApple();

  Future<Either<Failure, void>> sendEmailVerification();

  Future<Either<Failure, AuthUser?>> reloadUser();

  Stream<AuthUser?> get authStateChanges;
}
