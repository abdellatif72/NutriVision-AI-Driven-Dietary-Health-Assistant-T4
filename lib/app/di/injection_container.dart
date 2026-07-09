import 'package:get_it/get_it.dart';
import 'package:afia/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:afia/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:afia/features/auth/domain/repositories/auth_repository.dart';
import 'package:afia/features/auth/presentation/bloc/auth_bloc.dart';

final GetIt sl = GetIt.instance;

abstract final class InjectionContainer {
  static Future<void> init() async {
    // Blocs
    sl.registerFactory(() => AuthBloc(authRepository: sl()));

    // Repositories
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: sl()),
    );

    // Data Sources
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(),
    );
  }
}
