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

    // Blocs
    sl.registerFactory(() => AuthBloc(authRepository: sl()));

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

    // Data Sources
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(),
    );
    sl.registerLazySingleton<MoreRemoteDataSource>(
      () => MoreRemoteDataSourceImpl(),
    );
    sl.registerLazySingleton<MoreLocalDataSource>(
      () => MoreLocalDataSourceImpl(sharedPreferences: sl()),
    );
  }
}
