import 'package:afia/core/constants/app_secrets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  test('Supabase Connection & Data Diagnostics', () async {
    print('--- Supabase Connection & Data Diagnostics ---');
    try {
      print('1. Initializing Supabase with URL and Anon Key...');
      SharedPreferences.setMockInitialValues({});
      await Supabase.initialize(
        url: AppSecrets.supabaseUrl,
        anonKey: AppSecrets.supabaseAnonKey,
      );

      final client = Supabase.instance.client;
      print('Success: Supabase client initialized.');
      print('Supabase URL: ${AppSecrets.supabaseUrl}');

      print('\n2. Attempting to query public.logged_meals table...');
      final response = await client.from('logged_meals').select();
      print('Success: Query executed without database connection errors.');
      print(
        'Number of rows returned (without authentication session): ${response.length}',
      );
      if (response.isNotEmpty) {
        print('First row: $response');
      }

      print('\n3. Checking auth state...');
      final session = client.auth.currentSession;
      if (session == null) {
        print(
          'Current Supabase Session: NULL (User is not authenticated with Supabase)',
        );
      } else {
        print('Current Supabase Session: ACTIVE');
        print('User ID: ${session.user.id}');
      }
    } catch (e) {
      print('Error: $e');
      fail('Supabase connection or query failed: $e');
    }
  });
}
