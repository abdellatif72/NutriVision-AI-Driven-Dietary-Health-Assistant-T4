import 'package:afia/app/router/route_names.dart';
import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:afia/features/auth/presentation/bloc/auth_event.dart';
import 'package:afia/features/auth/presentation/bloc/auth_state.dart';
import 'package:afia/app/di/injection_container.dart';
import 'package:afia/features/more/domain/repositories/more_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthCheckRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthAuthenticated) {
          final moreRepo = sl<MoreRepository>();
          final profileResult = await moreRepo.getProfile();
          if (!context.mounted) return;

          bool needsPhysicalInfo = true;
          profileResult.fold(
            (failure) => null,
            (profile) {
              if (profile.weightKg != null && profile.heightCm != null) {
                needsPhysicalInfo = false;
              }
            },
          );

          if (needsPhysicalInfo) {
            Navigator.of(context).pushReplacementNamed(RouteNames.authPhysicalInformation);
          } else {
            Navigator.of(context).pushReplacementNamed(RouteNames.main);
          }
        } else if (state is AuthUnauthenticated || state is AuthError) {
          Navigator.of(context).pushReplacementNamed(RouteNames.onboard);
        }
      },
      child: Scaffold(
        backgroundColor: AfiaColors.scaffoldBackground,
        body: const Center(
          child: CircularProgressIndicator(
            color: AfiaColors.primary,
          ),
        ),
      ),
    );
  }
}
