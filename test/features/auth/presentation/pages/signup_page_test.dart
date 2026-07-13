import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:afia/features/auth/presentation/bloc/auth_event.dart';
import 'package:afia/features/auth/presentation/bloc/auth_state.dart';
import 'package:afia/features/auth/presentation/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAuthBloc extends Bloc<AuthEvent, AuthState> implements AuthBloc {
  final List<AuthEvent> addedEvents = [];

  FakeAuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) {
      addedEvents.add(event);
    });
  }
}

void main() {
  late FakeAuthBloc fakeAuthBloc;

  setUp(() {
    fakeAuthBloc = FakeAuthBloc();
  });

  Widget wrapWithBloc(Widget child) {
    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: fakeAuthBloc,
        child: child,
      ),
    );
  }

  group('SignupPage Validation Tests', () {
    testWidgets('should show error when email format is invalid', (tester) async {
      await tester.pumpWidget(wrapWithBloc(const SignupPage()));
      await tester.pumpAndSettle();

      // Enter name, invalid email, and strong password
      await tester.enterText(find.byType(TextField).at(0), 'Test User');
      await tester.enterText(find.byType(TextField).at(1), 'invalidemail.com'); // Missing @
      await tester.enterText(find.byType(TextField).at(2), 'StrongPass123!');
      await tester.pumpAndSettle();

      // Tap Sign Up
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Verify validation error is shown
      expect(find.text('يرجى إدخال بريد إلكتروني صحيح يحتوي على @'), findsOneWidget);
      expect(fakeAuthBloc.addedEvents, isEmpty);
    });

    testWidgets('should show error when password is weak (missing special character)', (tester) async {
      await tester.pumpWidget(wrapWithBloc(const SignupPage()));
      await tester.pumpAndSettle();

      // Enter name, valid email, and weak password
      await tester.enterText(find.byType(TextField).at(0), 'Test User');
      await tester.enterText(find.byType(TextField).at(1), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(2), 'WeakPass123'); // Missing special character
      await tester.pumpAndSettle();

      // Tap Sign Up
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Verify specific validation error is shown explaining exactly what is missing
      expect(find.text('كلمة المرور يجب أن تحتوي على رمز خاص'), findsOneWidget);
      expect(fakeAuthBloc.addedEvents, isEmpty);
    });

    testWidgets('should show error when password is weak (missing multiple requirements)', (tester) async {
      await tester.pumpWidget(wrapWithBloc(const SignupPage()));
      await tester.pumpAndSettle();

      // Enter name, valid email, and weak password
      await tester.enterText(find.byType(TextField).at(0), 'Test User');
      await tester.enterText(find.byType(TextField).at(1), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(2), 'weak'); // Missing uppercase, digit, special character
      await tester.pumpAndSettle();

      // Tap Sign Up
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Verify dynamic specific validation error is shown (including min length)
      expect(
        find.text('كلمة المرور يجب أن تتكون من 6 أحرف على الأقل وتحتوي على حرف كبير، رقم، ورمز خاص'),
        findsOneWidget,
      );
      expect(fakeAuthBloc.addedEvents, isEmpty);
    });

    testWidgets('should show error when password lacks length constraint only', (tester) async {
      await tester.pumpWidget(wrapWithBloc(const SignupPage()));
      await tester.pumpAndSettle();

      // Enter name, valid email, and password that satisfies complexity but too short
      await tester.enterText(find.byType(TextField).at(0), 'Test User');
      await tester.enterText(find.byType(TextField).at(1), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(2), 'Ab1!'); // 4 chars but satisfies uppercase, lowercase, digit, special
      await tester.pumpAndSettle();

      // Tap Sign Up
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Verify specific validation error for length constraint
      expect(find.text('كلمة المرور يجب أن تتكون من 6 أحرف على الأقل'), findsOneWidget);
      expect(fakeAuthBloc.addedEvents, isEmpty);
    });

    testWidgets('should show typo suggestion for misspelled email domain and apply it on tap', (tester) async {
      await tester.pumpWidget(wrapWithBloc(const SignupPage()));
      await tester.pumpAndSettle();

      // Enter name, email with typo in domain, and valid password
      await tester.enterText(find.byType(TextField).at(0), 'Test User');
      await tester.enterText(find.byType(TextField).at(1), 'test@gamil.com');
      await tester.enterText(find.byType(TextField).at(2), 'StrongPass123!');
      await tester.pumpAndSettle();

      // Tap Sign Up to trigger suggestion
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Verify typo suggestion is displayed
      expect(find.textContaining('هل تقصد'), findsOneWidget);
      expect(find.textContaining('test@gmail.com'), findsOneWidget);

      // Tap the suggestion
      await tester.tap(find.textContaining('test@gmail.com'));
      await tester.pumpAndSettle();

      // Verify email field is updated
      final emailField = find.byType(TextField).at(1);
      final emailText = (tester.widget(emailField) as TextField).controller?.text;
      expect(emailText, 'test@gmail.com');

      // Tap Sign Up again
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Verify event is dispatched with corrected email
      expect(fakeAuthBloc.addedEvents.length, 1);
      final event = fakeAuthBloc.addedEvents.first as SignUpRequested;
      expect(event.email, 'test@gmail.com');
    });

    testWidgets('should show typo suggestion for missing dot before TLD and apply it on tap', (tester) async {
      await tester.pumpWidget(wrapWithBloc(const SignupPage()));
      await tester.pumpAndSettle();

      // Enter name, email with missing dot, and valid password
      await tester.enterText(find.byType(TextField).at(0), 'Test User');
      await tester.enterText(find.byType(TextField).at(1), 'test@gmailcom');
      await tester.enterText(find.byType(TextField).at(2), 'StrongPass123!');
      await tester.pumpAndSettle();

      // Tap Sign Up to trigger suggestion
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Verify typo suggestion is displayed
      expect(find.textContaining('هل تقصد'), findsOneWidget);
      expect(find.textContaining('test@gmail.com'), findsOneWidget);

      // Tap the suggestion
      await tester.tap(find.textContaining('test@gmail.com'));
      await tester.pumpAndSettle();

      // Verify email field is updated
      final emailField = find.byType(TextField).at(1);
      final emailText = (tester.widget(emailField) as TextField).controller?.text;
      expect(emailText, 'test@gmail.com');

      // Tap Sign Up again
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Verify event is dispatched with corrected email
      expect(fakeAuthBloc.addedEvents.length, 1);
      final event = fakeAuthBloc.addedEvents.first as SignUpRequested;
      expect(event.email, 'test@gmail.com');
    });

    testWidgets('should clear error dynamically when user corrects input', (tester) async {
      await tester.pumpWidget(wrapWithBloc(const SignupPage()));
      await tester.pumpAndSettle();

      // Enter invalid email
      await tester.enterText(find.byType(TextField).at(1), 'invalidemail.com');
      await tester.pumpAndSettle();

      // Tap Sign Up to trigger error
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();
      expect(find.text('يرجى إدخال بريد إلكتروني صحيح يحتوي على @'), findsOneWidget);

      // Correct the email
      await tester.enterText(find.byType(TextField).at(1), 'test@example.com');
      await tester.pumpAndSettle();

      // Verify error is cleared dynamically on-the-fly
      expect(find.text('يرجى إدخال بريد إلكتروني صحيح يحتوي على @'), findsNothing);
    });

    testWidgets('should dispatch SignUpRequested when all fields are valid', (tester) async {
      await tester.pumpWidget(wrapWithBloc(const SignupPage()));
      await tester.pumpAndSettle();

      // Enter valid name, email, and password
      await tester.enterText(find.byType(TextField).at(0), 'Test User');
      await tester.enterText(find.byType(TextField).at(1), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(2), 'StrongPass123!');
      await tester.pumpAndSettle();

      // Tap Sign Up
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Verify that no error is shown and event is dispatched
      expect(find.text('يرجى إدخال بريد إلكتروني صحيح يحتوي على @'), findsNothing);
      expect(find.text('كلمة المرور يجب أن تحتوي على رمز خاص'), findsNothing);
      expect(fakeAuthBloc.addedEvents.length, 1);
      
      final event = fakeAuthBloc.addedEvents.first as SignUpRequested;
      expect(event.name, 'Test User');
      expect(event.email, 'test@example.com');
      expect(event.password, 'StrongPass123!');
    });
  });
}
