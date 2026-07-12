import 'package:afia/app/router/app_router.dart';
import 'package:afia/app/di/injection_container.dart';
import 'package:afia/core/theme/afia_theme.dart';
import 'package:afia/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:afia/app/localization/l10n.dart';
import 'package:afia/app/localization/locale_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AfiaApp extends StatelessWidget {
  const AfiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => sl<AuthBloc>()),
        BlocProvider<LocaleCubit>(create: (context) => LocaleCubit()),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp(
            title: 'Afia',
            debugShowCheckedModeBanner: false,
            theme: AfiaTheme.light,
            locale: locale,
            supportedLocales: AppLocales.supported,
            localizationsDelegates: AppLocales.delegates,
            onGenerateRoute: AppRouter.onGenerateRoute,
            initialRoute: AppRouter.initialRoute,
          );
        },
      ),
    );
  }
}
