import 'package:afia/features/auth/data/models/auth_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

abstract class AuthRemoteDataSource {
  Future<AuthUserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  Future<AuthUserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<AuthUserModel?> getCurrentUser();

  Future<void> resetPassword({required String email});

  Future<AuthUserModel> signInWithGoogle();

  Future<AuthUserModel> signInWithApple();

  Future<void> sendEmailVerification();

  Future<AuthUserModel?> reloadUser();

  Stream<AuthUserModel?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSourceImpl({
    firebase.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? firebase.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  Future<AuthUserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    final firebase.UserCredential credential =
        await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential.user == null) {
      throw firebase.FirebaseAuthException(
        code: 'user-not-found',
        message: 'Sign up failed, user is null.',
      );
    }

    // Update the display name
    await credential.user!.updateDisplayName(name);
    // Reload the user to apply the display name change
    await credential.user!.reload();
    final firebase.User updatedUser = _firebaseAuth.currentUser ?? credential.user!;

    // Send email verification link natively
    await updatedUser.sendEmailVerification();

    // Sign out to prevent unverified cached sessions immediately
    // await _firebaseAuth.signOut();

    return AuthUserModel.fromFirebaseUser(updatedUser);
  }

  @override
  Future<AuthUserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final firebase.UserCredential credential =
        await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential.user == null) {
      throw firebase.FirebaseAuthException(
        code: 'user-not-found',
        message: 'Sign in failed, user is null.',
      );
    }

    final firebase.User user = credential.user!;
    await user.reload();
    final firebase.User reloadedUser = _firebaseAuth.currentUser ?? user;

    return AuthUserModel.fromFirebaseUser(reloadedUser);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
    }
  }

  @override
  Future<AuthUserModel?> getCurrentUser() async {
    final firebase.User? currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) return null;

    try {
      await currentUser.reload();
    } catch (_) {
      // Ignore network errors or session expired during reload
    }

    final freshUser = _firebaseAuth.currentUser ?? currentUser;
    return AuthUserModel.fromFirebaseUser(freshUser);
  }

  @override
  Future<void> resetPassword({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<AuthUserModel> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw firebase.FirebaseAuthException(
        code: 'sign_in_canceled',
        message: 'Google Sign-In canceled by user.',
      );
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final firebase.AuthCredential credential = firebase.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final firebase.UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);

    if (userCredential.user == null) {
      throw firebase.FirebaseAuthException(
        code: 'user-not-found',
        message: 'Google Sign-In failed, user is null.',
      );
    }

    return AuthUserModel.fromFirebaseUser(userCredential.user!);
  }

  @override
  Future<AuthUserModel> signInWithApple() async {
    final AuthorizationCredentialAppleID appleCredential =
        await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final firebase.AuthCredential credential =
        firebase.OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      rawNonce: null, // Can be omitted or set if custom nonce is generated
    );

    final firebase.UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);

    if (userCredential.user == null) {
      throw firebase.FirebaseAuthException(
        code: 'user-not-found',
        message: 'Apple Sign-In failed, user is null.',
      );
    }

    return AuthUserModel.fromFirebaseUser(userCredential.user!);
  }

  @override
  Future<void> sendEmailVerification() async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      await currentUser.sendEmailVerification();
    }
  }

  @override
  Future<AuthUserModel?> reloadUser() async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      await currentUser.reload();
      final reloadedUser = _firebaseAuth.currentUser ?? currentUser;
      return AuthUserModel.fromFirebaseUser(reloadedUser);
    }
    return null;
  }

  @override
  Stream<AuthUserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      if (firebaseUser == null) return null;
      return AuthUserModel.fromFirebaseUser(firebaseUser);
    });
  }
}
