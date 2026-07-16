import 'package:equatable/equatable.dart';
import 'package:afia/features/auth/domain/entities/auth_user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final AuthUser user;
  final bool isSendingVerification;
  final String? verificationError;
  final bool verificationSentSuccess;

  const AuthAuthenticated(
    this.user, {
    this.isSendingVerification = false,
    this.verificationError,
    this.verificationSentSuccess = false,
  });

  AuthAuthenticated copyWith({
    AuthUser? user,
    bool? isSendingVerification,
    String? verificationError,
    bool? verificationSentSuccess,
  }) {
    return AuthAuthenticated(
      user ?? this.user,
      isSendingVerification: isSendingVerification ?? this.isSendingVerification,
      verificationError: verificationError,
      verificationSentSuccess: verificationSentSuccess ?? this.verificationSentSuccess,
    );
  }

  @override
  List<Object?> get props => [
        user,
        isSendingVerification,
        verificationError,
        verificationSentSuccess,
      ];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthPasswordResetSuccess extends AuthState {}

class AuthValidationError extends AuthState {
  final String? emailError;
  final String? emailSuggestion;
  final String? passwordError;

  const AuthValidationError({
    this.emailError,
    this.emailSuggestion,
    this.passwordError,
  });

  @override
  List<Object?> get props => [emailError, emailSuggestion, passwordError];
}

class AuthSignUpSuccess extends AuthState {}

