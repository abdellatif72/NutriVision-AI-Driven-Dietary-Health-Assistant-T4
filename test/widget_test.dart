import 'package:afia/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders onboard page as initial route', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AfiaApp());

    expect(find.text('Healthy habits,\nsmarter you.'), findsOneWidget);
  });
}
