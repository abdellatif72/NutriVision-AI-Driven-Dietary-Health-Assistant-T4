import 'package:afia/app/app.dart';
import 'package:afia/app/di/injection_container.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await InjectionContainer.init();
  AfiaTypography.fontFamily = GoogleFonts.plusJakartaSans().fontFamily;
  runApp(const AfiaApp());
}
