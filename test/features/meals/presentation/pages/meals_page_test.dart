import 'package:afia/app/di/injection_container.dart';
import 'package:afia/features/meals/data/datasources/meal_remote_datasource.dart';
import 'package:afia/features/more/data/datasources/more_remote_datasource.dart';
import 'package:afia/features/more/domain/entities/diet_preferences.dart';
import 'package:afia/features/meals/presentation/cubit/meals_cubit.dart';
import 'package:afia/features/meals/presentation/pages/meals_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMealRemoteDataSource extends Mock implements MealRemoteDataSource {}
class MockMoreRemoteDataSource extends Mock implements MoreRemoteDataSource {}

void main() {
  setUpAll(() {
    registerFallbackValue(DateTime.now());
  });

  setUp(() {
    sl.reset();
    final mockDataSource = MockMealRemoteDataSource();
    final mockMoreDS = MockMoreRemoteDataSource();

    when(() => mockDataSource.getLoggedMeals(any())).thenAnswer((_) async => const []);
    when(() => mockMoreDS.getDietPreferences()).thenAnswer((_) async => const DietPreferences(calorieTarget: 2000));

    sl.registerLazySingleton<MealRemoteDataSource>(() => mockDataSource);
    sl.registerLazySingleton<MoreRemoteDataSource>(() => mockMoreDS);
    sl.registerFactory(() => MealsCubit(remoteDataSource: sl(), moreDataSource: sl()));
  });

  testWidgets('renders meals screen summary and meal sections', (
    WidgetTester tester,
  ) async {
    // Set a larger viewport to ensure all lazy-loaded ListView items are built
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const MaterialApp(home: MealsPage()));
    await tester.pumpAndSettle();

    // Check default English labels
    expect(find.text('Breakfast'), findsOneWidget);
    expect(find.text('Lunch'), findsOneWidget);
    expect(find.text('Dinner'), findsOneWidget);
    expect(find.text('Snack'), findsOneWidget);
  });
}
