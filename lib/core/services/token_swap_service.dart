import 'dart:async';
import 'package:afia/core/utils/app_logger.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:supabase_flutter/supabase_flutter.dart';

class TokenSwapService {
  final firebase.FirebaseAuth _firebaseAuth;
  final SupabaseClient _supabaseClient;
  StreamSubscription<firebase.User?>? _authSubscription;

  TokenSwapService({
    firebase.FirebaseAuth? firebaseAuth,
    SupabaseClient? supabaseClient,
  })  : _firebaseAuth = firebaseAuth ?? firebase.FirebaseAuth.instance,
        _supabaseClient = supabaseClient ?? Supabase.instance.client;

  void initialize() {
    AppLogger.info('TokenSwapService initialized. Listening to Firebase Auth...');
    
    // Listen to idTokenChanges which fires when:
    // 1. User signs in
    // 2. User signs out
    // 3. User's token refreshes (typically every 1 hour)
    _authSubscription = _firebaseAuth.idTokenChanges().listen((firebaseUser) async {
      if (firebaseUser == null) {
        AppLogger.info('Firebase user is null. Signing out of Supabase.');
        await _supabaseClient.auth.signOut();
        return;
      }

      try {
        AppLogger.info('Firebase token changed. Requesting Supabase token swap...');
        
        // 1. Get the raw Firebase JWT string
        final firebaseToken = await firebaseUser.getIdToken();
        if (firebaseToken == null) {
          throw Exception('Failed to retrieve Firebase ID token');
        }

        // 2. Call the Edge Function to securely swap the token
        final response = await _supabaseClient.functions.invoke(
          'firebase-token-swap',
          body: {'firebase_token': firebaseToken},
        );

        if (response.status != 200) {
          throw Exception('Edge function returned status ${response.status}: ${response.data}');
        }

        // 3. Extract the minted Supabase token
        final supabaseToken = response.data['supabase_token'] as String?;
        if (supabaseToken == null) {
          throw Exception('Edge function response missing supabase_token');
        }

        // 4. Inject the token into the Supabase client
        await _supabaseClient.auth.setSession(supabaseToken);
        AppLogger.info('Successfully swapped and applied custom Supabase token!');
        
      } catch (e) {
        AppLogger.error('TokenSwapService failed', e);
        // If the swap fails, sign out of Supabase to prevent unauthenticated actions
        await _supabaseClient.auth.signOut();
      }
    });
  }

  void dispose() {
    _authSubscription?.cancel();
  }
}
