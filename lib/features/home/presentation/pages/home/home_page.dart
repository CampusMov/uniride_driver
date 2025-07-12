import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:uniride_driver/features/home/domain/entities/routing-matching/enum_trip_state.dart';
import 'package:uniride_driver/features/home/presentation/bloc/carpool/create_carpool_bloc.dart';
import 'package:uniride_driver/features/home/presentation/bloc/carpool/on_going_carpool_bloc.dart';
import 'package:uniride_driver/features/home/presentation/bloc/home/home_bloc.dart';
import 'package:uniride_driver/features/home/presentation/pages/dialogs/passenger_request_dialog.dart';
import 'package:uniride_driver/features/home/presentation/pages/map/map_page.dart';
import 'package:uniride_driver/features/home/presentation/pages/panels/create_carpool_panel.dart';
import 'package:uniride_driver/features/home/presentation/pages/panels/ongoing_carpool_panel.dart';
import 'package:uniride_driver/features/home/presentation/pages/panels/waiting_carpool_panel.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/di/injection_container.dart' as di;
import '../../../../../core/navigation/screens_routes.dart';
import '../../../../../core/websocket/websocket_manager.dart';
import '../../../../communication/presentation/bloc/chat_bloc.dart';
import '../../bloc/carpool/waiting_carpool_bloc.dart';
import '../../bloc/home/home_state.dart';
import '../../bloc/map/map_bloc.dart';
import '../../bloc/map/map_event.dart';
import '../../bloc/map/map_state.dart';
import '../../bloc/menu/drawer_menu_bloc.dart';
import '../../bloc/menu/drawer_menu_event.dart';
import '../../bloc/menu/drawer_menu_state.dart';
import '../../bloc/passenger-request/passenger_request_bloc.dart';
import '../../bloc/passenger-request/passenger_request_event.dart';
import '../../bloc/passenger-request/passenger_request_state.dart';
import '../dialogs/class_schedule_dialog.dart';
import '../dialogs/origin_location_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PanelController _panelController = PanelController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late CreateCarpoolBloc _createCarpoolBloc;
  late HomePageBloc _homePageBloc;
  late MapBloc _mapBloc;
  late WaitingCarpoolBloc _waitingCarpoolBloc;
  late PassengerRequestBloc _passengerRequestBloc;
  late OnGoingCarpoolBloc _onGoingCarpoolBloc;
  late DrawerMenuBloc _drawerMenuBloc;
  late ChatBloc _chatBloc;

  @override
  void initState() {
    super.initState();
    _createCarpoolBloc = di.sl<CreateCarpoolBloc>();
    _homePageBloc = di.sl<HomePageBloc>();
    _mapBloc = di.sl<MapBloc>();
    _waitingCarpoolBloc = di.sl<WaitingCarpoolBloc>();
    _passengerRequestBloc = di.sl<PassengerRequestBloc>();
    _onGoingCarpoolBloc = di.sl<OnGoingCarpoolBloc>();
    _drawerMenuBloc = di.sl<DrawerMenuBloc>();
    _chatBloc = di.sl<ChatBloc>();

    _drawerMenuBloc.add(const LoadUserProfile());
    _connectWebSocketForCommunication();
  }

  @override
  void dispose() {
    _homePageBloc.close();
    _mapBloc.close();
    _waitingCarpoolBloc.close();
    _createCarpoolBloc.close();
    _passengerRequestBloc.close();
    _onGoingCarpoolBloc.close();
    _drawerMenuBloc.close();
    _chatBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MapBloc>.value(value: _mapBloc),
        BlocProvider<CreateCarpoolBloc>.value(value: _createCarpoolBloc),
        BlocProvider<HomePageBloc>.value(value: _homePageBloc),
        BlocProvider<WaitingCarpoolBloc>.value(value: _waitingCarpoolBloc),
        BlocProvider<PassengerRequestBloc>.value(value: _passengerRequestBloc),
        BlocProvider<OnGoingCarpoolBloc>.value(value: _onGoingCarpoolBloc),
        BlocProvider<DrawerMenuBloc>.value(value: _drawerMenuBloc),
        BlocProvider<ChatBloc>.value(value: _chatBloc),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            key: _scaffoldKey,
            drawer: _buildDrawer(),
            body: MultiBlocListener(
              listeners: [
                BlocListener<DrawerMenuBloc, DrawerMenuState>(
                  listener: (context, state) {
                    if (state.status == DrawerMenuStatus.loggedOut) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        ScreensRoutes.enterVerificationCode,
                            (route) => false,
                      );
                    }
                  },
                ),
              ],
              child: BlocBuilder<HomePageBloc, HomePageState>(
                builder: (context, homeState) {
                  final tripState = homeState.currentTripState;
                  return Stack(
                    children: [
                      _buildSlidingPanel(tripState),
                      _buildMenuButton(),
                      _buildActionButtons(tripState),
                      _buildOriginLocationDialog(tripState),
                      _buildClassScheduleDialog(tripState),
                      _buildPassengerRequestDialog(tripState),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

/*
  * Builds the side drawer menu
  */
  Widget _buildDrawer() {
    return BlocBuilder<DrawerMenuBloc, DrawerMenuState>(
      builder: (context, drawerState) {
        return Drawer(
          backgroundColor: Colors.black,
          child: Column(
            children: [

              _buildDrawerHeader(drawerState),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildDrawerItem(
                      icon: Icons.directions_car,
                      title: 'Mis carpools',
                      subtitle: 'Revisa todos los carpools que has realizado a mayor detalle',
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.access_time,
                      title: 'Mi tiempo',
                      subtitle: 'Revisa el tiempo que has logrado ahorrarte',
                      onTap: () {
                        Navigator.pop(context);
                        // Navegar a mi tiempo
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.warning_outlined,
                      title: 'Incidencias',
                      subtitle: 'Administra y ten cuidado con las faltas que cometes.',
                      onTap: () {
                        Navigator.pop(context);
                        // Navegar a incidencias
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.location_on_outlined,
                      title: 'Ubicaciones guardadas',
                      subtitle: 'Administra tus ubicaciones más recurrentes y favoritas.',
                      onTap: () {
                        Navigator.pop(context);
                        // Navegar a ubicaciones guardadas
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.notifications_outlined,
                      title: 'Notificaciones',
                      subtitle: 'Administra y revisa las notificación de UniRide',
                      onTap: () {
                        Navigator.pop(context);
                        // Navegar a notificaciones
                      },
                    ),
                  ],
                ),
              ),

              // Botón de cerrar sesión
              _buildLogoutButton(drawerState),
            ],
          ),
        );
      },
    );
  }

  /*
  * Builds the drawer header with user information
  */
  Widget _buildDrawerHeader(DrawerMenuState drawerState) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (drawerState.status == DrawerMenuStatus.loading)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          else if (drawerState.status == DrawerMenuStatus.loaded &&
              drawerState.profile != null)
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey,
                  backgroundImage: drawerState.profile!.profilePictureUrl.isNotEmpty
                      ? NetworkImage(drawerState.profile!.profilePictureUrl)
                      : null,
                  child: drawerState.profile!.profilePictureUrl.isEmpty
                      ? const Icon(
                    Icons.person,
                    size: 35,
                    color: Colors.white,
                  )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        drawerState.profile!.firstName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        drawerState.profile!.lastName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '2.6',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
          else if (drawerState.status == DrawerMenuStatus.error)
              Column(
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 50,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Error cargando perfil',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextButton(
                    onPressed: () {
                      context.read<DrawerMenuBloc>().add(const LoadUserProfile());
                    },
                    child: const Text(
                      'Reintentar',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              )
            else
              const Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.person,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cargando...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              // Acción para editar perfil
            },
            child: const Text(
              'Editar mi perfil >',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*
  * Builds the logout button
  */
  Widget _buildLogoutButton(DrawerMenuState drawerState) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ListTile(
        leading: drawerState.status == DrawerMenuStatus.loggingOut
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
          ),
        )
            : const Icon(
          Icons.logout,
          color: Colors.red,
        ),
        title: Text(
          drawerState.status == DrawerMenuStatus.loggingOut
              ? 'Cerrando sesión...'
              : 'Cerrar sesión',
          style: const TextStyle(
            color: Colors.red,
            fontSize: 16,
          ),
        ),
        onTap: drawerState.status == DrawerMenuStatus.loggingOut
            ? null
            : () {
          Navigator.pop(context);
          _showLogoutConfirmationDialog();
        },
      ),
    );
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar cierre de sesión'),
          content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<DrawerMenuBloc>().add(const LogoutUser());
              },
              child: const Text(
                'Cerrar sesión',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  /*
  * Builds a drawer menu item
  */
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  /*
  * Builds the menu button in the top left corner
  */
  Widget _buildMenuButton() {
    return Positioned(
      top: 50,
      left: 16,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              child: const Icon(
                Icons.menu,
                color: Colors.black,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /*
  * Builds the sliding panel that contains the trip information and controls.
   */
  Widget _buildSlidingPanel(TripState currentTripState) {
    return SlidingUpPanel(
      controller: _panelController,
      minHeight: _getMinHeight(currentTripState),
      maxHeight: _getMaxHeight(),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 8,
          offset: const Offset(0, -2),
        ),
      ],
      panel: _buildPanel(currentTripState),
      body: const MapScreen(
        autoGetUserLocation: true,
        showMyLocationButton: false,
      ),
    );
  }

  /*
    * Builds the sliding panel that contains the trip information and controls.
    * The content of the panel changes based on the current trip state.
    *
    * Returns a [Container] with a handle and content based on the trip state.
  * */
  Widget _buildPanel(TripState currentTripState) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          _buildPanelHandle(),
          Expanded(
            child: _buildPanelContent(currentTripState),
          ),
        ],
      ),
    );
  }

  /*
  * Builds the handle for the sliding panel.
  * This is a simple container with a fixed width and height,
   */
  Widget _buildPanelHandle() {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  /*
  * Builds the content of the sliding panel based on the current trip state.
   */
  Widget _buildPanelContent(TripState currentTripState) {
    switch (currentTripState) {
      case TripState.creatingCarpool:
        return Stack(
          children: [
            const CreateCarpoolPanel(),
            const CarpoolCreationResultDialog()
          ],
        );
      case TripState.waitingToStartCarpool:
        return Stack(
          children: [
            const WaitingCarpoolPanel(),
          ],
        );
      case TripState.ongoingCarpool:
        return Stack(
          children: [
            const OnGoingCarpoolPanel(),
          ],
        );
      case TripState.finishedCarpool:
        return Placeholder();
      case TripState.cancelledCarpool:
        return Placeholder();
    }
  }

  /*
  * Builds the floating action buttons (location and passenger requests).
   */
  Widget _buildActionButtons(TripState currentTripState) {
    return Positioned(
      bottom: _getMinHeight(currentTripState) + 20,
      right: 16,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Passenger Request Button (only visible in certain states)
          if (_shouldShowPassengerRequestButton(currentTripState))
            _buildPassengerRequestButton(),

          if (_shouldShowPassengerRequestButton(currentTripState))
            const SizedBox(width: 12), // Spacing between buttons

          // Location Button (always visible)
          _buildLocationButton(),
        ],
      ),
    );
  }

  /*
  * Builds the passenger request floating action button.
   */
  Widget _buildPassengerRequestButton() {
    return BlocBuilder<PassengerRequestBloc, PassengerRequestState>(
      builder: (context, state) {
        return Stack(
          clipBehavior: Clip.none, // Permite que el badge se salga del área
          children: [
            FloatingActionButton(
              onPressed: () {
                context.read<PassengerRequestBloc>().add(const OpenRequestsManagementDialog());
              },
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              heroTag: "passenger_requests",
              child: const Icon(Icons.people),
            ),
            if (state.pendingRequestsCount > 0)
              Positioned(
                right: -8,
                top: -8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Text(
                    '${state.pendingRequestsCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  /*
  * Determines if the passenger request button should be visible based on trip state.
   */
  bool _shouldShowPassengerRequestButton(TripState currentTripState) {
    return currentTripState == TripState.waitingToStartCarpool ||
        currentTripState == TripState.ongoingCarpool;
  }

  /*
  * Builds the floating action button that centers the map on the user's location.
   */
  Widget _buildLocationButton() {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        return FloatingActionButton(
          onPressed: () {
            if (state.userLocation != null) {
              context.read<MapBloc>().add(CenterMap(state.userLocation!));
            } else {
              context.read<MapBloc>().add(GetUserLocation());
            }
          },
          backgroundColor: Colors.white,
          foregroundColor: state.userLocation != null ? Colors.blue : Colors.grey,
          heroTag: "user_location",
          child: state.isLoading
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : Icon(state.userLocation != null
              ? Icons.my_location
              : Icons.location_searching),
        );
      },
    );
  }

  /*
  * Builds the dialog for selecting the origin location when creating a carpool.
   */
  Widget _buildOriginLocationDialog(TripState currentTripState) {
    if (currentTripState != TripState.creatingCarpool) {
      return const SizedBox.shrink();
    }
    return const OriginLocationDialog();
  }

  /*
  * Builds the dialog for selecting the class schedule when creating a carpool.
   */
  Widget _buildClassScheduleDialog(TripState currentTripState) {
    if (currentTripState != TripState.creatingCarpool) {
      return const SizedBox.shrink();
    }
    return const ClassScheduleDialog();
  }

  Widget _buildPassengerRequestDialog(TripState currentTripState) {
    if (currentTripState != TripState.waitingToStartCarpool &&
        currentTripState != TripState.ongoingCarpool) {
      return const SizedBox.shrink();
    }
    return const PassengerRequestDialog();
  }

  /*
  * Returns the minimum height of the sliding panel based on the current trip state.
  * This is used to ensure that the panel has enough space for the content
   */
  double _getMinHeight(TripState currentTripState) {
    switch (currentTripState) {
      case TripState.creatingCarpool:
        return 450;
      case TripState.waitingToStartCarpool:
        return 500;
      case TripState.ongoingCarpool:
        return 450;
      case TripState.finishedCarpool:
        return 300;
      case TripState.cancelledCarpool:
        return 400;
    }
  }

  /*
  * Returns the maximum height of the sliding panel.
   */
  double _getMaxHeight() {
    return MediaQuery.of(context).size.height * 0.5;
  }

  Future<void> _connectWebSocketForCommunication() async {
    try {
      await WebSocketManager().connectToService(
        serviceName: ApiConstants.inTripCommunicationServiceName,
        wsUrl: '${ApiConstants.webSocketUrl}${ApiConstants.inTripCommunicationServiceName}/ws',
      );
      log('TAG: HomePage: Connected to communication WebSocket service');
    } catch (e) {
      log('TAG: HomePage: Error connecting to communication WebSocket: $e');
    }
  }
}