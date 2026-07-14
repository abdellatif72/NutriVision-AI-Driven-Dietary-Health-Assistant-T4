import 'dart:typed_data';
import 'package:afia/features/more/data/datasources/more_remote_datasource.dart';
import 'package:afia/features/more/data/models/app_preferences_model.dart';
import 'package:afia/features/more/data/models/diet_preferences_model.dart';
import 'package:afia/features/more/data/models/user_profile_model.dart';
import 'package:afia/features/more/domain/entities/app_preferences.dart';
import 'package:afia/features/more/domain/entities/diet_preferences.dart';
import 'package:afia/features/more/domain/entities/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:supabase_flutter/supabase_flutter.dart';

class MoreRemoteDataSourceImpl implements MoreRemoteDataSource {
  final SupabaseClient _supabaseClient;
  final firebase_auth.FirebaseAuth _firebaseAuth;

  MoreRemoteDataSourceImpl({
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

  Map<String, dynamic> _profileToDb(UserProfile profile) {
    return {
      'id': profile.id,
      'name': profile.name,
      'photo_url': profile.photoUrl,
      'age': profile.age,
      'gender': profile.gender,
      'height_cm': profile.heightCm,
      'weight_kg': profile.weightKg,
      'activity_level': profile.activityLevel,
      'streak_days': profile.streakDays,
      'current_goal': profile.currentGoal,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    };
  }

  UserProfile _profileFromDb(Map<String, dynamic> row) {
    return UserProfileModel(
      id: row['id'] as String,
      name: row['name'] as String,
      photoUrl: row['photo_url'] as String?,
      age: row['age'] as int?,
      gender: row['gender'] as String?,
      heightCm: (row['height_cm'] as num?)?.toDouble(),
      weightKg: (row['weight_kg'] as num?)?.toDouble(),
      activityLevel: row['activity_level'] as String?,
      streakDays: row['streak_days'] as int? ?? 0,
      currentGoal: row['current_goal'] as String?,
      createdAt: row['created_at'] != null ? DateTime.parse(row['created_at'] as String) : null,
      updatedAt: row['updated_at'] != null ? DateTime.parse(row['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> _dietToDb(DietPreferences prefs, String userId) {
    return {
      'user_id': userId,
      'diet_style': prefs.dietStyle,
      'goal_type': prefs.goalType,
      'calorie_target': prefs.calorieTarget,
      'carbs_pct': prefs.carbsPct,
      'protein_pct': prefs.proteinPct,
      'fat_pct': prefs.fatPct,
      'allergies': prefs.allergies,
      'disliked_foods': prefs.dislikedFoods,
      'preferred_cuisines': prefs.preferredCuisines,
      'meals_per_day': prefs.mealsPerDay,
      'fasting_enabled': prefs.fastingEnabled,
      'water_goal_ml': prefs.waterGoalMl,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    };
  }

  DietPreferences _dietFromDb(Map<String, dynamic> row) {
    return DietPreferencesModel(
      dietStyle: row['diet_style'] as String? ?? 'balanced',
      goalType: row['goal_type'] as String? ?? 'maintain',
      calorieTarget: row['calorie_target'] as int?,
      carbsPct: row['carbs_pct'] as int? ?? 50,
      proteinPct: row['protein_pct'] as int? ?? 20,
      fatPct: row['fat_pct'] as int? ?? 30,
      allergies: (row['allergies'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      dislikedFoods: (row['disliked_foods'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      preferredCuisines: (row['preferred_cuisines'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      mealsPerDay: row['meals_per_day'] as int? ?? 3,
      fastingEnabled: row['fasting_enabled'] as bool? ?? false,
      waterGoalMl: row['water_goal_ml'] as int? ?? 2500,
    );
  }

  Map<String, dynamic> _appToDb(AppPreferences prefs, String userId) {
    return {
      'user_id': userId,
      'theme_mode': prefs.themeMode,
      'language': prefs.language,
      'units': prefs.units,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    };
  }

  AppPreferences _appFromDb(Map<String, dynamic> row) {
    return AppPreferencesModel(
      themeMode: row['theme_mode'] as String? ?? 'system',
      language: row['language'] as String? ?? 'ar',
      units: row['units'] as String? ?? 'metric',
    );
  }

  @override
  Future<UserProfile> getProfile() async {
    final userId = _currentUserId;
    final response = await _supabaseClient
        .from('user_profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response == null) {
      // Return a default empty profile
      final name = _firebaseAuth.currentUser?.displayName ?? '';
      return UserProfile(id: userId, name: name);
    }
    return _profileFromDb(response);
  }

  @override
  Future<UserProfile> updateProfile(UserProfile profile) async {
    final data = _profileToDb(profile);
    await _supabaseClient.from('user_profiles').upsert(data);
    return profile;
  }

  @override
  Future<String> uploadProfileImage(Uint8List bytes, String fileName) async {
    final userId = _currentUserId;
    final fileExtension = fileName.split('.').last;
    final path = '$userId/profile.$fileExtension';

    await _supabaseClient.storage.from('avatars').uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(
            upsert: true,
            contentType: 'image/$fileExtension',
          ),
        );

    final publicUrl = _supabaseClient.storage.from('avatars').getPublicUrl(path);

    await _supabaseClient
        .from('user_profiles')
        .update({'photo_url': publicUrl})
        .eq('id', userId);

    return publicUrl;
  }

  @override
  Future<DietPreferences> getDietPreferences() async {
    final userId = _currentUserId;
    final response = await _supabaseClient
        .from('diet_preferences')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) {
      return const DietPreferences();
    }
    return _dietFromDb(response);
  }

  @override
  Future<DietPreferences> updateDietPreferences(DietPreferences prefs) async {
    final userId = _currentUserId;
    final data = _dietToDb(prefs, userId);
    await _supabaseClient.from('diet_preferences').upsert(data);
    return prefs;
  }

  @override
  Future<AppPreferences> getAppPreferences() async {
    final userId = _currentUserId;
    final response = await _supabaseClient
        .from('app_preferences')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) {
      return const AppPreferences();
    }
    return _appFromDb(response);
  }

  @override
  Future<AppPreferences> updateAppPreferences(AppPreferences prefs) async {
    final userId = _currentUserId;
    final data = _appToDb(prefs, userId);
    await _supabaseClient.from('app_preferences').upsert(data);
    return prefs;
  }
}
