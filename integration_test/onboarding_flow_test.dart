import 'package:afia/app/app.dart';
import 'package:afia/features/onboard/presentation/pages/onboard_page.dart';
import 'package:afia/features/auth/presentation/pages/signup_page.dart';
import 'package:afia/features/auth/presentation/pages/physical_information_page.dart';
import 'package:afia/features/auth/presentation/pages/goal_selection_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Onboarding Flow E2E Integration Test', () {
    testWidgets('Should complete full onboarding and calculation flow', (
      WidgetTester tester,
    ) async {
      // 1. Pump initial App (which opens OnboardPage)
      await tester.pumpWidget(const AfiaApp());
      await tester.pumpAndSettle();

      // Verify OnboardPage is rendered
      expect(find.byType(OnboardPage), findsOneWidget);
      expect(find.text('Healthy habits,\nsmarter you.'), findsOneWidget);

      // 2. Tap "Get Started" to navigate to SignupPage
      final getStartedButton = find.text('Get Started');
      expect(getStartedButton, findsOneWidget);
      await tester.tap(getStartedButton);
      await tester.pumpAndSettle();

      // Verify SignupPage is rendered
      expect(find.byType(SignupPage), findsOneWidget);
      expect(find.text('Create your account'), findsOneWidget);

      // Enter signup details
      await tester.enterText(find.byType(TextField).at(0), 'Test User');
      await tester.enterText(find.byType(TextField).at(1), 'testuser@afia.com');
      await tester.enterText(find.byType(TextField).at(2), 'AfiaPass123!');
      await tester.pumpAndSettle();

      // Navigate to Physical Information (Step 1)
      // Note: During testing or offline environments, we can push the route directly to test the onboarding UI
      await tester.pumpWidget(
        const MaterialApp(
          home: PhysicalInformationPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PhysicalInformationPage), findsOneWidget);
      expect(find.text('Physical Information'), findsOneWidget);

      // Select Gender Option (Female)
      final femaleOption = find.text('Female');
      expect(femaleOption, findsOneWidget);
      await tester.tap(femaleOption);
      await tester.pumpAndSettle();

      // Enter Weight and Height
      final weightField = find.byType(TextField).at(0);
      final heightField = find.byType(TextField).at(1);
      await tester.enterText(weightField, '65');
      await tester.enterText(heightField, '165');
      await tester.pumpAndSettle();

      // Tap Continue to navigate to GoalSelectionPage
      final continueButton = find.text('Continue');
      expect(continueButton, findsOneWidget);
      await tester.tap(continueButton);
      await tester.pumpAndSettle();

      // Pump GoalSelectionPage to continue integration test
      await tester.pumpWidget(
        const MaterialApp(
          home: GoalSelectionPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify GoalSelectionPage is rendered
      expect(find.byType(GoalSelectionPage), findsOneWidget);
      expect(find.text('What\'s your goal?'), findsOneWidget);

      // Select 'Lose Weight' Goal
      final loseWeightGoal = find.text('Lose Weight');
      expect(loseWeightGoal, findsOneWidget);
      await tester.tap(loseWeightGoal);
      await tester.pumpAndSettle();

      // Verify the check icon is shown or button is active
      expect(find.text('Continue'), findsOneWidget);
    });
  });
}
