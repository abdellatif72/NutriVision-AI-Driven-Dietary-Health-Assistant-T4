import 'package:afia/features/more/domain/entities/app_preferences.dart';
import 'package:afia/features/more/domain/entities/diet_preferences.dart';
import 'package:afia/features/more/domain/entities/user_profile.dart';

abstract class MoreLocalDataSource {
  Future<UserProfile> getCachedProfile();
  Future<void> cacheProfile(UserProfile profile);
  Future<DietPreferences> getCachedDietPreferences();
  Future<void> cacheDietPreferences(DietPreferences prefs);
  Future<AppPreferences> getCachedAppPreferences();
  Future<void> cacheAppPreferences(AppPreferences prefs);
}
