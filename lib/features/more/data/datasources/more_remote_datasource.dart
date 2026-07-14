import 'dart:typed_data';
import 'package:afia/features/more/domain/entities/app_preferences.dart';
import 'package:afia/features/more/domain/entities/diet_preferences.dart';
import 'package:afia/features/more/domain/entities/user_profile.dart';

abstract class MoreRemoteDataSource {
  Future<UserProfile> getProfile();
  Future<UserProfile> updateProfile(UserProfile profile);
  Future<String> uploadProfileImage(Uint8List bytes, String fileName);
  Future<DietPreferences> getDietPreferences();
  Future<DietPreferences> updateDietPreferences(DietPreferences prefs);
  Future<AppPreferences> getAppPreferences();
  Future<AppPreferences> updateAppPreferences(AppPreferences prefs);
}
