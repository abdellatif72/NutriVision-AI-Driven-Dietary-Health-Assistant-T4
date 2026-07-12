import 'package:afia/app/di/injection_container.dart';
import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/features/more/presentation/cubit/profile_form_cubit.dart';
import 'package:afia/features/more/presentation/cubit/profile_form_state.dart';
import 'package:afia/features/more/presentation/widgets/form_card.dart';
import 'package:afia/features/more/presentation/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonalInformationPage extends StatelessWidget {
  const PersonalInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileFormCubit>()..loadProfile(),
      child: const _PersonalInformationView(),
    );
  }
}

class _PersonalInformationView extends StatelessWidget {
  const _PersonalInformationView();

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return Scaffold(
      backgroundColor: AfiaColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(isAr ? 'المعلومات الشخصية' : 'Personal Information', style: AfiaTypography.screenTitle),
        centerTitle: true,
      ),
      body: BlocListener<ProfileFormCubit, ProfileFormState>(
        listener: (context, state) {
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(isAr ? 'تم تحديث الملف الشخصي بنجاح' : 'Profile updated successfully')),
            );
            context.read<ProfileFormCubit>().resetSuccess();
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<ProfileFormCubit, ProfileFormState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AfiaColors.primary,
                  strokeWidth: 2.4,
                ),
              );
            }
            return Form(
              key: GlobalKey<FormState>(),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AfiaSpacing.pageMargin,
                  AfiaSpacing.xl,
                  AfiaSpacing.pageMargin,
                  AfiaSpacing.xxxl,
                ),
                children: [
                  SectionTitle(isAr ? 'المعلومات الشخصية' : 'Personal Information'),
                  const SizedBox(height: AfiaSpacing.md),
                  FormCard(
                    children: [
                      _buildTextField(
                        label: isAr ? 'الاسم' : 'Name',
                        icon: Icons.person_outline,
                        initialValue: state.name,
                        onChanged: (v) =>
                            context.read<ProfileFormCubit>().updateName(v),
                      ),
                      const _FormDivider(),
                      _buildTextField(
                        label: isAr ? 'العمر' : 'Age',
                        icon: Icons.numbers_outlined,
                        initialValue: state.age,
                        keyboardType: TextInputType.number,
                        onChanged: (v) =>
                            context.read<ProfileFormCubit>().updateAge(v),
                      ),
                      const _FormDivider(),
                      _buildTextField(
                        label: isAr ? 'الوزن (كجم)' : 'Weight (kg)',
                        icon: Icons.monitor_weight_outlined,
                        initialValue: state.weightKg,
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: (v) =>
                            context.read<ProfileFormCubit>().updateWeight(v),
                      ),
                      const _FormDivider(),
                      _buildTextField(
                        label: isAr ? 'الطول (سم)' : 'Height (cm)',
                        icon: Icons.straighten_rounded,
                        initialValue: state.heightCm,
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: (v) =>
                            context.read<ProfileFormCubit>().updateHeight(v),
                      ),
                    ],
                  ),
                  const SizedBox(height: AfiaSpacing.xl),
                  SectionTitle(isAr ? 'الجنس' : 'Gender'),
                  const SizedBox(height: AfiaSpacing.md),
                  FormCard(
                    children: [
                      RadioGroup<String>(
                        groupValue: state.gender,
                        onChanged: (v) => context
                            .read<ProfileFormCubit>()
                            .updateGender(v ?? state.gender),
                        child: Column(
                          children: [
                            {'key': 'Female', 'ar': 'أنثى'},
                            {'key': 'Male', 'ar': 'ذكر'},
                            {'key': 'Prefer not to say', 'ar': 'أفضل عدم الإفصاح'},
                          ].map(
                            (genderMap) {
                              final genderKey = genderMap['key']!;
                              final genderLabel = isAr ? genderMap['ar']! : genderKey;
                              return Column(
                                children: [
                                  if (genderKey != 'Female') const _FormDivider(),
                                  ListTile(
                                    leading: Radio<String>(
                                      value: genderKey,
                                      activeColor: AfiaColors.primary,
                                    ),
                                    title: Text(
                                      genderLabel,
                                      style: AfiaTypography.cardTitle,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: AfiaSpacing.sm,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AfiaSpacing.xl),
                  SectionTitle(isAr ? 'الحساسيات الغذائية' : 'Allergies'),
                  const SizedBox(height: AfiaSpacing.md),
                  FormCard(
                    children:
                        [
                          {'key': 'Gluten', 'ar': 'الجلوتين'},
                          {'key': 'Dairy', 'ar': 'منتجات الألبان'},
                          {'key': 'Nuts', 'ar': 'المكسرات'},
                          {'key': 'Eggs', 'ar': 'البيض'},
                          {'key': 'Soy', 'ar': 'الصويا'},
                          {'key': 'Seafood', 'ar': 'المأكولات البحرية'},
                        ].map((allergyMap) {
                          final allergyKey = allergyMap['key']!;
                          final allergyLabel = isAr ? allergyMap['ar']! : allergyKey;
                          final selected = state.allergies.contains(allergyKey);
                          return Column(
                            children: [
                              if (allergyKey != 'Gluten') const _FormDivider(),
                              CheckboxListTile(
                                value: selected,
                                onChanged: (_) => context
                                    .read<ProfileFormCubit>()
                                    .toggleAllergy(allergyKey),
                                title: Text(
                                  allergyLabel,
                                  style: AfiaTypography.cardTitle,
                                ),
                                activeColor: AfiaColors.primary,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: AfiaSpacing.sm,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: AfiaSpacing.xxxl),
                  FilledButton(
                    onPressed: state.isSaving
                        ? null
                        : () => context.read<ProfileFormCubit>().save(),
                    style: FilledButton.styleFrom(
                      backgroundColor: AfiaColors.primary,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    child: state.isSaving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AfiaColors.onPrimary,
                            ),
                          )
                        : Text(
                            isAr ? 'حفظ التغييرات' : 'Save Changes',
                            style: AfiaTypography.cardTitle.copyWith(
                              color: AfiaColors.onPrimary,
                            ),
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required String initialValue,
    required ValueChanged<String> onChanged,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AfiaSpacing.lg,
        vertical: AfiaSpacing.sm,
      ),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: AfiaTypography.body,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AfiaTypography.body.copyWith(
            color: AfiaColors.textSecondary,
          ),
          prefixIcon: Icon(icon, color: AfiaColors.textSecondary, size: 20),
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
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AfiaSpacing.lg,
            vertical: AfiaSpacing.md,
          ),
        ),
      ),
    );
  }
}

class _FormDivider extends StatelessWidget {
  const _FormDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, thickness: 1, color: AfiaColors.divider);
  }
}
