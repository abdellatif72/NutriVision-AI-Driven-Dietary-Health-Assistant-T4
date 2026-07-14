import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @meals.
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get meals;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @water.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get water;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguage;

  /// No description provided for @dailyIntake.
  ///
  /// In en, this message translates to:
  /// **'Daily Intake'**
  String get dailyIntake;

  /// No description provided for @steps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get steps;

  /// No description provided for @hydration.
  ///
  /// In en, this message translates to:
  /// **'Hydration'**
  String get hydration;

  /// No description provided for @heartRate.
  ///
  /// In en, this message translates to:
  /// **'Heart Rate'**
  String get heartRate;

  /// No description provided for @kcal.
  ///
  /// In en, this message translates to:
  /// **'kcal'**
  String get kcal;

  /// No description provided for @waterTracker.
  ///
  /// In en, this message translates to:
  /// **'Hydration Tracker'**
  String get waterTracker;

  /// No description provided for @aiNutritionAssistant.
  ///
  /// In en, this message translates to:
  /// **'Smart Nutrition Assistant'**
  String get aiNutritionAssistant;

  /// No description provided for @askNutrition.
  ///
  /// In en, this message translates to:
  /// **'Ask me about nutrition, meals, or your health progress'**
  String get askNutrition;

  /// No description provided for @typeQuestion.
  ///
  /// In en, this message translates to:
  /// **'Type your question here...'**
  String get typeQuestion;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get themeSystem;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @webCameraWarning.
  ///
  /// In en, this message translates to:
  /// **'Camera is not supported on the browser, the gallery will be opened instead.'**
  String get webCameraWarning;

  /// No description provided for @healthyHabitsSmarterYou.
  ///
  /// In en, this message translates to:
  /// **'Healthy habits,\nsmarter you.'**
  String get healthyHabitsSmarterYou;

  /// No description provided for @onboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Nutrition, activity, and AI insights\n— all in one place.'**
  String get onboardSubtitle;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to continue your journey.'**
  String get loginSubtitle;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'or continue with'**
  String get orContinueWith;

  /// No description provided for @google.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get google;

  /// No description provided for @apple.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get apple;

  /// No description provided for @physicalInformation.
  ///
  /// In en, this message translates to:
  /// **'Physical Information'**
  String get physicalInformation;

  /// No description provided for @goalSelection.
  ///
  /// In en, this message translates to:
  /// **'Goal Selection'**
  String get goalSelection;

  /// No description provided for @measurementSystem.
  ///
  /// In en, this message translates to:
  /// **'Measurement System'**
  String get measurementSystem;

  /// No description provided for @metric.
  ///
  /// In en, this message translates to:
  /// **'Metric (kg, cm)'**
  String get metric;

  /// No description provided for @imperial.
  ///
  /// In en, this message translates to:
  /// **'Imperial (lb, in)'**
  String get imperial;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @units.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get units;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcomeBack;

  /// No description provided for @pleaseEnterEmailPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter email and password'**
  String get pleaseEnterEmailPassword;

  /// No description provided for @emailNotVerifiedError.
  ///
  /// In en, this message translates to:
  /// **'Please verify your email first through the link sent. If it is incorrect, please sign up again.'**
  String get emailNotVerifiedError;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get emailHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'• • • • • • • • •'**
  String get passwordHint;

  /// No description provided for @createYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get createYourAccount;

  /// No description provided for @letsGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Let\'s get you started.'**
  String get letsGetStarted;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @pleaseFillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill out all fields'**
  String get pleaseFillAllFields;

  /// No description provided for @emailVerificationSent.
  ///
  /// In en, this message translates to:
  /// **'A verification link has been sent to your email. Please click it to activate your account.'**
  String get emailVerificationSent;

  /// Email auto-correction suggestion
  ///
  /// In en, this message translates to:
  /// **'Did you mean {suggestion}?'**
  String didYouMean(String suggestion);

  /// No description provided for @stepOneOfTwo.
  ///
  /// In en, this message translates to:
  /// **'Step 1 of 2'**
  String get stepOneOfTwo;

  /// No description provided for @stepTwoOfTwo.
  ///
  /// In en, this message translates to:
  /// **'Step 2 of 2'**
  String get stepTwoOfTwo;

  /// No description provided for @physicalInfoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Help us personalize your experience with accurate information.'**
  String get physicalInfoSubtitle;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @selectGender.
  ///
  /// In en, this message translates to:
  /// **'Select your gender'**
  String get selectGender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @enterCurrentWeight.
  ///
  /// In en, this message translates to:
  /// **'Enter your current weight'**
  String get enterCurrentWeight;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @enterHeight.
  ///
  /// In en, this message translates to:
  /// **'Enter your height'**
  String get enterHeight;

  /// No description provided for @enterValidWeightHeight.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid weight and height'**
  String get enterValidWeightHeight;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @whatsYourGoal.
  ///
  /// In en, this message translates to:
  /// **'What\'s your goal?'**
  String get whatsYourGoal;

  /// No description provided for @tailorPlan.
  ///
  /// In en, this message translates to:
  /// **'We\'ll tailor your plan to what matters most to you.'**
  String get tailorPlan;

  /// No description provided for @improveNutrition.
  ///
  /// In en, this message translates to:
  /// **'Improve Nutrition'**
  String get improveNutrition;

  /// No description provided for @eatHealthier.
  ///
  /// In en, this message translates to:
  /// **'Eat healthier every day'**
  String get eatHealthier;

  /// No description provided for @loseWeight.
  ///
  /// In en, this message translates to:
  /// **'Lose Weight'**
  String get loseWeight;

  /// No description provided for @achieveHealthyWeight.
  ///
  /// In en, this message translates to:
  /// **'Achieve a healthy weight'**
  String get achieveHealthyWeight;

  /// No description provided for @buildMuscle.
  ///
  /// In en, this message translates to:
  /// **'Build Muscle'**
  String get buildMuscle;

  /// No description provided for @gainStrength.
  ///
  /// In en, this message translates to:
  /// **'Gain strength and energy'**
  String get gainStrength;

  /// No description provided for @stayHealthy.
  ///
  /// In en, this message translates to:
  /// **'Stay Healthy'**
  String get stayHealthy;

  /// No description provided for @maintainWellness.
  ///
  /// In en, this message translates to:
  /// **'Maintain wellness daily'**
  String get maintainWellness;

  /// No description provided for @popular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popular;

  /// No description provided for @selectMultipleGoals.
  ///
  /// In en, this message translates to:
  /// **'You can select multiple goals'**
  String get selectMultipleGoals;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get skipForNow;

  /// No description provided for @pleaseSelectGoal.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one goal'**
  String get pleaseSelectGoal;

  /// Error occurred while saving onboarding profile data
  ///
  /// In en, this message translates to:
  /// **'Error saving profile: {error}'**
  String errorSavingProfile(String error);

  /// Greeting with user name
  ///
  /// In en, this message translates to:
  /// **'Hi, {userName}'**
  String greetingUser(String userName);

  /// No description provided for @dietPreferences.
  ///
  /// In en, this message translates to:
  /// **'Diet Preferences'**
  String get dietPreferences;

  /// No description provided for @dietStyle.
  ///
  /// In en, this message translates to:
  /// **'Diet Style'**
  String get dietStyle;

  /// No description provided for @goal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get goal;

  /// No description provided for @macroSplit.
  ///
  /// In en, this message translates to:
  /// **'Macronutrient Split'**
  String get macroSplit;

  /// No description provided for @carbs.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get carbs;

  /// No description provided for @protein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get protein;

  /// No description provided for @fat.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get fat;

  /// No description provided for @allergies.
  ///
  /// In en, this message translates to:
  /// **'Allergies'**
  String get allergies;

  /// No description provided for @mealsPerDay.
  ///
  /// In en, this message translates to:
  /// **'Meals Per Day'**
  String get mealsPerDay;

  /// No description provided for @waterGoal.
  ///
  /// In en, this message translates to:
  /// **'Water Goal'**
  String get waterGoal;

  /// No description provided for @savePreferences.
  ///
  /// In en, this message translates to:
  /// **'Save Preferences'**
  String get savePreferences;

  /// No description provided for @preferencesSaved.
  ///
  /// In en, this message translates to:
  /// **'Preferences saved'**
  String get preferencesSaved;

  /// No description provided for @dietBalanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get dietBalanced;

  /// No description provided for @dietLowCarb.
  ///
  /// In en, this message translates to:
  /// **'Low Carb'**
  String get dietLowCarb;

  /// No description provided for @dietKeto.
  ///
  /// In en, this message translates to:
  /// **'Keto'**
  String get dietKeto;

  /// No description provided for @dietVegan.
  ///
  /// In en, this message translates to:
  /// **'Vegan'**
  String get dietVegan;

  /// No description provided for @dietMediterranean.
  ///
  /// In en, this message translates to:
  /// **'Mediterranean'**
  String get dietMediterranean;

  /// No description provided for @goalLose.
  ///
  /// In en, this message translates to:
  /// **'Lose Weight'**
  String get goalLose;

  /// No description provided for @goalMaintain.
  ///
  /// In en, this message translates to:
  /// **'Maintain'**
  String get goalMaintain;

  /// No description provided for @goalGain.
  ///
  /// In en, this message translates to:
  /// **'Gain Weight'**
  String get goalGain;

  /// No description provided for @allergyGluten.
  ///
  /// In en, this message translates to:
  /// **'Gluten'**
  String get allergyGluten;

  /// No description provided for @allergyDairy.
  ///
  /// In en, this message translates to:
  /// **'Dairy'**
  String get allergyDairy;

  /// No description provided for @allergyNuts.
  ///
  /// In en, this message translates to:
  /// **'Nuts'**
  String get allergyNuts;

  /// No description provided for @allergyEggs.
  ///
  /// In en, this message translates to:
  /// **'Eggs'**
  String get allergyEggs;

  /// No description provided for @allergySoy.
  ///
  /// In en, this message translates to:
  /// **'Soy'**
  String get allergySoy;

  /// No description provided for @allergySeafood.
  ///
  /// In en, this message translates to:
  /// **'Seafood'**
  String get allergySeafood;

  /// No description provided for @yourProgress.
  ///
  /// In en, this message translates to:
  /// **'Your progress'**
  String get yourProgress;

  /// No description provided for @macroAverageWeek.
  ///
  /// In en, this message translates to:
  /// **'Average macro — last week'**
  String get macroAverageWeek;

  /// No description provided for @macroAverageMonth.
  ///
  /// In en, this message translates to:
  /// **'Average macro — last month'**
  String get macroAverageMonth;

  /// No description provided for @macroAverageYear.
  ///
  /// In en, this message translates to:
  /// **'Average macro — last year'**
  String get macroAverageYear;

  /// No description provided for @periodWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get periodWeekly;

  /// No description provided for @periodMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get periodMonthly;

  /// No description provided for @periodYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get periodYearly;

  /// No description provided for @caloriesWeekCaption.
  ///
  /// In en, this message translates to:
  /// **'Calories — last week (day by day)'**
  String get caloriesWeekCaption;

  /// No description provided for @caloriesMonthCaption.
  ///
  /// In en, this message translates to:
  /// **'Average calories per week — last 4 weeks'**
  String get caloriesMonthCaption;

  /// No description provided for @caloriesYearCaption.
  ///
  /// In en, this message translates to:
  /// **'Approximate daily average per month — last 12 months'**
  String get caloriesYearCaption;

  /// No description provided for @waterWeekCaption.
  ///
  /// In en, this message translates to:
  /// **'Water — last week (day by day)'**
  String get waterWeekCaption;

  /// No description provided for @waterMonthCaption.
  ///
  /// In en, this message translates to:
  /// **'Average water per week — last 4 weeks'**
  String get waterMonthCaption;

  /// No description provided for @waterYearCaption.
  ///
  /// In en, this message translates to:
  /// **'Daily water average per month — last 12 months'**
  String get waterYearCaption;

  /// No description provided for @weightTrendWeek.
  ///
  /// In en, this message translates to:
  /// **'During the last week'**
  String get weightTrendWeek;

  /// No description provided for @weightTrendMonth.
  ///
  /// In en, this message translates to:
  /// **'During the last month'**
  String get weightTrendMonth;

  /// No description provided for @weightTrendYear.
  ///
  /// In en, this message translates to:
  /// **'During the last year'**
  String get weightTrendYear;

  /// No description provided for @weightDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Weight development'**
  String get weightDevelopment;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// No description provided for @passwordRequirements.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters and include a number and a letter.'**
  String get passwordRequirements;

  /// No description provided for @updatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get updatePassword;

  /// No description provided for @passwordUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully'**
  String get passwordUpdatedSuccess;

  /// No description provided for @pleaseEnterCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter current password'**
  String get pleaseEnterCurrentPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @helpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We are here to help you get the most out of Afia.'**
  String get helpSubtitle;

  /// No description provided for @liveChat.
  ///
  /// In en, this message translates to:
  /// **'Live Chat'**
  String get liveChat;

  /// No description provided for @liveChatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Average reply in under 2 hours'**
  String get liveChatSubtitle;

  /// No description provided for @chatSupportComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Chat support coming soon'**
  String get chatSupportComingSoon;

  /// No description provided for @emailUs.
  ///
  /// In en, this message translates to:
  /// **'Email Us'**
  String get emailUs;

  /// No description provided for @emailUsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'support@afia.app'**
  String get emailUsSubtitle;

  /// No description provided for @emailSupportComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Email support coming soon'**
  String get emailSupportComingSoon;

  /// No description provided for @reportProblem.
  ///
  /// In en, this message translates to:
  /// **'Report a Problem'**
  String get reportProblem;

  /// No description provided for @reportProblemSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Let us know what went wrong'**
  String get reportProblemSubtitle;

  /// No description provided for @problemReportingComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Problem reporting coming soon'**
  String get problemReportingComingSoon;

  /// No description provided for @sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get sendFeedback;

  /// No description provided for @sendFeedbackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Help us improve Afia'**
  String get sendFeedbackSubtitle;

  /// No description provided for @feedbackFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Feedback feature coming soon'**
  String get feedbackFeatureComingSoon;

  /// No description provided for @aboutAfia.
  ///
  /// In en, this message translates to:
  /// **'About Afia'**
  String get aboutAfia;

  /// No description provided for @afia.
  ///
  /// In en, this message translates to:
  /// **'Afia'**
  String get afia;

  /// App version string
  ///
  /// In en, this message translates to:
  /// **'Version {ver}'**
  String version(String ver);

  /// No description provided for @afiaDescription.
  ///
  /// In en, this message translates to:
  /// **'Afia helps you track your daily nutrition, water intake, and health metrics. Powered by AI, it provides personalized meal recommendations and insights to support your wellness journey.'**
  String get afiaDescription;

  /// No description provided for @projectTeam.
  ///
  /// In en, this message translates to:
  /// **'Project Team'**
  String get projectTeam;

  /// No description provided for @teamMemberAhmed.
  ///
  /// In en, this message translates to:
  /// **'Ahmed Abdellatif'**
  String get teamMemberAhmed;

  /// No description provided for @teamMemberAhmedRole.
  ///
  /// In en, this message translates to:
  /// **'Auth, Backend & Meals'**
  String get teamMemberAhmedRole;

  /// No description provided for @teamMemberMarawan.
  ///
  /// In en, this message translates to:
  /// **'Marawan Mahmoud'**
  String get teamMemberMarawan;

  /// No description provided for @teamMemberMarawanRole.
  ///
  /// In en, this message translates to:
  /// **'UI/UX'**
  String get teamMemberMarawanRole;

  /// No description provided for @teamMemberMario.
  ///
  /// In en, this message translates to:
  /// **'Mario Nabil'**
  String get teamMemberMario;

  /// No description provided for @teamMemberMarioRole.
  ///
  /// In en, this message translates to:
  /// **'Profile, Onboarding & Home'**
  String get teamMemberMarioRole;

  /// No description provided for @teamMemberYusuf.
  ///
  /// In en, this message translates to:
  /// **'Yusuf Dagash'**
  String get teamMemberYusuf;

  /// No description provided for @teamMemberYusufRole.
  ///
  /// In en, this message translates to:
  /// **'Auth, AI'**
  String get teamMemberYusufRole;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @openSourceLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open Source Licenses'**
  String get openSourceLicenses;

  /// No description provided for @madeWithHeart.
  ///
  /// In en, this message translates to:
  /// **'Made with ❤️ for better health'**
  String get madeWithHeart;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @faq1Question.
  ///
  /// In en, this message translates to:
  /// **'How do I change my calorie goal?'**
  String get faq1Question;

  /// No description provided for @faq1Answer.
  ///
  /// In en, this message translates to:
  /// **'Go to More > Diet Preferences, then adjust your calorie target and macro split.'**
  String get faq1Answer;

  /// No description provided for @faq2Question.
  ///
  /// In en, this message translates to:
  /// **'Can I track water reminders?'**
  String get faq2Question;

  /// No description provided for @faq2Answer.
  ///
  /// In en, this message translates to:
  /// **'Yes. Go to More > Notifications and enable water reminders. You can set the interval between 1-4 hours.'**
  String get faq2Answer;

  /// No description provided for @faq3Question.
  ///
  /// In en, this message translates to:
  /// **'How do I reset my password?'**
  String get faq3Question;

  /// No description provided for @faq3Answer.
  ///
  /// In en, this message translates to:
  /// **'Go to More > Change Password. Enter your current password, then your new password twice.'**
  String get faq3Answer;

  /// No description provided for @faq4Question.
  ///
  /// In en, this message translates to:
  /// **'How is my daily calorie target calculated?'**
  String get faq4Question;

  /// No description provided for @faq4Answer.
  ///
  /// In en, this message translates to:
  /// **'Your target is based on your age, gender, height, weight, activity level, and selected goal (lose/maintain/gain).'**
  String get faq4Answer;

  /// No description provided for @faq5Question.
  ///
  /// In en, this message translates to:
  /// **'Can I use Afia offline?'**
  String get faq5Question;

  /// No description provided for @faq5Answer.
  ///
  /// In en, this message translates to:
  /// **'Basic logging features work offline. Syncing across devices requires an internet connection.'**
  String get faq5Answer;

  /// No description provided for @faq6Question.
  ///
  /// In en, this message translates to:
  /// **'How do I change my language preference?'**
  String get faq6Question;

  /// No description provided for @faq6Answer.
  ///
  /// In en, this message translates to:
  /// **'Go to More > Settings > Language to switch between العربية and English.'**
  String get faq6Answer;

  /// No description provided for @faq7Question.
  ///
  /// In en, this message translates to:
  /// **'Is my data secure?'**
  String get faq7Question;

  /// No description provided for @faq7Answer.
  ///
  /// In en, this message translates to:
  /// **'Yes. Your health data is encrypted and stored securely. We do not share your personal information with third parties.'**
  String get faq7Answer;

  /// No description provided for @faqs.
  ///
  /// In en, this message translates to:
  /// **'FAQs'**
  String get faqs;

  /// No description provided for @healthGoals.
  ///
  /// In en, this message translates to:
  /// **'Health & Goals'**
  String get healthGoals;

  /// No description provided for @personalInfoMoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfoMoreTitle;

  /// No description provided for @personalInfoSubtitleMore.
  ///
  /// In en, this message translates to:
  /// **'Age, gender, height, weight'**
  String get personalInfoSubtitleMore;

  /// No description provided for @dietPrefsSubtitleMore.
  ///
  /// In en, this message translates to:
  /// **'Allergies, diet type, macros'**
  String get dietPrefsSubtitleMore;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @progressSubtitleMore.
  ///
  /// In en, this message translates to:
  /// **'Weight trends, history, milestones'**
  String get progressSubtitleMore;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationsSubtitleMore.
  ///
  /// In en, this message translates to:
  /// **'Reminders for water, meals, weigh-in'**
  String get notificationsSubtitleMore;

  /// No description provided for @themeSubtitleMore.
  ///
  /// In en, this message translates to:
  /// **'Light, Dark, System'**
  String get themeSubtitleMore;

  /// No description provided for @faqsSubtitleMore.
  ///
  /// In en, this message translates to:
  /// **'Frequently asked questions'**
  String get faqsSubtitleMore;

  /// No description provided for @helpSubtitleMore.
  ///
  /// In en, this message translates to:
  /// **'Contact support'**
  String get helpSubtitleMore;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get logoutConfirm;

  /// No description provided for @logoutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This will return you to the authentication screen.'**
  String get logoutSubtitle;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Greeting message from AI assistant when calorie data is available
  ///
  /// In en, this message translates to:
  /// **'Hello {name}! 👋 I am your smart nutrition assistant.\n\nYou have **{remaining} kcal** remaining from your goal today ({consumed} / {goal} kcal).\n\nI can help suggest meals, answer nutrition questions, or analyze your plate. How can I help you?'**
  String aiChatGreetingWithCalories(
    String name,
    String remaining,
    int consumed,
    int goal,
  );

  /// Greeting message from AI assistant when no calorie data is available
  ///
  /// In en, this message translates to:
  /// **'Hello {name}! 👋 I am your smart nutrition assistant.\n\nI can help suggest meals, answer nutrition questions, and track your health progress. How can I help you today?'**
  String aiChatGreetingSimple(String name);

  /// No description provided for @aiChatInitialGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello! How can I help you with your diet and meals today?'**
  String get aiChatInitialGreeting;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
