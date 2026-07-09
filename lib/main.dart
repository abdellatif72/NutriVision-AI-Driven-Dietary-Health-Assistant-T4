import 'package:afia/app/app.dart';
import 'package:afia/app/di/injection_container.dart';
import 'package:afia/core/constants/app_constants.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase Auth
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Supabase Database
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
  );

  await InjectionContainer.init();
  AfiaTypography.fontFamily = GoogleFonts.plusJakartaSans().fontFamily;
  runApp(const AfiaApp());
}
