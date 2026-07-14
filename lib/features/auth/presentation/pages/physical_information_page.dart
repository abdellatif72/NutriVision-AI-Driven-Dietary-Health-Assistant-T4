import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/app/router/route_names.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/app/localization/l10n.dart';
import 'package:flutter/material.dart';

class PhysicalInformationPage extends StatefulWidget {
  const PhysicalInformationPage({super.key});

  @override
  State<PhysicalInformationPage> createState() => _PhysicalInformationPageState();
}

class _PhysicalInformationPageState extends State<PhysicalInformationPage> {
  String _selectedGender = 'Male';
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  bool _isWeightKg = true;
  bool _isHeightCm = true;

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  String get _weightUnit => _isWeightKg ? 'kg' : 'lb';
  String get _heightUnit => _isHeightCm ? 'cm' : 'ft';

  void _toggleWeightUnit() {
    final currentValue = _weightController.text.trim();
    if (currentValue.isNotEmpty) {
      final converted = _isWeightKg
          ? _convertWeight(currentValue, toKg: false)
          : _convertWeight(currentValue, toKg: true);
      _weightController.text = converted;
    }

    setState(() {
      _isWeightKg = !_isWeightKg;
    });
  }

  void _toggleHeightUnit() {
    final currentValue = _heightController.text.trim();
    if (currentValue.isNotEmpty) {
      final converted = _isHeightCm
          ? _convertHeight(currentValue, toCm: false)
          : _convertHeight(currentValue, toCm: true);
      _heightController.text = converted;
    }

    setState(() {
      _isHeightCm = !_isHeightCm;
    });
  }

  String _convertWeight(String value, {required bool toKg}) {
    final parsed = double.tryParse(value) ?? 0;
    final converted = toKg ? parsed / 2.20462 : parsed * 2.20462;
    return converted % 1 == 0 ? converted.toStringAsFixed(0) : converted.toStringAsFixed(1);
  }

  String _convertHeight(String value, {required bool toCm}) {
    final parsed = double.tryParse(value) ?? 0;
    final converted = toCm ? parsed * 30.48 : parsed / 30.48;
    return converted % 1 == 0 ? converted.toStringAsFixed(0) : converted.toStringAsFixed(1);
  }

  Widget _buildOption(String label, IconData icon, bool selected) {
    return Flexible(
      fit: FlexFit.tight,
      child: Container(
        constraints: const BoxConstraints(minWidth: 140),
        height: 100,
        decoration: BoxDecoration(
          color: selected ? AfiaColors.primary.withOpacity(0.16) : AfiaColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AfiaColors.primary : AfiaColors.divider,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: selected ? AfiaColors.primary : AfiaColors.textSecondary, size: 26),
            const SizedBox(height: AfiaSpacing.sm),
            Text(
              label,
              style: AfiaTypography.body.copyWith(
                fontWeight: FontWeight.w700,
                color: selected ? AfiaColors.textPrimary : AfiaColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsetsDirectional.only(bottom: AfiaSpacing.xl),
      padding: const EdgeInsetsDirectional.all(AfiaSpacing.lg),
      decoration: BoxDecoration(
        color: AfiaColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AfiaColors.primary.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: AfiaColors.primary, size: 24),
              ),
              const SizedBox(width: AfiaSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AfiaTypography.cardTitle),
                    const SizedBox(height: 4),
                    Text(subtitle, style: AfiaTypography.body.copyWith(color: AfiaColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AfiaSpacing.xl),
          child,
        ],
      ),
    );
  }

  Widget _buildInputRow({
    required TextEditingController controller,
    required String hint,
    required String unit,
    required VoidCallback onUnitTap,
    required IconData icon,
  }) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: AfiaColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AfiaColors.divider),
      ),
      child: Row(
        children: [
          const SizedBox(width: AfiaSpacing.sm),
          Icon(icon, color: AfiaColors.primary),
          const SizedBox(width: AfiaSpacing.sm),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: TextStyle(color: AfiaColors.textSecondary),
              ),
              style: AfiaTypography.body,
            ),
          ),
          const SizedBox(width: AfiaSpacing.sm),
          TextButton(
            onPressed: onUnitTap,
            style: TextButton.styleFrom(
              minimumSize: const Size(72, 44),
              padding: const EdgeInsetsDirectional.symmetric(horizontal: AfiaSpacing.md),
              backgroundColor: AfiaColors.primary.withOpacity(0.12),
              foregroundColor: AfiaColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text(unit, style: AfiaTypography.body.copyWith(fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: AfiaSpacing.sm),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: AfiaColors.scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: AfiaSpacing.pageMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AfiaSpacing.xl),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => Navigator.maybePop(context),
                  icon: Container(
                    padding: const EdgeInsetsDirectional.all(10),
                    decoration: BoxDecoration(
                      color: AfiaColors.surface,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      isAr ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded,
                      size: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AfiaSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: AfiaColors.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: AfiaSpacing.sm),
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: AfiaColors.primary.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AfiaSpacing.sm),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Container(
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: AfiaSpacing.lg, vertical: AfiaSpacing.sm),
                  decoration: BoxDecoration(
                    color: AfiaColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    l10n.stepOneOfTwo,
                    style: AfiaTypography.body.copyWith(
                      color: AfiaColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AfiaSpacing.xl),
              Text(
                l10n.physicalInformation,
                textAlign: TextAlign.center,
                style: AfiaTypography.statValue.copyWith(fontSize: 32),
              ),
              const SizedBox(height: AfiaSpacing.sm),
              Text(
                l10n.physicalInfoSubtitle,
                textAlign: TextAlign.center,
                style: AfiaTypography.body.copyWith(
                  color: AfiaColors.textSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: AfiaSpacing.xxxl),
              _buildSection(
                icon: Icons.transgender,
                title: l10n.gender,
                subtitle: l10n.selectGender,
                child: Container(
                  padding: const EdgeInsetsDirectional.all(4),
                  decoration: BoxDecoration(
                    color: AfiaColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AfiaColors.divider),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => _selectedGender = 'Male'),
                        child: _buildOption(l10n.male, Icons.male, _selectedGender == 'Male'),
                      ),
                      const SizedBox(width: AfiaSpacing.sm),
                      GestureDetector(
                        onTap: () => setState(() => _selectedGender = 'Female'),
                        child: _buildOption(l10n.female, Icons.female, _selectedGender == 'Female'),
                      ),
                    ],
                  ),
                ),
              ),
              _buildSection(
                icon: Icons.monitor_weight,
                title: l10n.weight,
                subtitle: l10n.enterCurrentWeight,
                child: _buildInputRow(
                  controller: _weightController,
                  hint: _isWeightKg ? 'e.g., 70' : 'e.g., 154',
                  unit: _weightUnit,
                  icon: Icons.monitor_weight,
                  onUnitTap: _toggleWeightUnit,
                ),
              ),
              _buildSection(
                icon: Icons.straighten,
                title: l10n.height,
                subtitle: l10n.enterHeight,
                child: _buildInputRow(
                  controller: _heightController,
                  hint: _isHeightCm ? 'e.g., 175' : 'e.g., 5.9',
                  unit: _heightUnit,
                  icon: Icons.straighten,
                  onUnitTap: _toggleHeightUnit,
                ),
              ),
              const SizedBox(height: AfiaSpacing.lg),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    final weightVal = double.tryParse(_weightController.text.trim());
                    final heightVal = double.tryParse(_heightController.text.trim());
                    if (weightVal == null || heightVal == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.enterValidWeightHeight)),
                      );
                      return;
                    }

                    // Convert weight to kg and height to cm if they were entered in imperial units
                    final weightKg = _isWeightKg ? weightVal : weightVal / 2.20462;
                    final heightCm = _isHeightCm ? heightVal : heightVal * 30.48;

                    Navigator.of(context).pushNamed(
                      RouteNames.authGoalSelection,
                      arguments: {
                        'gender': _selectedGender.toLowerCase(),
                        'weightKg': weightKg,
                        'heightCm': heightCm,
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AfiaColors.primary,
                    foregroundColor: AfiaColors.onPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  ),
                  child: Text(
                    l10n.continueButton,
                    style: AfiaTypography.cardTitle.copyWith(color: AfiaColors.onPrimary),
                  ),
                ),
              ),
              const SizedBox(height: AfiaSpacing.xxxl),
            ],
          ),
        ),
      ),
    );
  }
}
