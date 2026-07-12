import 'package:afia/app/localization/locale_cubit.dart';
import 'package:afia/app/router/route_names.dart';
import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:afia/features/auth/presentation/bloc/auth_event.dart';
import 'package:afia/features/auth/presentation/bloc/auth_state.dart';
import 'package:afia/features/more/presentation/cubit/more_cubit.dart';
import 'package:afia/features/more/presentation/cubit/more_state.dart';
import 'package:afia/features/more/presentation/widgets/more_profile_card.dart';
import 'package:afia/features/more/presentation/widgets/more_section_card.dart';
import 'package:afia/features/more/presentation/widgets/more_tile.dart';
import 'package:afia/features/more/presentation/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final userName = authState is AuthAuthenticated ? (authState.user.name ?? '') : '';
    return BlocProvider(
      create: (_) {
        final cubit = MoreCubit()..loadProfile();
        if (userName.isNotEmpty) cubit.updateName(userName);
        return cubit;
      },
      child: const _MoreView(),
    );
  }
}

class _MoreView extends StatelessWidget {
  const _MoreView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AfiaColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Text(
          Localizations.localeOf(context).languageCode == 'ar' ? 'المزيد' : 'More',
          style: AfiaTypography.screenTitle,
        ),
      ),
      body: BlocBuilder<MoreCubit, MoreState>(
        builder: (context, state) {
          return Builder(
            builder: (ctx) {
              final isAr = Localizations.localeOf(ctx).languageCode == 'ar';
              return ListView(
            padding: EdgeInsets.fromLTRB(
              AfiaSpacing.pageMargin,
              AfiaSpacing.sm,
              AfiaSpacing.pageMargin,
              80.0 + MediaQuery.paddingOf(ctx).bottom,
            ),
            children: [
              MoreProfileCard(
                name: state.name,
                initials: state.initials,
                currentGoal: state.currentGoal,
                streakDays: state.streakDays,
                onTap: () => Navigator.pushNamed(context, RouteNames.profile),
              ),
              const SizedBox(height: AfiaSpacing.xl),
              SectionTitle(isAr ? 'الصحة والأهداف' : 'Health & Goals'),
              const SizedBox(height: AfiaSpacing.md),
              MoreSectionCard(
                children: [
                  MoreTile(
                    icon: Icons.person_outline,
                    title: isAr ? 'المعلومات الشخصية' : 'Personal Information',
                    subtitle: isAr ? 'العمر، الجنس، الطول، الوزن' : 'Age, gender, height, weight',
                    onTap: () => Navigator.pushNamed(context, RouteNames.personalInformation),
                  ),
                  MoreTile(
                    icon: Icons.restaurant_outlined,
                    title: isAr ? 'التفضيلات الغذائية' : 'Diet Preferences',
                    subtitle: isAr ? 'الحساسية، نوع النظام الغذائي' : 'Allergies, diet type, macros',
                    onTap: () => Navigator.pushNamed(context, RouteNames.dietPreferences),
                  ),
                  MoreTile(
                    icon: Icons.bar_chart_outlined,
                    title: isAr ? 'التقدم' : 'Progress',
                    subtitle: isAr ? 'اتجاهات الوزن والتاريخ' : 'Weight trends, history, milestones',
                    onTap: () => Navigator.pushNamed(context, RouteNames.progress),
                  ),
                ],
              ),
              const SizedBox(height: AfiaSpacing.xl),
              SectionTitle(isAr ? 'التفضيلات' : 'Preferences'),
              const SizedBox(height: AfiaSpacing.md),
              MoreSectionCard(
                children: [
                  MoreTile(
                    icon: Icons.notifications_none_rounded,
                    title: isAr ? 'الإشعارات' : 'Notifications',
                    subtitle: isAr ? 'تذكيرات الماء والوجبات والوزن' : 'Reminders for water, meals, weigh-in',
                    onTap: () => Navigator.pushNamed(context, RouteNames.notifications),
                  ),
                  MoreTile(
                    icon: Icons.palette_outlined,
                    title: isAr ? 'المظهر' : 'Theme',
                    subtitle: isAr ? 'فاتح، داكن، النظام' : 'Light, Dark, System',
                    onTap: () => Navigator.pushNamed(context, RouteNames.settings),
                  ),
                  MoreTile(
                    icon: Icons.language_rounded,
                    title: isAr ? 'اللغة' : 'Language',
                    subtitle: 'العربية, English',
                    onTap: () => _showLanguageSheet(context),
                  ),
                ],
              ),
              const SizedBox(height: AfiaSpacing.xl),
              SectionTitle(isAr ? 'الأمان' : 'Security'),
              const SizedBox(height: AfiaSpacing.md),
              MoreSectionCard(
                children: [
                  MoreTile(
                    icon: Icons.lock_outline_rounded,
                    title: isAr ? 'تغيير كلمة المرور' : 'Change Password',
                    onTap: () => Navigator.pushNamed(context, RouteNames.changePassword),
                  ),
                ],
              ),
              const SizedBox(height: AfiaSpacing.xl),
              SectionTitle(isAr ? 'الدعم' : 'Support'),
              const SizedBox(height: AfiaSpacing.md),
              MoreSectionCard(
                children: [
                  MoreTile(
                    icon: Icons.help_outline_rounded,
                    title: isAr ? 'الأسئلة الشائعة' : 'FAQs',
                    subtitle: isAr ? 'الأسئلة المتكررة' : 'Frequently asked questions',
                    onTap: () => Navigator.pushNamed(context, RouteNames.faqs),
                  ),
                  MoreTile(
                    icon: Icons.headset_mic_outlined,
                    title: isAr ? 'المساعدة' : 'Help',
                    subtitle: isAr ? 'تواصل مع الدعم' : 'Contact support',
                    onTap: () => Navigator.pushNamed(context, RouteNames.help),
                  ),
                ],
              ),
              const SizedBox(height: AfiaSpacing.xl),
              SectionTitle(isAr ? 'عن التطبيق' : 'About'),
              const SizedBox(height: AfiaSpacing.md),
              MoreSectionCard(
                children: [
                  MoreTile(
                    icon: Icons.info_outline_rounded,
                    title: isAr ? 'عن عافية' : 'About Afia',
                    subtitle: 'Version 1.0.0',
                    onTap: () => Navigator.pushNamed(context, RouteNames.about),
                  ),
                ],
              ),
              const SizedBox(height: AfiaSpacing.xxxl),
              TextButton.icon(
                onPressed: () => _showLogoutDialog(context),
                icon: const Icon(Icons.logout_rounded),
                label: Text(isAr ? 'تسجيل الخروج' : 'Log Out'),
                style: TextButton.styleFrom(
                  foregroundColor: AfiaColors.red,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AfiaSpacing.sm,
                    vertical: AfiaSpacing.md,
                  ),
                  textStyle: AfiaTypography.cardTitle.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
            },
          );
        },
      ),
    );
  }

  void _showLanguageSheet(BuildContext context) {
    final localeCubit = context.read<LocaleCubit>();
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: AfiaColors.surface,
      builder: (_) {
        return BlocBuilder<LocaleCubit, Locale>(
          bloc: localeCubit,
          builder: (ctx, currentLocale) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 32,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AfiaColors.divider,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('App Language', style: AfiaTypography.screenTitle),
                    const SizedBox(height: 12),
                    ...[
                      ('ar', 'العربية', '🇸🇦'),
                      ('en', 'English', '🇺🇸'),
                    ].map(
                      (entry) => ListTile(
                        leading: Text(entry.$3,
                            style: const TextStyle(fontSize: 24)),
                        title: Text(entry.$2, style: AfiaTypography.cardTitle),
                        trailing: currentLocale.languageCode == entry.$1
                            ? const Icon(Icons.check_circle_rounded,
                                color: AfiaColors.primary)
                            : null,
                        onTap: () {
                          localeCubit.setLocale(entry.$1);
                          Navigator.pop(ctx);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(isAr ? 'تسجيل الخروج؟' : 'Log out?'),
          content: Text(
            isAr
                ? 'سيتم إرجاعك إلى شاشة تسجيل الدخول.'
                : 'This will return you to the authentication screen.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(isAr ? 'إلغاء' : 'Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<AuthBloc>().add(SignOutRequested());
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteNames.auth,
                  (_) => false,
                );
              },
              child: Text(isAr ? 'خروج' : 'Log out'),
            ),
          ],
        );
      },
    );
  }
}
