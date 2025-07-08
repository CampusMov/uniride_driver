import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniride_driver/core/theme/color_paletter.dart';
import 'package:uniride_driver/features/home/presentation/bloc/map/map_bloc.dart';
import 'package:uniride_driver/features/home/presentation/bloc/map/map_state.dart';
import 'package:uniride_driver/features/home/presentation/pages/create_carpool_page.dart';
import 'package:uniride_driver/features/home/presentation/pages/details_carpool_page.dart';
import 'package:uniride_driver/features/home/presentation/pages/position_destination_selection_page.dart';
import 'package:uniride_driver/features/home/presentation/pages/position_origin_selection_page.dart';
import 'package:uniride_driver/features/home/presentation/pages/request_passengers_page.dart';
import 'package:uniride_driver/features/home/presentation/widgets/btns_adduser_and_location_view.dart';
import 'package:uniride_driver/features/home/presentation/widgets/map_view.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';
import 'package:uniride_driver/features/home/presentation/bloc/carpool/create_carpool_bloc.dart';
import 'package:uniride_driver/core/di/injection_container.dart' as di;

import '../../data/model/route_request_model.dart';
import '../bloc/map/map_event.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final SlidingUpPanelController panelController = SlidingUpPanelController();
  final ScrollController scrollController = ScrollController();

  final GlobalKey<NavigatorState> _panelNavigatorKey = GlobalKey<NavigatorState>();

  double _controlHeight = 450.0; // Altura del panel deslizante
  bool _isNavigating = false; // Estado para mostrar carga durante navegación
  bool _isCarpoolStarted = false; // Estado para mantener si el carpool fue iniciado

  @override
  void initState() {
    super.initState();
  }

  void _handleRouteRequest(RouteRequestModel routeRequest) {
    print('🏠 HomePage._handleRouteRequest llamado');
    print('📍 Desde: ${routeRequest.startLatitude}, ${routeRequest.startLongitude}');
    print('📍 Hacia: ${routeRequest.endLatitude}, ${routeRequest.endLongitude}');

    try {
      // Usar el context principal de HomePage, no del Navigator anidado
      final mapBloc = context.read<MapBloc>();
      print('✅ MapBloc encontrado en context principal');
      mapBloc.add(GetRoute(routeRequestModel: routeRequest));
      print('✅ Evento GetRoute enviado al MapBloc');
    } catch (e) {
      print('❌ Error enviando evento al MapBloc: $e');
    }
  }

  // Método para navegar con carga
  Future<void> _navigateWithLoading(String routeName) async {
    setState(() {
      _isNavigating = true;
    });

    // Simular carga pequeña
    await Future.delayed(Duration(milliseconds: 500));

    // Navegar a la nueva página
    _panelNavigatorKey.currentState?.pushNamed(routeName);

    setState(() {
      _isNavigating = false;
    });
  }

  // Método para navegar a detalles del carpool
  Future<void> _navigateToDetails() async {
    setState(() {
      _isNavigating = true;
    });

    // Simular carga pequeña
    await Future.delayed(Duration(milliseconds: 500));

    // Navegar a la página de detalles
    _panelNavigatorKey.currentState?.pushNamed('/details_carpool');

    setState(() {
      _isNavigating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Menu de la aplicacion
      body: Stack(
        children: [
          BlocBuilder<MapBloc,MapState>(
              builder: (context,state){
                if(state is InitialState){

                  return MapViewWidget(
                    markers: {},
                    polylines: {},
                  );

                }
                else if (state is LoadingState){
                  return Center(
                    child: CircularProgressIndicator(
                      color: ColorPaletter.background,
                    ),
                  );
                } else if(state is LoadedState){
                  return MapViewWidget(
                    markers: state.markers,
                    polylines: state.polylines,);
                } else if(state is ErrorState){
                  return Center(
                    child: Text("Error al cargar el mapa", style: TextStyle(color: ColorPaletter.textPrimary)),
                  );
                }
                return Container(
                  color: ColorPaletter.error,
                );
              }
          ),

          //Btns de accion flotante para aceptar o rechazar solicitudes de viaje
          //y mi ubicacion
          BtnsAddUserAndLocationView(
              onTapUser: (){
                _navigateWithLoading('/request_passengers');

              },
              onTapLocation: (){
                // Centrar el mapa en la ubicación actual del usuario
                context.read<MapBloc>().add(const CenterOnUserLocation());
              }
          ),

          // Panel deslizante
          SlidingUpPanelWidget(
              controlHeight: _controlHeight,
              anchor: 0.4,
              panelController: panelController,
              enableOnTap: true,
              onTap: () {
                if (panelController.status == SlidingUpPanelStatus.expanded) {
                  panelController.collapse();
                } else {
                  panelController.expand();
                }
              },

              child: Container(
                decoration: BoxDecoration(
                  color: ColorPaletter.background,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Navigator(
                    key: _panelNavigatorKey,
                    onGenerateRoute: (settings) {
                      Widget page;
                      switch (settings.name) {
                        case '/create_carpool':
                          page = BlocProvider<CreateCarpoolBloc>(
                            create: (context) => di.sl<CreateCarpoolBloc>(),
                            child: CreateCarpoolPage(
                              isInitiallyStarted: _isCarpoolStarted,
                              onModeChanged: (started) {
                                setState(() {
                                  _isCarpoolStarted = started;
                                });
                              },
                              onNavigateToDetails: () {
                                _navigateToDetails();
                              },
                              onTap: (value) {

                                debugPrint("onTap: $value");

                                //Deacuerdo al valor devuelto por el ontap me lleva a la vista de origin o destination
                                //True significa que se selecciona el origen, false el destino

                                value ? debugPrint("Seleccionar origen") :
                                debugPrint("Seleccionar destino");

                                // Usar navegación con carga
                                value ? _navigateWithLoading('/position_selection_origin') :
                                _navigateWithLoading('/position_selection_destination');

                              },
                              onRouteRequest: _handleRouteRequest,
                            ),
                          );
                          break;
                        case '/request_passengers':
                          page = RequestPassengersPage();
                          break;
                        case '/details_carpool':
                          page = CarpoolDetailsPage();
                          break;
                        case '/position_selection_origin':
                          page = PositionSelectionPageOrigin(
                              onTap: (){
                                // Navegar a la página de creación de carpool con carga
                                _navigateWithLoading('/create_carpool');
                              }
                          );
                          break;
                        case '/position_selection_destination':
                          page = PositionSelectionPageDestination(
                              onTap: (){
                                // Navegar a la página de creación de carpool con carga
                                _navigateWithLoading('/create_carpool');
                              }
                          );
                          break;
                        default:
                          page = BlocProvider<CreateCarpoolBloc>(
                            create: (context) => di.sl<CreateCarpoolBloc>(),
                            child: CreateCarpoolPage(
                                isInitiallyStarted: _isCarpoolStarted,
                                onModeChanged: (started) {
                                  setState(() {
                                    _isCarpoolStarted = started;
                                  });
                                },
                                onNavigateToDetails: () {
                                  _navigateToDetails();
                                },
                                onTap: (value) {
                                  debugPrint("onTap: $value");

                                  value ? debugPrint("Seleccionar origen") :
                                  debugPrint("Seleccionar destino");

                                  // Usar navegación con carga
                                  value ? _navigateWithLoading('/position_selection_origin') :
                                  _navigateWithLoading('/position_selection_destination');
                                }, onRouteRequest: (RouteRequestModel value) {
                                  _handleRouteRequest(value);
                                }
                            ),
                          );
                      }
                      return MaterialPageRoute(builder: (_) => page);
                    },
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }
}