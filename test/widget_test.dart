import 'package:afia/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders auth feature placeholder as initial route', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AfiaApp());

    expect(find.text('Auth'), findsWidgets);
    expect(
      find.text('Language selection, register, and login screens live here.'),
      findsOneWidget,
    );
  });
}
