import 'package:afia/app/router/app_router.dart';
import 'package:afia/app/di/injection_container.dart';
import 'package:afia/core/theme/afia_theme.dart';
import 'package:afia/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AfiaApp extends StatelessWidget {
  const AfiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => sl<AuthBloc>(),
      child: MaterialApp(
        title: 'Afia',
        debugShowCheckedModeBanner: false,
        theme: AfiaTheme.light,
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: AppRouter.initialRoute,
      ),
    );
  }
}
