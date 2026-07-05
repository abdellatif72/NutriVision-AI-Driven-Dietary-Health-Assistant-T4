import 'package:afia/core/theme/afia_theme.dart';
import 'package:afia/features/more/presentation/pages/more_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: MorePage()),
  );
}
