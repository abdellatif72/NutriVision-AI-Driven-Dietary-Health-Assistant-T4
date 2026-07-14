import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/app/localization/l10n.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isSaving = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: AfiaColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(isAr ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(l10n.changePassword, style: AfiaTypography.screenTitle),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsetsDirectional.fromSTEB(
          AfiaSpacing.pageMargin,
          AfiaSpacing.xl,
          AfiaSpacing.pageMargin,
          AfiaSpacing.xxxl,
        ),
        children: [
          Container(
            padding: const EdgeInsetsDirectional.all(AfiaSpacing.lg),
            decoration: BoxDecoration(
              color: AfiaColors.surface,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                _buildPasswordField(
                  controller: _currentPasswordController,
                  label: l10n.currentPassword,
                  obscure: _obscureCurrent,
                  onToggle: () =>
                      setState(() => _obscureCurrent = !_obscureCurrent),
                ),
                const SizedBox(height: AfiaSpacing.md),
                _buildPasswordField(
                  controller: _newPasswordController,
                  label: l10n.newPassword,
                  obscure: _obscureNew,
                  onToggle: () => setState(() => _obscureNew = !_obscureNew),
                ),
                const SizedBox(height: AfiaSpacing.md),
                _buildPasswordField(
                  controller: _confirmPasswordController,
                  label: l10n.confirmNewPassword,
                  obscure: _obscureConfirm,
                  onToggle: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                ),
              ],
            ),
          ),
          const SizedBox(height: AfiaSpacing.md),
          Text(
            l10n.passwordRequirements,
            style: AfiaTypography.body.copyWith(
              color: AfiaColors.textSecondary,
            ),
          ),
          const SizedBox(height: AfiaSpacing.xxxl),
          FilledButton(
            onPressed: _isSaving ? null : () => _onSave(l10n),
            style: FilledButton.styleFrom(
              backgroundColor: AfiaColors.primary,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            child: _isSaving
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AfiaColors.onPrimary,
                    ),
                  )
                : Text(
                    l10n.updatePassword,
                    style: AfiaTypography.cardTitle.copyWith(
                      color: AfiaColors.onPrimary,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: AfiaTypography.body,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AfiaTypography.body.copyWith(
          color: AfiaColors.textSecondary,
        ),
        prefixIcon: const Icon(
          Icons.lock_outline_rounded,
          color: AfiaColors.textSecondary,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: AfiaColors.textMuted,
          ),
          onPressed: onToggle,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AfiaColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AfiaColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AfiaColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsetsDirectional.symmetric(
          horizontal: AfiaSpacing.lg,
          vertical: AfiaSpacing.md,
        ),
      ),
    );
  }

  void _onSave(AppLocalizations l10n) {
    final current = _currentPasswordController.text.trim();
    final newPass = _newPasswordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();

    if (current.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseEnterCurrentPassword)),
      );
      return;
    }

    if (newPass.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.passwordRequirements)),
      );
      return;
    }

    if (newPass != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.passwordsDoNotMatch)),
      );
      return;
    }

    setState(() => _isSaving = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() => _isSaving = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.passwordUpdatedSuccess)),
      );
      Navigator.pop(context);
    });
  }
}
