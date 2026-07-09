import 'package:afia/app/router/route_names.dart';
import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:afia/features/auth/presentation/bloc/auth_event.dart';
import 'package:afia/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AfiaColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AfiaRadius.lg),
        borderSide: BorderSide(color: AfiaColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AfiaRadius.lg),
        borderSide: BorderSide(color: AfiaColors.divider),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AfiaColors.surface,
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthPasswordResetSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password reset link sent to your email.'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.of(context).pushReplacementNamed(RouteNames.authLogin);
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
              padding: const EdgeInsets.symmetric(horizontal: AfiaSpacing.pageMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AfiaSpacing.xl),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => Navigator.of(context).maybePop(),
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
              Text('Forgot password?', style: AfiaTypography.statValue),
              const SizedBox(height: AfiaSpacing.sm),
              Text('Enter your email to reset your password.',
                  style: AfiaTypography.body.copyWith(color: AfiaColors.textSecondary)),
              const SizedBox(height: AfiaSpacing.xxxl),
              Text('Email', style: AfiaTypography.label.copyWith(color: AfiaColors.textPrimary)),
              const SizedBox(height: AfiaSpacing.sm),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration('you@example.com'),
              ),
              const SizedBox(height: AfiaSpacing.xxxl),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: state is AuthLoading
                      ? null
                      : () {
                          final email = _emailController.text.trim();
                          if (email.isNotEmpty) {
                            context.read<AuthBloc>().add(
                                  ResetPasswordRequested(email: email),
                                );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter your email'),
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AfiaColors.primary,
                    foregroundColor: AfiaColors.onPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AfiaRadius.xl)),
                    textStyle: AfiaTypography.cardTitle.copyWith(color: AfiaColors.onPrimary),
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
                      : const Text('Send Reset Link'),
                ),
              ),
              const SizedBox(height: AfiaSpacing.xxxl),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed(RouteNames.authLogin);
                  },
                  child: Text('Remembered your password? Log in',
                      style: AfiaTypography.body.copyWith(color: AfiaColors.primary, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: AfiaSpacing.xxxl),
            ],
           );
          },
         ),
        ),
      ),
    );
  }
}
