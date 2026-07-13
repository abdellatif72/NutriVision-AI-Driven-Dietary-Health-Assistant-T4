import 'dart:async';
import 'package:afia/app/router/route_names.dart';
import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/features/auth/domain/entities/auth_user.dart';
import 'package:afia/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:afia/features/auth/presentation/bloc/auth_event.dart';
import 'package:afia/features/auth/presentation/bloc/auth_state.dart';
import 'package:afia/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;
  late StreamController<AuthState> stateController;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    stateController = StreamController<AuthState>.broadcast();
    
    // Stub default state and stream to prevent crashes on initialization
    when(() => mockAuthBloc.state).thenReturn(AuthInitial());
    when(() => mockAuthBloc.stream).thenAnswer((_) => stateController.stream);
    when(() => mockAuthBloc.close()).thenAnswer((_) => Future.value());
  });

  tearDown(() {
    stateController.close();
  });

  Widget wrapWithBloc(Widget child, {Map<String, WidgetBuilder>? routes}) {
    return MaterialApp(
      routes: routes ?? {},
      home: BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: child,
      ),
    );
  }

  group('LoginPage Email Verification Tests', () {
    testWidgets('should show beautiful RTL SnackBar in Arabic with correct style when email is not verified', (tester) async {
      await tester.pumpWidget(wrapWithBloc(const LoginPage()));
      await tester.pumpAndSettle();

      // Trigger the unverified email error state
      const unverifiedError = AuthError(
        'برجاء تفعيل بريدك الإلكتروني أولاً من خلال الرابط. إذا كان البريد الإلكتروني غير صحيح، يرجى إنشاء حساب جديد ببريد صحيح.',
      );
      when(() => mockAuthBloc.state).thenReturn(unverifiedError);
      stateController.add(unverifiedError);
      
      await tester.pump(); // Process the stream event
      await tester.pump(); // Build the SnackBar widget in the tree

      // Find the snackbar text
      final snackBarFinder = find.byType(SnackBar);
      expect(snackBarFinder, findsOneWidget);

      final textFinder = find.text(
        'برجاء تفعيل بريدك الإلكتروني أولاً من خلال الرابط. إذا كان البريد الإلكتروني غير صحيح، يرجى إنشاء حساب جديد ببريد صحيح.',
      );
      expect(textFinder, findsOneWidget);

      // Verify the SnackBar uses AfiaColors.redContainer background and text with AfiaColors.red
      final snackBar = tester.widget<SnackBar>(snackBarFinder);
      expect(snackBar.backgroundColor, AfiaColors.redContainer);

      final textWidget = tester.widget<Text>(textFinder);
      expect(textWidget.style?.color, AfiaColors.red);

      // Verify Directionality is RTL
      final directionalityFinder = find.ancestor(
        of: textFinder,
        matching: find.byType(Directionality),
      );
      expect(directionalityFinder, findsAtLeastNWidgets(1));
      final directionality = tester.widget<Directionality>(directionalityFinder.first);
      expect(directionality.textDirection, TextDirection.rtl);
    });

    testWidgets('should navigate to RouteNames.main when authenticated', (tester) async {
      bool navigated = false;
      await tester.pumpWidget(wrapWithBloc(
        const LoginPage(),
        routes: {
          RouteNames.main: (context) {
            navigated = true;
            return const Scaffold(body: Text('Main Page'));
          },
        },
      ));
      await tester.pumpAndSettle();

      // Trigger authenticated state
      const authenticatedState = AuthAuthenticated(
        AuthUser(id: '12345', email: 'test@example.com', name: 'Test User'),
      );
      when(() => mockAuthBloc.state).thenReturn(authenticatedState);
      stateController.add(authenticatedState);
      
      await tester.pumpAndSettle();

      expect(navigated, isTrue);
    });
  });
}
