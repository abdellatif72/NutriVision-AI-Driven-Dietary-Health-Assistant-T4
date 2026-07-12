import 'package:afia/core/utils/app_logger.dart';
import 'package:afia/features/ai/domain/entities/plate_analysis_result.dart';
import 'package:afia/features/meals/data/datasources/meal_remote_datasource.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:supabase_flutter/supabase_flutter.dart';

class MealRemoteDataSourceImpl implements MealRemoteDataSource {
  MealRemoteDataSourceImpl({
    SupabaseClient? supabaseClient,
    firebase_auth.FirebaseAuth? firebaseAuth,
  }) : _supabaseClient = supabaseClient ?? Supabase.instance.client,
       _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  final SupabaseClient _supabaseClient;
  final firebase_auth.FirebaseAuth _firebaseAuth;

  /// Returns the current Firebase UID — consistent with the rest of the app.
  String get _currentUserId {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) throw Exception('User is not authenticated');
    return uid;
  }

  @override
  Future<void> saveMealFromAi(
    PlateAnalysisResult result,
    String slotType,
  ) async {
    try {
      final userId = _currentUserId;
      // Estimate carbs and fat from calories (rough macro split when not provided)
      final carbsG = (result.calories * 0.50 / 4).round();
      final fatG = (result.calories * 0.25 / 9).round();

      await _supabaseClient.from('logged_meals').insert({
        'user_id': userId,
        'slot_type': slotType,          // breakfast / lunch / dinner / snack
        'calories': result.calories,
        'protein_g': result.proteinG,
        'carbs_g': carbsG,
        'fat_g': fatG,
        'logged_date': DateTime.now().toUtc().toIso8601String().substring(0, 10),
      });
    } catch (e) {
      AppLogger.error('MealRemoteDataSourceImpl.saveMealFromAi', e);
      rethrow;
    }
  }
}
