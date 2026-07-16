import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia/features/auth/domain/entities/auth_user.dart';
import 'package:afia/features/auth/domain/repositories/auth_repository.dart';
import 'package:afia/core/utils/validation_utils.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<AuthUser?>? _authSubscription;

  AuthBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthStateChanged>(_onAuthStateChanged);
    on<SignUpRequested>(_onSignUpRequested);
    on<LoginRequested>(_onLoginRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<AppleSignInRequested>(_onAppleSignInRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
    on<SendEmailVerificationRequested>(_onSendEmailVerificationRequested);
    on<ReloadUserRequested>(_onReloadUserRequested);

    // Listen to changes in the active Firebase Auth state
    _authSubscription = _authRepository.authStateChanges.listen((user) {
      add(AuthStateChanged(user));
    });
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _authRepository.getCurrentUser();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) {
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthUnauthenticated());
        }
      },
    );
  }

  void _onAuthStateChanged(
    AuthStateChanged event,
    Emitter<AuthState> emit,
  ) {
    if (event.user != null) {
      emit(AuthAuthenticated(event.user!));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    final emailError = ValidationUtils.validateEmail(event.email, locale: event.locale);
    final emailSuggestion = ValidationUtils.suggestEmailCorrection(event.email);
    final passwordError = ValidationUtils.validatePassword(event.password, locale: event.locale);

    final hasValidationError = emailError != null || passwordError != null;
    final hasWarning = emailSuggestion != null && !event.ignoreWarnings;

    if (hasValidationError || hasWarning) {
      emit(AuthValidationError(
        emailError: emailError,
        emailSuggestion: emailSuggestion,
        passwordError: passwordError,
      ));
      return;
    }

    emit(AuthLoading());
    final result = await _authRepository.signUpWithEmailAndPassword(
      email: event.email,
      password: event.password,
      name: event.name,
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthSignUpSuccess()),
    );
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _authRepository.signInWithEmailAndPassword(
      email: event.email,
      password: event.password,
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _authRepository.signOut();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  Future<void> _onGoogleSignInRequested(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _authRepository.signInWithGoogle();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onAppleSignInRequested(
    AppleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _authRepository.signInWithApple();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _authRepository.resetPassword(email: event.email);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthPasswordResetSuccess()),
    );
  }

  Future<void> _onSendEmailVerificationRequested(
    SendEmailVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    final currentState = state;
    if (currentState is AuthAuthenticated) {
      emit(currentState.copyWith(
        isSendingVerification: true,
        verificationSentSuccess: false,
      ));

      final result = await _authRepository.sendEmailVerification();
      result.fold(
        (failure) => emit(currentState.copyWith(
          isSendingVerification: false,
          verificationError: failure.message,
        )),
        (_) => emit(currentState.copyWith(
          isSendingVerification: false,
          verificationSentSuccess: true,
        )),
      );
    }
  }

  Future<void> _onReloadUserRequested(
    ReloadUserRequested event,
    Emitter<AuthState> emit,
  ) async {
    final currentState = state;
    if (currentState is AuthAuthenticated) {
      final result = await _authRepository.reloadUser();
      result.fold(
        (failure) => emit(currentState.copyWith(verificationError: failure.message)),
        (user) {
          if (user != null) {
            emit(AuthAuthenticated(user));
          } else {
            emit(AuthUnauthenticated());
          }
        },
      );
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
