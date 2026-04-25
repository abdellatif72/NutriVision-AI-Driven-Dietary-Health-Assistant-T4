import 'package:afia/app/router/app_router.dart';
import 'package:afia/app/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AfiaApp extends StatelessWidget {
  const AfiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Afia',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AppRouter.initialRoute,
    );
  }
}
