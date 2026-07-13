import 'package:afia/core/utils/app_logger.dart';
import 'package:afia/features/ai/domain/entities/plate_analysis_result.dart';
import 'package:afia/features/meals/data/models/meal_model.dart';
import 'package:afia/features/meals/domain/entities/meal_summary.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:supabase_flutter/supabase_flutter.dart';

class MealRemoteDataSource {
  MealRemoteDataSource({
    SupabaseClient? supabaseClient,
    firebase_auth.FirebaseAuth? firebaseAuth,
  }) : _supabaseClient = supabaseClient ?? Supabase.instance.client,
       _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  final SupabaseClient _supabaseClient;
  final firebase_auth.FirebaseAuth _firebaseAuth;

  String get _currentUserId {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) throw Exception('User is not authenticated');
    return uid;
  }

  Future<List<MealModel>> getLoggedMeals(DateTime date) async {
    try {
      final userId = _currentUserId;
      final dateStr = date.toUtc().toIso8601String().substring(0, 10);

      final response = await _supabaseClient
          .from('logged_meals')
          .select()
          .eq('user_id', userId)
          .eq('logged_date', dateStr);

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => MealModel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      AppLogger.error('MealRemoteDataSource.getLoggedMeals', e);
      rethrow;
    }
  }

  Future<MealModel> insertMeal(MealSummary meal, String slotType, DateTime date) async {
    try {
      final userId = _currentUserId;
      final model = MealModel.fromEntity(meal);
      final json = model.toJson(userId, slotType, date);
      
      // Omit 'id' to let Postgres auto-generate a valid UUID
      json.remove('id');

      final response = await _supabaseClient
          .from('logged_meals')
          .insert(json)
          .select()
          .single();

      return MealModel.fromJson(response);
    } catch (e) {
      AppLogger.error('MealRemoteDataSource.insertMeal', e);
      rethrow;
    }
  }

  Future<void> deleteMeal(String id) async {
    try {
      await _supabaseClient
          .from('logged_meals')
          .delete()
          .eq('id', id);
    } catch (e) {
      AppLogger.error('MealRemoteDataSource.deleteMeal', e);
      rethrow;
    }
  }

  Future<void> saveMealFromAi(PlateAnalysisResult result, String slotType) async {
    try {
      final userId = _currentUserId;
      final dateStr = DateTime.now().toUtc().toIso8601String().substring(0, 10);

      final double protein = result.proteinG;
      final double carbs = result.carbsG;
      final double fat = result.fatG;

      await _supabaseClient.from('logged_meals').insert({
        'user_id': userId,
        'slot_type': slotType,
        'name_en': result.foodName,
        'emoji': '🍽️',
        'serving_label_en': '${result.estimatedQuantityG}g',
        'calories': result.calories,
        'protein_g': protein.round(),
        'carbs_g': carbs.round(),
        'fat_g': fat.round(),
        'logged_date': dateStr,
      });
    } catch (e) {
      AppLogger.error('MealRemoteDataSource.saveMealFromAi', e);
      rethrow;
    }
  }
}
