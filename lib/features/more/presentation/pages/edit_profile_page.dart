import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Sara Khan');
  final _ageController = TextEditingController(text: '28');
  final _weightController = TextEditingController(text: '62.4');
  final _heightController = TextEditingController(text: '165');

  String _selectedGender = 'Female';
  final List<String> _allergies = [];

  final List<String> _genderOptions = ['Male', 'Female', 'Prefer not to say'];
  final List<String> _allergyOptions = [
    'Gluten',
    'Dairy',
    'Nuts',
    'Eggs',
    'Soy',
    'Seafood',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AfiaColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Edit Profile', style: AfiaTypography.screenTitle),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AfiaSpacing.pageMargin,
            AfiaSpacing.xl,
            AfiaSpacing.pageMargin,
            AfiaSpacing.xxxl,
          ),
          children: [
            _buildSectionTitle('Personal Information'),
            const SizedBox(height: AfiaSpacing.md),
            _buildCard([
              _buildTextField(
                controller: _nameController,
                label: 'Name',
                icon: Icons.person_outline,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter your name' : null,
              ),
              const _CardDivider(),
              _buildTextField(
                controller: _ageController,
                label: 'Age',
                icon: Icons.numbers_outlined,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your age';
                  }
                  final age = int.tryParse(value);
                  if (age == null || age < 1 || age > 150) {
                    return 'Invalid age';
                  }
                  return null;
                },
              ),
              const _CardDivider(),
              _buildTextField(
                controller: _weightController,
                label: 'Weight',
                icon: Icons.monitor_weight_outlined,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                suffixText: 'kg',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your weight';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Invalid weight';
                  }
                  return null;
                },
              ),
              const _CardDivider(),
              _buildTextField(
                controller: _heightController,
                label: 'Height',
                icon: Icons.straighten_rounded,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                suffixText: 'cm',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your height';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Invalid height';
                  }
                  return null;
                },
              ),
            ]),
            const SizedBox(height: AfiaSpacing.xl),
            _buildSectionTitle('Gender'),
            const SizedBox(height: AfiaSpacing.md),
            RadioGroup<String>(
              groupValue: _selectedGender,
              onChanged: (value) =>
                  setState(() => _selectedGender = value ?? _selectedGender),
              child: _buildCard(
                _genderOptions.map((gender) {
                  return Column(
                    children: [
                      if (gender != _genderOptions.first) const _CardDivider(),
                      ListTile(
                        leading: Radio<String>(
                          value: gender,
                          activeColor: AfiaColors.primary,
                        ),
                        title: Text(gender, style: AfiaTypography.cardTitle),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AfiaSpacing.sm,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AfiaSpacing.xl),
            _buildSectionTitle('Allergies'),
            const SizedBox(height: AfiaSpacing.md),
            _buildCard(
              _allergyOptions.map((allergy) {
                final isSelected = _allergies.contains(allergy);
                return Column(
                  children: [
                    if (allergy != _allergyOptions.first) const _CardDivider(),
                    CheckboxListTile(
                      value: isSelected,
                      onChanged: (checked) {
                        setState(() {
                          if (checked == true) {
                            _allergies.add(allergy);
                          } else {
                            _allergies.remove(allergy);
                          }
                        });
                      },
                      title: Text(allergy, style: AfiaTypography.cardTitle),
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
              onPressed: _onSave,
              style: FilledButton.styleFrom(
                backgroundColor: AfiaColors.primary,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              child: Text(
                'Save Changes',
                style: AfiaTypography.cardTitle.copyWith(
                  color: AfiaColors.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AfiaTypography.label.copyWith(color: AfiaColors.textPrimary),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Material(
      color: AfiaColors.surface,
      borderRadius: BorderRadius.circular(24),
      child: Column(children: children),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? suffixText,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AfiaSpacing.lg,
        vertical: AfiaSpacing.sm,
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: AfiaTypography.body,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AfiaTypography.body.copyWith(
            color: AfiaColors.textSecondary,
          ),
          prefixIcon: Icon(icon, color: AfiaColors.textSecondary, size: 20),
          suffixText: suffixText,
          suffixStyle: AfiaTypography.body.copyWith(
            color: AfiaColors.textMuted,
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
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AfiaSpacing.lg,
            vertical: AfiaSpacing.md,
          ),
        ),
      ),
    );
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context);
    }
  }
}

class _CardDivider extends StatelessWidget {
  const _CardDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, thickness: 1, color: AfiaColors.divider);
  }
}
