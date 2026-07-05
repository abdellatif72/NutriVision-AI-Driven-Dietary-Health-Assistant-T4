import 'package:afia/app/router/app_router.dart';
import 'package:afia/core/theme/afia_theme.dart';
import 'package:flutter/material.dart';

class AfiaApp extends StatelessWidget {
  const AfiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Afia',
      debugShowCheckedModeBanner: false,
      theme: AfiaTheme.light,
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AppRouter.initialRoute,
    );
  }
}
