import 'package:afia/core/utils/app_logger.dart';
import 'package:afia/features/water/data/datasources/water_remote_datasource.dart';
import 'package:afia/features/water/data/models/water_entry_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:supabase_flutter/supabase_flutter.dart';

class WaterRemoteDataSourceImpl implements WaterRemoteDataSource {
  final SupabaseClient _supabaseClient;
  final firebase_auth.FirebaseAuth _firebaseAuth;

  WaterRemoteDataSourceImpl({
    SupabaseClient? supabaseClient,
    firebase_auth.FirebaseAuth? firebaseAuth,
  })  : _supabaseClient = supabaseClient ?? Supabase.instance.client,
        _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  String get _currentUserId {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      throw Exception('User is not authenticated');
    }
    return uid;
  }

  @override
  Future<List<WaterEntryModel>> getWaterLogs(DateTime date) async {
    try {
      final userId = _currentUserId;
      final startOfDay = DateTime(date.year, date.month, date.day, 0, 0, 0);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

      final response = await _supabaseClient
          .from('water_logs')
          .select()
          .eq('user_id', userId)
          .gte('logged_at', startOfDay.toUtc().toIso8601String())
          .lte('logged_at', endOfDay.toUtc().toIso8601String())
          .order('logged_at', ascending: true);

      final list = response as List<dynamic>;
      return list
          .map((json) => WaterEntryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      AppLogger.error('WaterRemoteDataSourceImpl.getWaterLogs', e);
      rethrow;
    }
  }

  @override
  Future<WaterEntryModel> addWaterLog({
    required int amountMl,
    required String preset,
  }) async {
    try {
      final userId = _currentUserId;
      final response = await _supabaseClient
          .from('water_logs')
          .insert({
            'user_id': userId,
            'amount_ml': amountMl,
            'preset': preset,
            'logged_at': DateTime.now().toUtc().toIso8601String(),
          })
          .select()
          .single();

      return WaterEntryModel.fromJson(response);
    } catch (e) {
      AppLogger.error('WaterRemoteDataSourceImpl.addWaterLog', e);
      rethrow;
    }
  }

  @override
  Future<void> deleteWaterLog(String id) async {
    try {
      final userId = _currentUserId;
      await _supabaseClient
          .from('water_logs')
          .delete()
          .eq('id', id)
          .eq('user_id', userId);
    } catch (e) {
      AppLogger.error('WaterRemoteDataSourceImpl.deleteWaterLog', e);
      rethrow;
    }
  }

  @override
  Future<int> getWaterGoal() async {
    try {
      final userId = _currentUserId;
      final response = await _supabaseClient
          .from('diet_preferences')
          .select('water_goal_ml')
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) {
        return 2500;
      }
      return response['water_goal_ml'] as int? ?? 2500;
    } catch (e) {
      AppLogger.error('WaterRemoteDataSourceImpl.getWaterGoal', e);
      rethrow;
    }
  }
}
