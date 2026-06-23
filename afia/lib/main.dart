import 'package:afia/app/app.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AfiaTypography.fontFamily = GoogleFonts.plusJakartaSans().fontFamily;
  runApp(const AfiaApp());
}
