import 'package:afia/features/meals/presentation/pages/meals_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders meals screen summary and meal sections', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: MealsPage()));
    await tester.pumpAndSettle();

    expect(find.text('Meals'), findsWidgets);
    expect(find.text('Today’s meals'), findsOneWidget);
    expect(find.text('Add meal'), findsOneWidget);
    expect(find.text('Breakfast'), findsOneWidget);
  });
}
