import 'dart:convert';
import 'package:afia/core/error/exceptions.dart';
import 'package:afia/features/more/data/datasources/more_local_datasource.dart';
import 'package:afia/features/more/data/models/app_preferences_model.dart';
import 'package:afia/features/more/data/models/diet_preferences_model.dart';
import 'package:afia/features/more/data/models/notification_preferences_model.dart';
import 'package:afia/features/more/data/models/user_profile_model.dart';
import 'package:afia/features/more/domain/entities/app_preferences.dart';
import 'package:afia/features/more/domain/entities/diet_preferences.dart';
import 'package:afia/features/more/domain/entities/notification_preferences.dart';
import 'package:afia/features/more/domain/entities/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoreLocalDataSourceImpl implements MoreLocalDataSource {
  final SharedPreferences _sharedPreferences;

  MoreLocalDataSourceImpl({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  static const _profileKey = 'CACHED_USER_PROFILE';
  static const _dietKey = 'CACHED_DIET_PREFERENCES';
  static const _notificationKey = 'CACHED_NOTIFICATION_PREFERENCES';
  static const _appKey = 'CACHED_APP_PREFERENCES';

  @override
  Future<UserProfile> getCachedProfile() async {
    final jsonString = _sharedPreferences.getString(_profileKey);
    if (jsonString != null) {
      return UserProfileModel.fromJson(
        json.decode(jsonString) as Map<String, dynamic>,
      );
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheProfile(UserProfile profile) async {
    final model = UserProfileModel.fromEntity(profile);
    await _sharedPreferences.setString(
      _profileKey,
      json.encode(model.toJson()),
    );
  }

  @override
  Future<DietPreferences> getCachedDietPreferences() async {
    final jsonString = _sharedPreferences.getString(_dietKey);
    if (jsonString != null) {
      return DietPreferencesModel.fromJson(
        json.decode(jsonString) as Map<String, dynamic>,
      );
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheDietPreferences(DietPreferences prefs) async {
    final model = DietPreferencesModel.fromEntity(prefs);
    await _sharedPreferences.setString(
      _dietKey,
      json.encode(model.toJson()),
    );
  }

  @override
  Future<NotificationPreferences> getCachedNotificationPreferences() async {
    final jsonString = _sharedPreferences.getString(_notificationKey);
    if (jsonString != null) {
      return NotificationPreferencesModel.fromJson(
        json.decode(jsonString) as Map<String, dynamic>,
      );
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheNotificationPreferences(NotificationPreferences prefs) async {
    final model = NotificationPreferencesModel.fromEntity(prefs);
    await _sharedPreferences.setString(
      _notificationKey,
      json.encode(model.toJson()),
    );
  }

  @override
  Future<AppPreferences> getCachedAppPreferences() async {
    final jsonString = _sharedPreferences.getString(_appKey);
    if (jsonString != null) {
      return AppPreferencesModel.fromJson(
        json.decode(jsonString) as Map<String, dynamic>,
      );
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheAppPreferences(AppPreferences prefs) async {
    final model = AppPreferencesModel.fromEntity(prefs);
    await _sharedPreferences.setString(
      _appKey,
      json.encode(model.toJson()),
    );
  }
}
