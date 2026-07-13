import 'package:afia/core/network/api_client.dart';
import 'package:afia/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:afia/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:afia/features/auth/domain/repositories/auth_repository.dart';
import 'package:afia/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:afia/features/more/data/datasources/more_local_datasource.dart';
import 'package:afia/features/more/data/datasources/more_local_datasource_impl.dart';
import 'package:afia/features/more/data/datasources/more_remote_datasource.dart';
import 'package:afia/features/more/data/datasources/more_remote_datasource_impl.dart';
import 'package:afia/features/more/data/repositories/more_repository_impl.dart';
import 'package:afia/features/more/domain/repositories/more_repository.dart';
import 'package:afia/features/more/domain/usecases/get_more_profile.dart';
import 'package:afia/features/more/domain/usecases/update_user_profile.dart';
import 'package:afia/features/more/domain/usecases/get_diet_preferences.dart';
import 'package:afia/features/more/domain/usecases/update_diet_preferences.dart';
import 'package:afia/features/more/presentation/cubit/profile_form_cubit.dart';
import 'package:afia/features/explore/data/datasources/explore_remote_datasource.dart';
import 'package:afia/features/explore/data/datasources/explore_remote_datasource_impl.dart';
import 'package:afia/features/explore/data/repositories/explore_repository_impl.dart';
import 'package:afia/features/explore/domain/repositories/explore_repository.dart';
import 'package:afia/features/explore/domain/usecases/get_foods.dart';
import 'package:afia/features/explore/domain/usecases/log_food.dart';
import 'package:afia/features/explore/presentation/bloc/explore_bloc.dart';
import 'package:afia/features/meals/data/datasources/meal_remote_datasource.dart';
import 'package:afia/features/meals/presentation/cubit/meals_cubit.dart';
import 'package:afia/core/services/token_swap_service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

abstract final class InjectionContainer {
  static Future<void> init() async {
    // External
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

    // Network Client
    sl.registerLazySingleton<ApiClient>(() => ApiClient());

    // Use Cases
    sl.registerLazySingleton(() => GetMoreProfile(sl()));
    sl.registerLazySingleton(() => UpdateUserProfile(sl()));
    sl.registerLazySingleton(() => GetDietPreferences(sl()));
    sl.registerLazySingleton(() => UpdateDietPreferences(sl()));
    sl.registerLazySingleton(() => GetFoods(sl()));
    sl.registerLazySingleton(() => LogFood(sl()));

    // Blocs / Cubits
    sl.registerFactory(() => AuthBloc(authRepository: sl()));
    sl.registerFactory(() => ExploreBloc(getFoods: sl(), logFood: sl()));
    sl.registerFactory(() => MealsCubit(remoteDataSource: sl()));
    sl.registerFactory(
      () => ProfileFormCubit(
        getMoreProfile: sl(),
        updateUserProfile: sl(),
        getDietPreferences: sl(),
        updateDietPreferences: sl(),
      ),
    );

    // Repositories
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: sl()),
    );
    sl.registerLazySingleton<MoreRepository>(
      () => MoreRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
      ),
    );
    sl.registerLazySingleton<ExploreRepository>(
      () => ExploreRepositoryImpl(remoteDataSource: sl()),
    );

    // Data Sources
    sl.registerLazySingleton<MealRemoteDataSource>(
      () => MealRemoteDataSource(),
    );
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(),
    );
    sl.registerLazySingleton<MoreRemoteDataSource>(
      () => MoreRemoteDataSourceImpl(),
    );
    sl.registerLazySingleton<MoreLocalDataSource>(
      () => MoreLocalDataSourceImpl(sharedPreferences: sl()),
    );
    sl.registerLazySingleton<ExploreRemoteDataSource>(
      () => ExploreRemoteDataSourceImpl(),
    );

    // Services
    sl.registerLazySingleton<TokenSwapService>(() => TokenSwapService());
  }
}
