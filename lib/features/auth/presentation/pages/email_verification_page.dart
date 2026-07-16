import 'dart:async';
import 'package:afia/app/di/injection_container.dart';
import 'package:afia/app/router/route_names.dart';
import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:afia/features/auth/presentation/bloc/auth_event.dart';
import 'package:afia/features/auth/presentation/bloc/auth_state.dart';
import 'package:afia/features/more/domain/repositories/more_repository.dart';
import 'package:afia/app/localization/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  Timer? _cooldownTimer;
  int _cooldownSeconds = 0;

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _startCooldown() {
    setState(() {
      _cooldownSeconds = 60;
    });
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        if (_cooldownSeconds > 0) {
          setState(() {
            _cooldownSeconds--;
          });
        } else {
          _cooldownTimer?.cancel();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        // Clean sign out when backing out of the verification screen
        context.read<AuthBloc>().add(SignOutRequested());
      },
      child: Scaffold(
        backgroundColor: AfiaColors.surface,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AfiaColors.trackInactive,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, size: 18, color: AfiaColors.textPrimary),
            ),
            onPressed: () {
              context.read<AuthBloc>().add(SignOutRequested());
            },
          ),
        ),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) async {
            if (state is AuthAuthenticated) {
              if (state.verificationSentSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      l10n.verificationEmailResent,
                      style: AfiaTypography.body.copyWith(
                        color: AfiaColors.onPrimary,
                      ),
                    ),
                    backgroundColor: AfiaColors.green500,
                  ),
                );
              } else if (state.verificationError != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.verificationError!),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            } else if (state is AuthUnauthenticated || state is AuthError) {
              Navigator.of(context).pushReplacementNamed(RouteNames.authLogin);
            }
          },
          builder: (context, state) {
            String emailText = '';
            bool isSending = false;

            if (state is AuthAuthenticated) {
              emailText = state.user.email;
              isSending = state.isSendingVerification;
            }

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AfiaSpacing.pageMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: AfiaSpacing.xxxl),
                    // Large premium mail icon with brand lime-green accent
                    Center(
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: const BoxDecoration(
                          color: AfiaColors.green50,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.mark_email_unread_outlined,
                          size: 64,
                          color: AfiaColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: AfiaSpacing.xxxl),
                    Text(
                      l10n.emailVerificationTitle,
                      style: AfiaTypography.statValueCompact,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AfiaSpacing.md),
                    Text(
                      l10n.emailVerificationExplanation,
                      style: AfiaTypography.body.copyWith(
                        color: AfiaColors.textSecondary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AfiaSpacing.xxl),
                    
                    // Box containing the registered email address
                    if (emailText.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AfiaSpacing.lg,
                          vertical: AfiaSpacing.md,
                        ),
                        decoration: BoxDecoration(
                          color: AfiaColors.scaffoldBackground,
                          borderRadius: BorderRadius.circular(AfiaRadius.md),
                          border: Border.all(color: AfiaColors.divider),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.alternate_email,
                              size: 16,
                              color: AfiaColors.textSecondary,
                            ),
                            const SizedBox(width: AfiaSpacing.sm),
                            Flexible(
                              child: Text(
                                emailText,
                                style: AfiaTypography.label.copyWith(
                                  color: AfiaColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    const SizedBox(height: 48),

                    // Primary Button: Confirm email received (routes to login screen by signing out)
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: state is AuthLoading
                            ? null
                            : () {
                                context.read<AuthBloc>().add(SignOutRequested());
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
                            : Text(l10n.confirmEmailReceived),
                      ),
                    ),
                    const SizedBox(height: AfiaSpacing.md),

                    // Secondary Button: Resend Verification Email (shows timer when cooldown is active)
                    Center(
                      child: TextButton(
                        onPressed: (isSending || _cooldownSeconds > 0)
                            ? null
                            : () {
                                context.read<AuthBloc>().add(SendEmailVerificationRequested());
                                _startCooldown();
                              },
                        style: TextButton.styleFrom(
                          foregroundColor: AfiaColors.primary,
                          textStyle: AfiaTypography.body.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: isSending
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: AfiaColors.primary,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                _cooldownSeconds > 0
                                    ? (Localizations.localeOf(context).languageCode == 'ar'
                                        ? 'إعادة الإرسال خلال $_cooldownSeconds ثانية'
                                        : 'Resend in $_cooldownSeconds seconds')
                                    : l10n.resendVerificationEmail,
                              ),
                      ),
                    ),
                    const SizedBox(height: AfiaSpacing.xxxl),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
