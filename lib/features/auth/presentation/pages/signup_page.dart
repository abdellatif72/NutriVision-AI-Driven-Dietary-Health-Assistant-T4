import 'package:afia/app/router/route_names.dart';
import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:afia/features/auth/presentation/bloc/auth_event.dart';
import 'package:afia/features/auth/presentation/bloc/auth_state.dart';
import 'package:afia/core/utils/validation_utils.dart';
import 'package:afia/app/localization/l10n.dart';
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
  String? _emailError;
  String? _passwordError;
  String? _emailSuggestion;
  bool _ignoredEmailSuggestion = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateEmail(String val, {bool showHardErrors = false}) {
    final locale = Localizations.localeOf(context).languageCode;
    final error = ValidationUtils.validateEmail(val, locale: locale);
    final suggestion = ValidationUtils.suggestEmailCorrection(val);
    setState(() {
      if (showHardErrors || _emailError != null) {
        _emailError = error;
      } else if (error == null) {
        _emailError = null;
      }
      _emailSuggestion = suggestion;
      _ignoredEmailSuggestion = false;
    });
  }

  void _validatePassword(String val) {
    final locale = Localizations.localeOf(context).languageCode;
    setState(() {
      _passwordError = ValidationUtils.validatePassword(val, locale: locale);
    });
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AfiaColors.surface,
      contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 18),
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
    final l10n = AppLocalizations.of(context)!;
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
              if (state is AuthSignUpSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      l10n.emailVerificationSent,
                      style: AfiaTypography.body.copyWith(
                        color: AfiaColors.onPrimary,
                      ),
                    ),
                    backgroundColor: AfiaColors.green500,
                    duration: const Duration(seconds: 6),
                  ),
                );
                Navigator.of(context).pushReplacementNamed(
                  RouteNames.authLogin,
                );
              } else if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              } else if (state is AuthValidationError) {
                setState(() {
                  _emailError = state.emailError;
                  _emailSuggestion = state.emailSuggestion;
                  _passwordError = state.passwordError;
                });
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
                    Text(l10n.createYourAccount, style: AfiaTypography.statValue),
                    const SizedBox(height: AfiaSpacing.sm),
                    Text(
                      l10n.letsGetStarted,
                      style: AfiaTypography.body.copyWith(
                        color: AfiaColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AfiaSpacing.xxxl),
                    Text(
                      l10n.fullName,
                      style: AfiaTypography.label.copyWith(
                        color: AfiaColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AfiaSpacing.sm),
                    TextField(
                      controller: _fullNameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: _inputDecoration(l10n.enterYourName),
                    ),
                    const SizedBox(height: AfiaSpacing.xl),
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
                      decoration: _inputDecoration(l10n.emailHint),
                      onChanged: (val) {
                        _validateEmail(val, showHardErrors: false);
                      },
                    ),
                    if (_emailSuggestion != null) ...[
                      const SizedBox(height: AfiaSpacing.xs),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: AfiaSpacing.xs),
                        child: GestureDetector(
                          onTap: () {
                            _emailController.text = _emailSuggestion!;
                            _emailController.selection = TextSelection.fromPosition(
                              TextPosition(offset: _emailSuggestion!.length),
                            );
                            _validateEmail(_emailSuggestion!, showHardErrors: true);
                          },
                          child: Text(
                            l10n.didYouMean(_emailSuggestion!),
                            style: AfiaTypography.caption.copyWith(
                              color: AfiaColors.orange,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                    ] else if (_emailError != null) ...[
                      const SizedBox(height: AfiaSpacing.xs),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: AfiaSpacing.xs),
                        child: Text(
                          _emailError!,
                          style: AfiaTypography.caption.copyWith(
                            color: AfiaColors.red,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                    const SizedBox(height: AfiaSpacing.xl),
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
                      decoration: _inputDecoration(l10n.passwordHint).copyWith(
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => _obscure = !_obscure),
                          icon: Icon(
                            _obscure ? Icons.visibility : Icons.visibility_off,
                            color: AfiaColors.textSecondary,
                          ),
                        ),
                      ),
                      onChanged: (val) {
                        if (_passwordError != null) {
                          _validatePassword(val);
                        }
                      },
                    ),
                    if (_passwordError != null) ...[
                      const SizedBox(height: AfiaSpacing.xs),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: AfiaSpacing.xs),
                        child: Text(
                          _passwordError!,
                          style: AfiaTypography.caption.copyWith(
                            color: AfiaColors.red,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
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

                                _validateEmail(email, showHardErrors: true);
                                _validatePassword(password);

                                if (name.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.pleaseFillAllFields),
                                    ),
                                  );
                                  return;
                                }

                                if (_emailError == null && _passwordError == null) {
                                  final hasSuggestion = _emailSuggestion != null;
                                  
                                  if (hasSuggestion && !_ignoredEmailSuggestion) {
                                    setState(() {
                                      _ignoredEmailSuggestion = true;
                                    });
                                    return;
                                  }

                                  context.read<AuthBloc>().add(
                                        SignUpRequested(
                                          email: email,
                                          password: password,
                                          name: name,
                                          ignoreWarnings: _ignoredEmailSuggestion,
                                          locale: Localizations.localeOf(context).languageCode,
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
                            : Text(l10n.signUp),
                      ),
                    ),
                    const SizedBox(height: AfiaSpacing.xl),
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
                    const SizedBox(height: AfiaSpacing.xl),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.alreadyHaveAccount,
                            style: AfiaTypography.body.copyWith(
                              color: AfiaColors.textSecondary,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(RouteNames.authLogin);
                            },
                            child: Text(
                              l10n.logIn,
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
