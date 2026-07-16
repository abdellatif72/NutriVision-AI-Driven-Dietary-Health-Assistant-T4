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

  /// Home tab label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Meals tab label
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get meals;

  /// Chat/AI tab label
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// More tab label
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// Water tab label
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get water;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Language setting
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Change language option
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// App language setting
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguage;

  /// Daily intake label
  ///
  /// In en, this message translates to:
  /// **'Daily Intake'**
  String get dailyIntake;

  /// Steps metric
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get steps;

  /// Hydration metric
  ///
  /// In en, this message translates to:
  /// **'Hydration'**
  String get hydration;

  /// Heart rate metric
  ///
  /// In en, this message translates to:
  /// **'Heart Rate'**
  String get heartRate;

  /// Kilocalories unit
  ///
  /// In en, this message translates to:
  /// **'kcal'**
  String get kcal;

  /// Water tracker section title
  ///
  /// In en, this message translates to:
  /// **'Hydration Tracker'**
  String get waterTracker;

  /// AI assistant title
  ///
  /// In en, this message translates to:
  /// **'Smart Nutrition Assistant'**
  String get aiNutritionAssistant;

  /// AI assistant prompt hint
  ///
  /// In en, this message translates to:
  /// **'Ask me about nutrition, meals, or your health progress'**
  String get askNutrition;

  /// Text input placeholder for AI chat
  ///
  /// In en, this message translates to:
  /// **'Type your question here...'**
  String get typeQuestion;

  /// Theme setting
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// System default theme option
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get themeSystem;

  /// Security section
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// Support section
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// Log out action
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// Change password action
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// Warning when camera not available on web
  ///
  /// In en, this message translates to:
  /// **'Camera is not supported on the browser, the gallery will be opened instead.'**
  String get webCameraWarning;

  /// Onboarding hero text
  ///
  /// In en, this message translates to:
  /// **'Healthy habits,\nsmarter you.'**
  String get healthyHabitsSmarterYou;

  /// Onboarding subtitle
  ///
  /// In en, this message translates to:
  /// **'Nutrition, activity, and AI insights\n— all in one place.'**
  String get onboardSubtitle;

  /// Get started CTA button
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// Login prompt text
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// Login action
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// Login screen title
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get loginTitle;

  /// Login screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Log in to continue your journey.'**
  String get loginSubtitle;

  /// Signup prompt text
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// Sign up action
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Forgot password link
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Email label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Social login divider text
  ///
  /// In en, this message translates to:
  /// **'or continue with'**
  String get orContinueWith;

  /// Google sign in button
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get google;

  /// Apple sign in button
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get apple;

  /// Physical info screen title
  ///
  /// In en, this message translates to:
  /// **'Physical Information'**
  String get physicalInformation;

  /// Goal selection screen title
  ///
  /// In en, this message translates to:
  /// **'Goal Selection'**
  String get goalSelection;

  /// Measurement system setting
  ///
  /// In en, this message translates to:
  /// **'Measurement System'**
  String get measurementSystem;

  /// Metric system option
  ///
  /// In en, this message translates to:
  /// **'Metric (kg, cm)'**
  String get metric;

  /// Imperial system option
  ///
  /// In en, this message translates to:
  /// **'Imperial (lb, in)'**
  String get imperial;

  /// Appearance section
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// Units setting
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get units;

  /// Account section
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// Privacy policy link
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Welcome back greeting
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcomeBack;

  /// Validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter email and password'**
  String get pleaseEnterEmailPassword;

  /// Email not verified error
  ///
  /// In en, this message translates to:
  /// **'Please verify your email first through the link sent. If it is incorrect, please sign up again.'**
  String get emailNotVerifiedError;

  /// Email input hint
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get emailHint;

  /// Password input hint
  ///
  /// In en, this message translates to:
  /// **'• • • • • • • • •'**
  String get passwordHint;

  /// Signup screen title
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get createYourAccount;

  /// Signup screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Let\'s get you started.'**
  String get letsGetStarted;

  /// Full name label
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// Name input hint
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// Validation message
  ///
  /// In en, this message translates to:
  /// **'Please fill out all fields'**
  String get pleaseFillAllFields;

  /// Email verification sent message
  ///
  /// In en, this message translates to:
  /// **'A verification link has been sent to your email. Please click it to activate your account.'**
  String get emailVerificationSent;

  /// Email auto-correction suggestion
  ///
  /// In en, this message translates to:
  /// **'Did you mean {suggestion}?'**
  String didYouMean(String suggestion);

  /// Onboarding step indicator
  ///
  /// In en, this message translates to:
  /// **'Step 1 of 2'**
  String get stepOneOfTwo;

  /// Onboarding step indicator
  ///
  /// In en, this message translates to:
  /// **'Step 2 of 2'**
  String get stepTwoOfTwo;

  /// Physical info screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Help us personalize your experience with accurate information.'**
  String get physicalInfoSubtitle;

  /// Gender label
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// Gender selection hint
  ///
  /// In en, this message translates to:
  /// **'Select your gender'**
  String get selectGender;

  /// Male option
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// Female option
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// Weight label
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// Weight input hint
  ///
  /// In en, this message translates to:
  /// **'Enter your current weight'**
  String get enterCurrentWeight;

  /// Height label
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// Height input hint
  ///
  /// In en, this message translates to:
  /// **'Enter your height'**
  String get enterHeight;

  /// Validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter valid weight and height'**
  String get enterValidWeightHeight;

  /// Continue button
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// Goal selection title
  ///
  /// In en, this message translates to:
  /// **'What\'s your goal?'**
  String get whatsYourGoal;

  /// Goal selection subtitle
  ///
  /// In en, this message translates to:
  /// **'We\'ll tailor your plan to what matters most to you.'**
  String get tailorPlan;

  /// Improve nutrition goal
  ///
  /// In en, this message translates to:
  /// **'Improve Nutrition'**
  String get improveNutrition;

  /// Improve nutrition goal description
  ///
  /// In en, this message translates to:
  /// **'Eat healthier every day'**
  String get eatHealthier;

  /// Lose weight goal
  ///
  /// In en, this message translates to:
  /// **'Lose Weight'**
  String get loseWeight;

  /// Lose weight goal description
  ///
  /// In en, this message translates to:
  /// **'Achieve a healthy weight'**
  String get achieveHealthyWeight;

  /// Build muscle goal
  ///
  /// In en, this message translates to:
  /// **'Build Muscle'**
  String get buildMuscle;

  /// Build muscle goal description
  ///
  /// In en, this message translates to:
  /// **'Gain strength and energy'**
  String get gainStrength;

  /// Stay healthy goal
  ///
  /// In en, this message translates to:
  /// **'Stay Healthy'**
  String get stayHealthy;

  /// Stay healthy goal description
  ///
  /// In en, this message translates to:
  /// **'Maintain wellness daily'**
  String get maintainWellness;

  /// Popular badge
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popular;

  /// Multiple goals hint
  ///
  /// In en, this message translates to:
  /// **'You can select multiple goals'**
  String get selectMultipleGoals;

  /// Skip action
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get skipForNow;

  /// Validation message
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

  /// Diet preferences screen title
  ///
  /// In en, this message translates to:
  /// **'Diet Preferences'**
  String get dietPreferences;

  /// Diet style label
  ///
  /// In en, this message translates to:
  /// **'Diet Style'**
  String get dietStyle;

  /// Goal label
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get goal;

  /// Macro split label
  ///
  /// In en, this message translates to:
  /// **'Macronutrient Split'**
  String get macroSplit;

  /// Carbohydrates label
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get carbs;

  /// Protein label
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get protein;

  /// Fat label
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get fat;

  /// Allergies label
  ///
  /// In en, this message translates to:
  /// **'Allergies'**
  String get allergies;

  /// Meals per day setting
  ///
  /// In en, this message translates to:
  /// **'Meals Per Day'**
  String get mealsPerDay;

  /// Water goal setting
  ///
  /// In en, this message translates to:
  /// **'Water Goal'**
  String get waterGoal;

  /// Save preferences action
  ///
  /// In en, this message translates to:
  /// **'Save Preferences'**
  String get savePreferences;

  /// Preferences saved confirmation
  ///
  /// In en, this message translates to:
  /// **'Preferences saved'**
  String get preferencesSaved;

  /// Balanced diet option
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get dietBalanced;

  /// Low carb diet option
  ///
  /// In en, this message translates to:
  /// **'Low Carb'**
  String get dietLowCarb;

  /// Keto diet option
  ///
  /// In en, this message translates to:
  /// **'Keto'**
  String get dietKeto;

  /// Vegan diet option
  ///
  /// In en, this message translates to:
  /// **'Vegan'**
  String get dietVegan;

  /// Mediterranean diet option
  ///
  /// In en, this message translates to:
  /// **'Mediterranean'**
  String get dietMediterranean;

  /// Lose weight goal option
  ///
  /// In en, this message translates to:
  /// **'Lose Weight'**
  String get goalLose;

  /// Maintain weight goal option
  ///
  /// In en, this message translates to:
  /// **'Maintain'**
  String get goalMaintain;

  /// Gain weight goal option
  ///
  /// In en, this message translates to:
  /// **'Gain Weight'**
  String get goalGain;

  /// Gluten allergy
  ///
  /// In en, this message translates to:
  /// **'Gluten'**
  String get allergyGluten;

  /// Dairy allergy
  ///
  /// In en, this message translates to:
  /// **'Dairy'**
  String get allergyDairy;

  /// Nuts allergy
  ///
  /// In en, this message translates to:
  /// **'Nuts'**
  String get allergyNuts;

  /// Eggs allergy
  ///
  /// In en, this message translates to:
  /// **'Eggs'**
  String get allergyEggs;

  /// Soy allergy
  ///
  /// In en, this message translates to:
  /// **'Soy'**
  String get allergySoy;

  /// Seafood allergy
  ///
  /// In en, this message translates to:
  /// **'Seafood'**
  String get allergySeafood;

  /// Progress screen title
  ///
  /// In en, this message translates to:
  /// **'Your progress'**
  String get yourProgress;

  /// Weekly macro average label
  ///
  /// In en, this message translates to:
  /// **'Average macro — last week'**
  String get macroAverageWeek;

  /// Monthly macro average label
  ///
  /// In en, this message translates to:
  /// **'Average macro — last month'**
  String get macroAverageMonth;

  /// Yearly macro average label
  ///
  /// In en, this message translates to:
  /// **'Average macro — last year'**
  String get macroAverageYear;

  /// Weekly period option
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get periodWeekly;

  /// Monthly period option
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get periodMonthly;

  /// Yearly period option
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get periodYearly;

  /// Weekly calories chart caption
  ///
  /// In en, this message translates to:
  /// **'Calories — last week (day by day)'**
  String get caloriesWeekCaption;

  /// Monthly calories chart caption
  ///
  /// In en, this message translates to:
  /// **'Average calories per week — last 4 weeks'**
  String get caloriesMonthCaption;

  /// Yearly calories chart caption
  ///
  /// In en, this message translates to:
  /// **'Approximate daily average per month — last 12 months'**
  String get caloriesYearCaption;

  /// Weekly water chart caption
  ///
  /// In en, this message translates to:
  /// **'Water — last week (day by day)'**
  String get waterWeekCaption;

  /// Monthly water chart caption
  ///
  /// In en, this message translates to:
  /// **'Average water per week — last 4 weeks'**
  String get waterMonthCaption;

  /// Yearly water chart caption
  ///
  /// In en, this message translates to:
  /// **'Daily water average per month — last 12 months'**
  String get waterYearCaption;

  /// Weekly weight trend label
  ///
  /// In en, this message translates to:
  /// **'During the last week'**
  String get weightTrendWeek;

  /// Monthly weight trend label
  ///
  /// In en, this message translates to:
  /// **'During the last month'**
  String get weightTrendMonth;

  /// Yearly weight trend label
  ///
  /// In en, this message translates to:
  /// **'During the last year'**
  String get weightTrendYear;

  /// Weight development title
  ///
  /// In en, this message translates to:
  /// **'Weight development'**
  String get weightDevelopment;

  /// Current password field label
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// New password field label
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// Confirm new password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// Password requirements hint
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters and include a number and a letter.'**
  String get passwordRequirements;

  /// Update password action
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get updatePassword;

  /// Password update success message
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully'**
  String get passwordUpdatedSuccess;

  /// Validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter current password'**
  String get pleaseEnterCurrentPassword;

  /// Passwords mismatch error
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Contact support action
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// Help screen subtitle
  ///
  /// In en, this message translates to:
  /// **'We are here to help you get the most out of Afia.'**
  String get helpSubtitle;

  /// Live chat option
  ///
  /// In en, this message translates to:
  /// **'Live Chat'**
  String get liveChat;

  /// Live chat subtitle
  ///
  /// In en, this message translates to:
  /// **'Average reply in under 2 hours'**
  String get liveChatSubtitle;

  /// Chat support coming soon message
  ///
  /// In en, this message translates to:
  /// **'Chat support coming soon'**
  String get chatSupportComingSoon;

  /// Email us option
  ///
  /// In en, this message translates to:
  /// **'Email Us'**
  String get emailUs;

  /// Email us subtitle
  ///
  /// In en, this message translates to:
  /// **'support@afia.app'**
  String get emailUsSubtitle;

  /// Email support coming soon message
  ///
  /// In en, this message translates to:
  /// **'Email support coming soon'**
  String get emailSupportComingSoon;

  /// Report problem option
  ///
  /// In en, this message translates to:
  /// **'Report a Problem'**
  String get reportProblem;

  /// Report problem subtitle
  ///
  /// In en, this message translates to:
  /// **'Let us know what went wrong'**
  String get reportProblemSubtitle;

  /// Problem reporting coming soon message
  ///
  /// In en, this message translates to:
  /// **'Problem reporting coming soon'**
  String get problemReportingComingSoon;

  /// Send feedback option
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get sendFeedback;

  /// Send feedback subtitle
  ///
  /// In en, this message translates to:
  /// **'Help us improve Afia'**
  String get sendFeedbackSubtitle;

  /// Feedback feature coming soon message
  ///
  /// In en, this message translates to:
  /// **'Feedback feature coming soon'**
  String get feedbackFeatureComingSoon;

  /// About screen title
  ///
  /// In en, this message translates to:
  /// **'About Afia'**
  String get aboutAfia;

  /// App name
  ///
  /// In en, this message translates to:
  /// **'Afia'**
  String get afia;

  /// App version string
  ///
  /// In en, this message translates to:
  /// **'Version {ver}'**
  String version(String ver);

  /// App description
  ///
  /// In en, this message translates to:
  /// **'Afia helps you track your daily nutrition, water intake, and health metrics. Powered by AI, it provides personalized meal recommendations and insights to support your wellness journey.'**
  String get afiaDescription;

  /// Project team section title
  ///
  /// In en, this message translates to:
  /// **'Project Team'**
  String get projectTeam;

  /// Team member name
  ///
  /// In en, this message translates to:
  /// **'Ahmed Abdellatif'**
  String get teamMemberAhmed;

  /// Team member role
  ///
  /// In en, this message translates to:
  /// **'Auth, Database & Storage'**
  String get teamMemberAhmedRole;

  /// Team member name
  ///
  /// In en, this message translates to:
  /// **'Marawan Mahmoud'**
  String get teamMemberMarawan;

  /// Team member role
  ///
  /// In en, this message translates to:
  /// **'UI/UX'**
  String get teamMemberMarawanRole;

  /// Team member name
  ///
  /// In en, this message translates to:
  /// **'Mario Nabil'**
  String get teamMemberMario;

  /// Team member role
  ///
  /// In en, this message translates to:
  /// **'Profile, Onboarding & Home'**
  String get teamMemberMarioRole;

  /// Team member name
  ///
  /// In en, this message translates to:
  /// **'Yusuf Dagash'**
  String get teamMemberYusuf;

  /// Team member role
  ///
  /// In en, this message translates to:
  /// **'Auth, AI'**
  String get teamMemberYusufRole;

  /// Terms of service link
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// Open source licenses link
  ///
  /// In en, this message translates to:
  /// **'Open Source Licenses'**
  String get openSourceLicenses;

  /// Footer text
  ///
  /// In en, this message translates to:
  /// **'Made with ❤️ for better health'**
  String get madeWithHeart;

  /// Help screen title
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// FAQ question 1
  ///
  /// In en, this message translates to:
  /// **'How do I change my calorie goal?'**
  String get faq1Question;

  /// FAQ answer 1
  ///
  /// In en, this message translates to:
  /// **'Go to More > Diet Preferences, then adjust your calorie target and macro split.'**
  String get faq1Answer;

  /// FAQ question 2
  ///
  /// In en, this message translates to:
  /// **'Can I track water reminders?'**
  String get faq2Question;

  /// FAQ answer 2
  ///
  /// In en, this message translates to:
  /// **'Yes. Go to More > Notifications and enable water reminders. You can set the interval between 1-4 hours.'**
  String get faq2Answer;

  /// FAQ question 3
  ///
  /// In en, this message translates to:
  /// **'How do I reset my password?'**
  String get faq3Question;

  /// FAQ answer 3
  ///
  /// In en, this message translates to:
  /// **'Go to More > Change Password. Enter your current password, then your new password twice.'**
  String get faq3Answer;

  /// FAQ question 4
  ///
  /// In en, this message translates to:
  /// **'How is my daily calorie target calculated?'**
  String get faq4Question;

  /// FAQ answer 4
  ///
  /// In en, this message translates to:
  /// **'Your target is based on your age, gender, height, weight, activity level, and selected goal (lose/maintain/gain).'**
  String get faq4Answer;

  /// FAQ question 5
  ///
  /// In en, this message translates to:
  /// **'Can I use Afia offline?'**
  String get faq5Question;

  /// FAQ answer 5
  ///
  /// In en, this message translates to:
  /// **'Basic logging features work offline. Syncing across devices requires an internet connection.'**
  String get faq5Answer;

  /// FAQ question 6
  ///
  /// In en, this message translates to:
  /// **'How do I change my language preference?'**
  String get faq6Question;

  /// FAQ answer 6
  ///
  /// In en, this message translates to:
  /// **'Go to More > Settings > Language to switch between العربية and English.'**
  String get faq6Answer;

  /// FAQ question 7
  ///
  /// In en, this message translates to:
  /// **'Is my data secure?'**
  String get faq7Question;

  /// FAQ answer 7
  ///
  /// In en, this message translates to:
  /// **'Yes. Your health data is encrypted and stored securely. We do not share your personal information with third parties.'**
  String get faq7Answer;

  /// FAQs screen title
  ///
  /// In en, this message translates to:
  /// **'FAQs'**
  String get faqs;

  /// Health goals section
  ///
  /// In en, this message translates to:
  /// **'Health & Goals'**
  String get healthGoals;

  /// Personal info section in More
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfoMoreTitle;

  /// Personal info subtitle in More
  ///
  /// In en, this message translates to:
  /// **'Age, gender, height, weight'**
  String get personalInfoSubtitleMore;

  /// Diet prefs subtitle in More
  ///
  /// In en, this message translates to:
  /// **'Allergies, diet type, macros'**
  String get dietPrefsSubtitleMore;

  /// Progress section
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// Progress subtitle in More
  ///
  /// In en, this message translates to:
  /// **'Weight trends, history, milestones'**
  String get progressSubtitleMore;

  /// Preferences section
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// Notifications section
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Notifications subtitle in More
  ///
  /// In en, this message translates to:
  /// **'Reminders for water, meals, weigh-in'**
  String get notificationsSubtitleMore;

  /// Theme subtitle in More
  ///
  /// In en, this message translates to:
  /// **'Light, Dark, System'**
  String get themeSubtitleMore;

  /// FAQs subtitle in More
  ///
  /// In en, this message translates to:
  /// **'Frequently asked questions'**
  String get faqsSubtitleMore;

  /// Help subtitle in More
  ///
  /// In en, this message translates to:
  /// **'Contact support'**
  String get helpSubtitleMore;

  /// About section
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Logout confirmation title
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get logoutConfirm;

  /// Logout confirmation subtitle
  ///
  /// In en, this message translates to:
  /// **'This will return you to the authentication screen.'**
  String get logoutSubtitle;

  /// Cancel action
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

  /// Initial greeting from AI assistant
  ///
  /// In en, this message translates to:
  /// **'Hello! How can I help you with your diet and meals today?'**
  String get aiChatInitialGreeting;

  /// Title for email verification screen
  ///
  /// In en, this message translates to:
  /// **'Verify Your Email'**
  String get emailVerificationTitle;

  /// Explanation text for email verification
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a verification link to your email. Please check your inbox (and spam folder) to complete your registration.'**
  String get emailVerificationExplanation;

  /// Button text to resend email verification
  ///
  /// In en, this message translates to:
  /// **'Resend Verification Email'**
  String get resendVerificationEmail;

  /// Button text to check verification status
  ///
  /// In en, this message translates to:
  /// **'I\'ve verified my email'**
  String get checkVerificationStatus;

  /// Message shown when verification email is resent
  ///
  /// In en, this message translates to:
  /// **'Verification email sent successfully!'**
  String get verificationEmailResent;

  /// Button text to confirm receipt of verification email and proceed to login
  ///
  /// In en, this message translates to:
  /// **'I confirm I received the email'**
  String get confirmEmailReceived;
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
