import 'package:afia/features/auth/domain/entities/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

class AuthUserModel extends AuthUser {
  const AuthUserModel({
    required super.id,
    required super.email,
    super.name,
  });

  factory AuthUserModel.fromFirebaseUser(firebase.User firebaseUser) {
    return AuthUserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      name: firebaseUser.displayName,
    );
  }
}
