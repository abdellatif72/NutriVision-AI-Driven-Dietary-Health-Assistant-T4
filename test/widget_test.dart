import 'package:afia/app/app.dart';
import 'package:afia/app/di/injection_container.dart';
import 'package:afia/core/error/failures.dart';
import 'package:afia/features/auth/domain/entities/auth_user.dart';
import 'package:afia/features/auth/domain/repositories/auth_repository.dart';
import 'package:afia/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  Future<Either<Failure, AuthUser>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, AuthUser>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, AuthUser?>> getCurrentUser() async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> resetPassword({required String email}) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, AuthUser>> signInWithGoogle() async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, AuthUser>> signInWithApple() async {
    throw UnimplementedError();
  }

  @override
  Stream<AuthUser?> get authStateChanges => const Stream.empty();
}

void main() {
  setUpAll(() {
    if (!sl.isRegistered<AuthBloc>()) {
      sl.registerFactory<AuthBloc>(() => AuthBloc(authRepository: FakeAuthRepository()));
    }
  });

  testWidgets('renders onboard page as initial route', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AfiaApp());
    await tester.pumpAndSettle();

    expect(find.text('Healthy habits,\nsmarter you.'), findsOneWidget);
  });
}
