
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
import 'package:uniride_driver/features/profile/presentantion/bloc/register_profile_bloc.dart';

import '../../features/file/data/datasources/file_management_service_impl.dart';
import '../../features/file/data/repositories/file_management_repository_impl.dart';
import '../../features/file/domain/repositories/file_management_repository.dart';
import '../../features/file/domain/services/file_management_service.dart';
import '../../features/home/data/datasources/location_service.dart';
import '../../features/home/data/repositories/location_repository.dart';
import '../../features/profile/data/datasource/profile_class_schedule_service_impl.dart';
import '../../features/profile/data/datasource/profile_service_impl.dart';
import '../../features/profile/data/datasource/vehicle_service_impl.dart';
import '../../features/profile/data/repositories/profile_class_schedule_repository_impl.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/data/repositories/vehicle_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_class_schedule_repository.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/repositories/vehicle_repository.dart';
import '../../features/profile/domain/services/profile_class_schedule_service.dart';
import '../../features/profile/domain/services/profile_service.dart';
import '../../features/profile/domain/services/vehicle_service.dart';
import '../database/database_helper.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Core - Database (PRIMERO)
  // ✅ Registrar DatabaseHelper como singleton
  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper.instance);

  //! Features - File Management
  // Repositories
  sl.registerLazySingleton<FileManagementRepository>(
        () => FileManagementRepositoryImpl(fileManagementService: sl()),
  );

  // Data sources
  sl.registerLazySingleton<FileManagementService>(
        () => FileManagementServiceImpl(),
  );

  //! Features - Location
  // Repositories
  sl.registerLazySingleton<LocationRepository>(
        () => LocationRepository(locationService: sl()),
  );

  // Data sources
  sl.registerLazySingleton<LocationService>(
        () => LocationService(),
  );

  //! Features - Vehicle
  // Repositories
  sl.registerLazySingleton<VehicleRepository>(
        () => VehicleRepositoryImpl(vehicleService: sl()),
  );

  // Services
  sl.registerLazySingleton<VehicleService>(
        () => VehicleServiceImpl(
      client: sl(),
      baseUrl: '${ApiConstants.baseUrl}${ApiConstants.profileServiceName}',
    ),
  );

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

  //! Features - Profile
  // Repositories
  sl.registerLazySingleton<ProfileRepository>(
        () => ProfileRepositoryImpl(profileService: sl()),
  );

  sl.registerLazySingleton<ProfileClassScheduleRepository>(
        () => ProfileClassScheduleRepositoryImpl(profileClassScheduleService: sl()),
  );

  // Services
  sl.registerLazySingleton<ProfileService>(
        () => ProfileServiceImpl(
      client: sl(),
      baseUrl: '${ApiConstants.baseUrl}${ApiConstants.profileServiceName}',
    ),
  );

  sl.registerLazySingleton<ProfileClassScheduleService>(
        () => ProfileClassScheduleServiceImpl(
      client: sl(),
      baseUrl: '${ApiConstants.baseUrl}${ApiConstants.profileServiceName}',
    ),
  );

  // Blocs
  sl.registerLazySingleton<RegisterProfileBloc>(
        () => RegisterProfileBloc(
      profileRepository: sl<ProfileRepository>(),
      userRepository: sl<UserRepository>(),
      fileManagementRepository: sl<FileManagementRepository>(),
      locationRepository: sl<LocationRepository>(),
      vehicleRepository: sl<VehicleRepository>(),
    ),
  );

  //! Core - Already registered in existing init()
  if (!sl.isRegistered<http.Client>()) {
    sl.registerLazySingleton(() => http.Client());
  }
}

