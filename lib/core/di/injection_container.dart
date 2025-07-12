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
import 'package:uniride_driver/features/home/data/datasources/carpool_service_impl.dart';
import 'package:uniride_driver/features/home/data/datasources/way_point_service_impl.dart';
import 'package:uniride_driver/features/home/data/repositories/carpool_repository_impl.dart';
import 'package:uniride_driver/features/home/data/repositories/route_repository_impl.dart';
import 'package:uniride_driver/features/home/domain/repositories/carpool_repository.dart';
import 'package:uniride_driver/features/home/domain/repositories/route_carpool_repository.dart';
import 'package:uniride_driver/features/home/domain/repositories/route_repository.dart';
import 'package:uniride_driver/features/home/domain/repositories/way_point_repository.dart';
import 'package:uniride_driver/features/home/domain/services/carpool_service.dart';
import 'package:uniride_driver/features/home/domain/services/route_service.dart';
import 'package:uniride_driver/features/home/domain/services/way_point_service.dart';
import 'package:uniride_driver/features/home/presentation/bloc/carpool/create_carpool_bloc.dart';
import 'package:uniride_driver/features/home/presentation/bloc/carpool/waiting_carpool_bloc.dart';
import 'package:uniride_driver/features/profile/presentantion/bloc/register_profile_bloc.dart';

import '../../features/communication/data/datasources/in_trip_communication_service_impl.dart';
import '../../features/communication/data/repositories/in_trip_communication_repository_impl.dart';
import '../../features/communication/domain/repositories/in_trip_communication_repository.dart';
import '../../features/communication/domain/services/in_trip_communication_service.dart';
import '../../features/communication/presentation/bloc/chat_bloc.dart';
import '../../features/file/data/datasources/file_management_service_impl.dart';
import '../../features/file/data/repositories/file_management_repository_impl.dart';
import '../../features/file/domain/repositories/file_management_repository.dart';
import '../../features/file/domain/services/file_management_service.dart';
import '../../features/home/data/datasources/location_service.dart';
import '../../features/home/data/datasources/passenger_request_service_impl.dart';
import '../../features/home/data/datasources/route_carpool_repository_impl.dart';
import '../../features/home/data/datasources/route_carpool_service_impl.dart';
import '../../features/home/data/datasources/route_service_impl.dart';
import '../../features/home/data/datasources/way_point_repository_impl.dart';
import '../../features/home/data/repositories/location_repository.dart';
import '../../features/home/data/repositories/passenger_request_repository_impl.dart';
import '../../features/home/domain/repositories/passenger_request_repository.dart';
import '../../features/home/domain/services/passenger_request_service.dart';
import '../../features/home/domain/services/route_carpool_service.dart';
import '../../features/home/presentation/bloc/carpool/on_going_carpool_bloc.dart';
import '../../features/home/presentation/bloc/home/home_bloc.dart';
import '../../features/home/presentation/bloc/map/map_bloc.dart';
import '../../features/home/presentation/bloc/menu/drawer_menu_bloc.dart';
import '../../features/home/presentation/bloc/passenger-request/passenger_request_bloc.dart';
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

  //! Features - Carpool
  // Repositories
  sl.registerLazySingleton<CarpoolRepository>(
        () => CarpoolRepositoryImpl(carpoolService: sl()),
  );

  // Services
  sl.registerLazySingleton<CarpoolService>(
        () => CarpoolServiceImpl(
      client: sl(),
      baseUrl: '${ApiConstants.baseUrl}${ApiConstants.routingMatchingServiceName}',
    ),
  );

  sl.registerFactory<CreateCarpoolBloc>(
        () => CreateCarpoolBloc(
      carpoolRepository: sl<CarpoolRepository>(),
      userRepository: sl<UserRepository>(),
      profileClassScheduleRepository: sl<ProfileClassScheduleRepository>(),
      locationRepository: sl<LocationRepository>(),
    ),
  );

  sl.registerFactory<WaitingCarpoolBloc>(
      () => WaitingCarpoolBloc(
        carpoolRepository: sl<CarpoolRepository>(),
        routeRepository: sl<RouteRepository>(),
        routeCarpoolRepository: sl<RouteCarpoolRepository>(),
        wayPointRepository: sl<WayPointRepository>(),
      )
  );

  sl.registerFactory<OnGoingCarpoolBloc>(
      () => OnGoingCarpoolBloc(
        carpoolRepository: sl<CarpoolRepository>(),
        routeRepository: sl<RouteRepository>(),
        routeCarpoolRepository: sl<RouteCarpoolRepository>(),
      )
  );

  //! Features - Passenger Request
  // Repositories
  sl.registerLazySingleton<PassengerRequestRepository>(
      () => PassengerRequestRepositoryImpl(passengerRequestService: sl())
  );

  // Services
  sl.registerLazySingleton<PassengerRequestService>(
      () => PassengerRequestServiceImpl(
        client: sl(),
        baseUrl: '${ApiConstants.baseUrl}${ApiConstants.routingMatchingServiceName}',
      )
  );

  sl.registerFactory<PassengerRequestBloc>(
      () => PassengerRequestBloc(
        passengerRequestRepository: sl<PassengerRequestRepository>(),
      )
  );
  
  //! Features - Routes
  sl.registerLazySingleton<RouteRepository>(
      () => RouteRepositoryImpl(routeService: sl())
  );

  sl.registerLazySingleton<RouteService>(
      () => RouteServiceImpl(
        client: sl(),
        baseUrl: '${ApiConstants.baseUrl}${ApiConstants.routingMatchingServiceName}',
      )
  );

  //! Features - Route Carpool
  sl.registerLazySingleton<RouteCarpoolRepository>(
      () => RouteCarpoolRepositoryImpl(routeCarpoolService: sl())
  );

  sl.registerLazySingleton<RouteCarpoolService>(
      () => RouteCarpoolServiceImpl(
        client: sl(),
        baseUrl: '${ApiConstants.baseUrl}${ApiConstants.routingMatchingServiceName}',
      )
  );

  //! Features - Waypoints
  sl.registerLazySingleton<WayPointRepository>(
      () => WayPointRepositoryImpl(wayPointService: sl())
  );

  sl.registerLazySingleton<WayPointService>(
      () => WayPointServiceImpl(
        client: sl(),
        baseUrl: '${ApiConstants.baseUrl}${ApiConstants.routingMatchingServiceName}',
      )
  );

  //! Features - In-Trip Communication
  sl.registerLazySingleton<InTripCommunicationService>(
        () => InTripCommunicationServiceImpl(
      client: sl(),
      baseUrl: '${ApiConstants.baseUrl}${ApiConstants.inTripCommunicationServiceName}',
    ),
  );

  sl.registerLazySingleton<InTripCommunicationRepository>(
        () => InTripCommunicationRepositoryImpl(
      inTripCommunicationService: sl(),
    ),
  );

  sl.registerFactory<ChatBloc>(
        () => ChatBloc(
      repository: sl(),
      userRepository: sl(),
    ),
  );

  //! Bloc - Home Page
  sl.registerFactory<HomePageBloc>(
          () => HomePageBloc(
            userRepository: sl<UserRepository>(),
            carpoolRepository: sl<CarpoolRepository>(),
          )
  );

  //! Bloc - Drawer Menu
  sl.registerFactory<DrawerMenuBloc>(
      () => DrawerMenuBloc(
        userRepository: sl<UserRepository>(),
        profileRepository: sl<ProfileRepository>(),
      )
  );

  //! Bloc - Map
  sl.registerFactory<MapBloc>(() => MapBloc());

  //! Core - Already registered in existing init()
  if (!sl.isRegistered<http.Client>()) {
    sl.registerLazySingleton(() => http.Client());
  }
}