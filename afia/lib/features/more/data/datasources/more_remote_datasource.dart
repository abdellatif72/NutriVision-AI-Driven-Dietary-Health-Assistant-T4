import 'package:afia/features/more/domain/entities/app_preferences.dart';
import 'package:afia/features/more/domain/entities/diet_preferences.dart';
import 'package:afia/features/more/domain/entities/notification_preferences.dart';
import 'package:afia/features/more/domain/entities/user_profile.dart';

abstract class MoreRemoteDataSource {
  Future<UserProfile> getProfile();
  Future<UserProfile> updateProfile(UserProfile profile);
  Future<DietPreferences> getDietPreferences();
  Future<DietPreferences> updateDietPreferences(DietPreferences prefs);
  Future<NotificationPreferences> getNotificationPreferences();
  Future<NotificationPreferences> updateNotificationPreferences(
    NotificationPreferences prefs,
  );
  Future<AppPreferences> getAppPreferences();
  Future<AppPreferences> updateAppPreferences(AppPreferences prefs);
}
