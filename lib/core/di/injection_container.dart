
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:uniride_driver/core/constants/api_constants.dart';
import 'package:uniride_driver/features/auth/data/datasources/auth_service.dart';
import 'package:uniride_driver/features/auth/data/datasources/user_local_service_impl.dart';
import 'package:uniride_driver/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:uniride_driver/features/auth/data/repositories/user_repository_impl.dart';
import 'package:uniride_driver/features/auth/domain/repositories/auth_repository.dart';
import 'package:uniride_driver/features/auth/domain/repositories/user_repository.dart';
import 'package:uniride_driver/features/auth/domain/services/auth_service.dart';
import 'package:uniride_driver/features/auth/domain/services/user_local_service.dart';

import '../database/database_helper.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Core - Database (PRIMERO)
  // ✅ Registrar DatabaseHelper como singleton
  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper.instance);

  //! Features - Auth
  // Repositories
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(authService: sl()),
  );

  sl.registerLazySingleton<UserRepository>(
        () => UserRepositoryImpl(userLocalService: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthService>(
        () => AuthServiceImpl(
      client: sl(),
      baseUrl: '${ApiConstants.baseUrl}${ApiConstants.authServiceName}',
    ),
  );

  sl.registerLazySingleton<UserLocalService>(
        () => UserLocalServiceImpl(databaseHelper: sl()),
  );

  //! Core
  sl.registerLazySingleton(() => http.Client());
}

