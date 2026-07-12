import 'app_secrets.dart';

abstract final class AppConstants {
  static const appName = 'Afia';

  // Supabase Configuration
  static const supabaseUrl = AppSecrets.supabaseUrl;
  static const supabaseAnonKey = AppSecrets.supabaseAnonKey;

  // Gemini Configuration
  static const geminiApiKey = AppSecrets.geminiApiKey;

  // Groq Configuration (free alternative for vision AI)
  static const groqApiKey = AppSecrets.groqApiKey;
}
