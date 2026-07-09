import 'package:afia/app/router/route_names.dart';
import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:afia/features/auth/presentation/bloc/auth_event.dart';
import 'package:afia/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        final fromOnboard = ModalRoute.of(context)?.settings.arguments == true;
        if (fromOnboard) {
          Navigator.of(context).pushReplacementNamed(RouteNames.onboard);
        } else {
          Navigator.of(context).maybePop();
        }
      },
      child: Scaffold(
        backgroundColor: AfiaColors.surface,
        body: SafeArea(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthAuthenticated) {
                Navigator.of(context).pushReplacementNamed(
                  RouteNames.authPhysicalInformation,
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
                Text('Create your account', style: AfiaTypography.statValue),
                const SizedBox(height: AfiaSpacing.sm),
                Text(
                  'Let\'s get you started.',
                  style: AfiaTypography.body.copyWith(
                    color: AfiaColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AfiaSpacing.xxxl),
                Text(
                  'Full name',
                  style: AfiaTypography.label.copyWith(
                    color: AfiaColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AfiaSpacing.sm),
                TextField(
                  controller: _fullNameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: _inputDecoration('Enter your name'),
                ),
                const SizedBox(height: AfiaSpacing.xl),
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
                  decoration: _inputDecoration('you@example.com'),
                ),
                const SizedBox(height: AfiaSpacing.xl),
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
                  decoration: _inputDecoration('• • • • • • • • •').copyWith(
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obscure = !_obscure),
                      icon: Icon(
                        _obscure ? Icons.visibility : Icons.visibility_off,
                        color: AfiaColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AfiaSpacing.xxxl),
                 SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: state is AuthLoading
                        ? null
                        : () {
                            final name = _fullNameController.text.trim();
                            final email = _emailController.text.trim();
                            final password = _passwordController.text.trim();
                            if (name.isNotEmpty &&
                                email.isNotEmpty &&
                                password.isNotEmpty) {
                              context.read<AuthBloc>().add(
                                    SignUpRequested(
                                      email: email,
                                      password: password,
                                      name: name,
                                    ),
                                  );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please fill out all fields'),
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
                        : const Text('Sign Up'),
                  ),
                ),
                const SizedBox(height: AfiaSpacing.xl),
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
                        icon: const Icon(
                          Icons.g_mobiledata,
                          color: Colors.black,
                        ),
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
                const SizedBox(height: AfiaSpacing.xl),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: AfiaTypography.body.copyWith(
                          color: AfiaColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(RouteNames.authLogin);
                        },
                        child: Text(
                          'Log in',
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
   ),
  );
 }
}
