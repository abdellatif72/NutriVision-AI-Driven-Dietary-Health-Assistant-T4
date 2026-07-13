import 'package:afia/app/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:afia/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:afia/features/auth/presentation/bloc/auth_event.dart';
import 'package:afia/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FakeAuthBloc extends Bloc<AuthEvent, AuthState> implements AuthBloc {
  FakeAuthBloc() : super(AuthInitial()) {
    on<AuthCheckRequested>((event, emit) {
      emit(AuthUnauthenticated());
    });
  }
}

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    final sharedPreferences = await SharedPreferences.getInstance();
    final sl = GetIt.instance;
    if (!sl.isRegistered<SharedPreferences>()) {
      sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
    }
    if (!sl.isRegistered<AuthBloc>()) {
      sl.registerFactory<AuthBloc>(() => FakeAuthBloc());
    }
  });

  testWidgets('renders onboard page as initial route', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AfiaApp());
    await tester.pumpAndSettle();

    expect(find.text('Healthy habits,\nsmarter you.'), findsOneWidget);
  });
}
