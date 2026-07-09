import 'package:afia/app/router/route_names.dart';
import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:afia/features/auth/presentation/bloc/auth_event.dart';
import 'package:afia/features/auth/presentation/bloc/auth_state.dart';
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
    return Scaffold(
      backgroundColor: AfiaColors.surface,
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                RouteNames.main,
                (route) => false,
              );
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
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
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AfiaColors.trackInactive,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back, size: 18),
                ),
              ),

              const SizedBox(height: AfiaSpacing.xl),

              Text('Welcome back!', style: AfiaTypography.statValue),
              const SizedBox(height: AfiaSpacing.sm),
              Text(
                'Log in to continue your journey.',
                style: AfiaTypography.body.copyWith(
                  color: AfiaColors.textSecondary,
                ),
              ),

              const SizedBox(height: AfiaSpacing.xxxl),

              // Email label
              Text(
                'Email',
                style: AfiaTypography.label.copyWith(
                  color: AfiaColors.textPrimary,
                ),
              ),
              const SizedBox(height: AfiaSpacing.sm),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'you@example.com',
                  filled: true,
                  fillColor: AfiaColors.surface,
                  contentPadding: const EdgeInsets.symmetric(
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
                'Password',
                style: AfiaTypography.label.copyWith(
                  color: AfiaColors.textPrimary,
                ),
              ),
              const SizedBox(height: AfiaSpacing.sm),
              TextField(
                controller: _passwordController,
                obscureText: _obscure,
                decoration: InputDecoration(
                  hintText: '• • • • • • • • •',
                  filled: true,
                  fillColor: AfiaColors.surface,
                  contentPadding: const EdgeInsets.symmetric(
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
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: Text(
                    'Forgot password?',
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
                              const SnackBar(
                                content: Text('Please enter email and password'),
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
                      : const Text('Log In'),
                ),
              ),

              const SizedBox(height: AfiaSpacing.xl),

              // OR with dividers
              Row(
                children: [
                  const Expanded(child: Divider(color: AfiaColors.divider)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'or continue with',
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
                        'Google',
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
                        padding: const EdgeInsets.symmetric(vertical: 14),
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
                        'Apple',
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
                        padding: const EdgeInsets.symmetric(vertical: 14),
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
                      "Don't have an account? ",
                      style: AfiaTypography.body.copyWith(
                        color: AfiaColors.textSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(RouteNames.authSignup);
                      },
                      child: Text(
                        'Sign up',
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
