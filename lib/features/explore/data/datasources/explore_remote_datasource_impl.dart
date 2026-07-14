import 'package:afia/core/utils/app_logger.dart';
import 'package:afia/features/explore/data/datasources/explore_remote_datasource.dart';
import 'package:afia/features/explore/data/models/food_item_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:supabase_flutter/supabase_flutter.dart';

class ExploreRemoteDataSourceImpl implements ExploreRemoteDataSource {
  ExploreRemoteDataSourceImpl({
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

  @override
  Future<List<FoodItemModel>> getFoods({String? query, String? categoryEn}) async {
    try {
      var request = _supabaseClient.from('food_catalog').select();

      if (categoryEn != null && categoryEn.isNotEmpty && categoryEn.toLowerCase() != 'all') {
        request = request.eq('category_en', categoryEn);
      }

      if (query != null && query.trim().isNotEmpty) {
        final q = '%${query.trim()}%';
        request = request.or('name_ar.ilike.$q,name_en.ilike.$q');
      }

      final response = await request.order('name_ar', ascending: true);
      final list = response as List<dynamic>;
      return list.map((json) => FoodItemModel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      AppLogger.error('ExploreRemoteDataSourceImpl.getFoods', e);
      rethrow;
    }
  }

  @override
  Future<void> logFood({required FoodItemModel food, required String slotType}) async {
    try {
      final userId = _currentUserId;
      await _supabaseClient.from('logged_meals').insert({
        'user_id': userId,
        'name_en': food.nameEn,
        'name_ar': food.nameAr,
        'emoji': food.emoji,
        'serving_label_en': food.servingLabelEn,
        'serving_label_ar': food.servingLabelAr,
        'calories': food.calories,
        'protein_g': food.proteinG.round(),
        'carbs_g': food.carbsG.round(),
        'fat_g': food.fatG.round(),
        'tags': food.tags,
        'slot_type': slotType,
        'logged_date': DateTime.now().toIso8601String().substring(0, 10),
      });
    } catch (e) {
      AppLogger.error('ExploreRemoteDataSourceImpl.logFood', e);
      rethrow;
    }
  }
}
