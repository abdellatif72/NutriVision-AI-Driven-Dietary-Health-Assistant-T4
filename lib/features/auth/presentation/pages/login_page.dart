import 'package:afia/app/router/route_names.dart';
import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:afia/features/auth/presentation/bloc/auth_event.dart';
import 'package:afia/features/auth/presentation/bloc/auth_state.dart';
import 'package:afia/app/di/injection_container.dart';
import 'package:afia/features/more/domain/repositories/more_repository.dart';
import 'package:afia/app/localization/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AfiaColors.surface,
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
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
                Navigator.pushReplacementNamed(context, RouteNames.authPhysicalInformation);
              } else {
                Navigator.pushReplacementNamed(context, RouteNames.main);
              }
            } else if (state is AuthError) {
              final isEmailNotVerified = state.message.contains('تفعيل') ||
                  state.message.contains('برجاء') ||
                  state.message.contains('email-not-verified');

              if (isEmailNotVerified) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: AfiaColors.red,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              l10n.emailNotVerifiedError,
                              style: AfiaTypography.body.copyWith(
                                color: AfiaColors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    backgroundColor: AfiaColors.redContainer,
                    duration: const Duration(seconds: 6),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AfiaRadius.md),
                      side: const BorderSide(color: AfiaColors.red, width: 1.5),
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AfiaSpacing.pageMargin,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AfiaSpacing.xl),

                  // Back button
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      final fromOnboard =
                          ModalRoute.of(context)?.settings.arguments == true;
                      if (fromOnboard) {
                        Navigator.of(
                          context,
                        ).pushReplacementNamed(RouteNames.onboard);
                      } else {
                        Navigator.of(context).maybePop();
                      }
                    },
                    icon: Container(
                      padding: const EdgeInsetsDirectional.all(8),
                      decoration: BoxDecoration(
                        color: AfiaColors.trackInactive,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, size: 18),
                    ),
                  ),

                  const SizedBox(height: AfiaSpacing.xl),

                  Text(l10n.welcomeBack, style: AfiaTypography.statValue),
                  const SizedBox(height: AfiaSpacing.sm),
                  Text(
                    l10n.loginSubtitle,
                    style: AfiaTypography.body.copyWith(
                      color: AfiaColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: AfiaSpacing.xxxl),

                  // Email label
                  Text(
                    l10n.email,
                    style: AfiaTypography.label.copyWith(
                      color: AfiaColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AfiaSpacing.sm),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: l10n.emailHint,
                      filled: true,
                      fillColor: AfiaColors.surface,
                      contentPadding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AfiaRadius.lg),
                        borderSide: BorderSide(color: AfiaColors.divider),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AfiaRadius.lg),
                        borderSide: BorderSide(color: AfiaColors.divider),
                      ),
                    ),
                  ),

                  const SizedBox(height: AfiaSpacing.xl),

                  // Password
                  Text(
                    l10n.password,
                    style: AfiaTypography.label.copyWith(
                      color: AfiaColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AfiaSpacing.sm),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      hintText: l10n.passwordHint,
                      filled: true,
                      fillColor: AfiaColors.surface,
                      contentPadding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AfiaRadius.lg),
                        borderSide: BorderSide(color: AfiaColors.divider),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AfiaRadius.lg),
                        borderSide: BorderSide(color: AfiaColors.divider),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _obscure = !_obscure),
                        icon: Icon(
                          _obscure ? Icons.visibility : Icons.visibility_off,
                          color: AfiaColors.textSecondary,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AfiaSpacing.sm),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).pushNamed(RouteNames.authForgotPassword);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AfiaColors.primary,
                        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
                      ),
                      child: Text(
                        l10n.forgotPassword,
                        style: AfiaTypography.body.copyWith(
                          color: AfiaColors.primary,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AfiaSpacing.xl),

                  // Log in button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: state is AuthLoading
                          ? null
                          : () {
                              final email = _emailController.text.trim();
                              final password = _passwordController.text.trim();
                              if (email.isNotEmpty && password.isNotEmpty) {
                                context.read<AuthBloc>().add(
                                      LoginRequested(
                                        email: email,
                                        password: password,
                                      ),
                                    );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l10n.pleaseEnterEmailPassword),
                                  ),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AfiaColors.primary,
                        foregroundColor: AfiaColors.onPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AfiaRadius.xl),
                        ),
                        textStyle: AfiaTypography.cardTitle.copyWith(
                          color: AfiaColors.onPrimary,
                        ),
                      ),
                      child: state is AuthLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(l10n.logIn),
                    ),
                  ),

                  const SizedBox(height: AfiaSpacing.xl),

                  // OR with dividers
                  Row(
                    children: [
                      const Expanded(child: Divider(color: AfiaColors.divider)),
                      Padding(
                        padding: const EdgeInsetsDirectional.symmetric(horizontal: 12),
                        child: Text(
                          l10n.orContinueWith,
                          style: AfiaTypography.body.copyWith(
                            color: AfiaColors.textSecondary,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider(color: AfiaColors.divider)),
                    ],
                  ),

                  const SizedBox(height: AfiaSpacing.lg),

                  // Social buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: state is AuthLoading
                              ? null
                              : () {
                                  context
                                      .read<AuthBloc>()
                                      .add(GoogleSignInRequested());
                                },
                          icon: const Icon(Icons.g_mobiledata, color: Colors.black),
                          label: Text(
                            l10n.google,
                            style: AfiaTypography.body.copyWith(
                              color: AfiaColors.textPrimary,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 0,
                            side: BorderSide(color: AfiaColors.divider),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AfiaRadius.xl),
                            ),
                            padding: const EdgeInsetsDirectional.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: AfiaSpacing.lg),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: state is AuthLoading
                              ? null
                              : () {
                                  context
                                      .read<AuthBloc>()
                                      .add(AppleSignInRequested());
                                },
                          icon: const Icon(Icons.apple, color: Colors.black),
                          label: Text(
                            l10n.apple,
                            style: AfiaTypography.body.copyWith(
                              color: AfiaColors.textPrimary,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 0,
                            side: BorderSide(color: AfiaColors.divider),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AfiaRadius.xl),
                            ),
                            padding: const EdgeInsetsDirectional.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AfiaSpacing.xxxl),

                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.dontHaveAccount,
                          style: AfiaTypography.body.copyWith(
                            color: AfiaColors.textSecondary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(RouteNames.authSignup);
                          },
                          child: Text(
                            l10n.signUp,
                            style: AfiaTypography.body.copyWith(
                              color: AfiaColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AfiaSpacing.xxxl),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
