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
        
        // 5. Ensure user profile and default preferences exist in Supabase
        await _ensureUserProfileExists(firebaseUser);
        
      } catch (e) {
        AppLogger.error('TokenSwapService failed', e);
        // If the swap fails, sign out of Supabase to prevent unauthenticated actions
        await _supabaseClient.auth.signOut();
      }
    });
  }

  Future<void> _ensureUserProfileExists(firebase.User firebaseUser) async {
    try {
      final userId = firebaseUser.uid;
      
      // 1. Check if user profile already exists
      final profileResponse = await _supabaseClient
          .from('user_profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (profileResponse == null) {
        AppLogger.info('User profile not found. Creating default profile and preferences...');
        
        final name = firebaseUser.displayName ?? 'User';
        
        // Insert default user profile
        await _supabaseClient.from('user_profiles').insert({
          'id': userId,
          'name': name,
          'streak_days': 0,
        });

        // Insert default diet preferences
        await _supabaseClient.from('diet_preferences').insert({
          'user_id': userId,
          'diet_style': 'balanced',
          'goal_type': 'maintain',
          'carbs_pct': 50,
          'protein_pct': 20,
          'fat_pct': 30,
          'water_goal_ml': 2500,
        });

        // Insert default notification preferences
        await _supabaseClient.from('notification_preferences').insert({
          'user_id': userId,
          'enabled': true,
          'water_reminder': true,
          'water_interval_hours': 2,
          'meal_reminder': true,
          'meal_times': ['08:00', '13:00', '20:00'],
          'weigh_in_reminder': false,
          'progress_summary': false,
        });

        // Insert default app preferences
        await _supabaseClient.from('app_preferences').insert({
          'user_id': userId,
          'theme_mode': 'system',
          'language': 'ar',
          'units': 'metric',
        });

        AppLogger.info('Successfully created default profile and preferences for user $userId.');
      } else {
        AppLogger.info('User profile already exists in Supabase.');
      }
    } catch (e) {
      AppLogger.error('Failed to ensure user profile exists in Supabase', e);
    }
  }

  void dispose() {
    _authSubscription?.cancel();
  }
}
