import 'package:equatable/equatable.dart';
import 'package:afia/features/auth/domain/entities/auth_user.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthStateChanged extends AuthEvent {
  final AuthUser? user;

  const AuthStateChanged(this.user);

  @override
  List<Object?> get props => [user];
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final bool ignoreWarnings;

  const SignUpRequested({
    required this.email,
    required this.password,
    required this.name,
    this.ignoreWarnings = false,
  });

  @override
  List<Object?> get props => [email, password, name, ignoreWarnings];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class SignOutRequested extends AuthEvent {}

class GoogleSignInRequested extends AuthEvent {}

class AppleSignInRequested extends AuthEvent {}

class ResetPasswordRequested extends AuthEvent {
  final String email;

  const ResetPasswordRequested({required this.email});

  @override
  List<Object?> get props => [email];
}
