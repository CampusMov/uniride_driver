import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uniride_driver/core/theme/color_paletter.dart';
import 'package:uniride_driver/features/home/presentation/bloc/map/map_bloc.dart';
import 'package:uniride_driver/features/home/presentation/bloc/map/map_event.dart';
import 'package:uniride_driver/features/home/presentation/bloc/map/map_state.dart';
import 'package:uniride_driver/features/home/presentation/bloc/select_location/select_location_bloc.dart';
import 'package:uniride_driver/features/home/presentation/bloc/select_location/select_location_event.dart';
import 'package:uniride_driver/features/home/presentation/pages/create_carpool_page.dart';
import 'package:uniride_driver/features/home/presentation/pages/position_destination_selection_page.dart';
import 'package:uniride_driver/features/home/presentation/pages/position_origin_selection_page.dart';
import 'package:uniride_driver/features/home/presentation/widgets/map_view.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';

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


  @override
  void initState() {
    
    super.initState();
    

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
                        page = CreateCarpoolPage(
                          onTap: (value) {
                            
                            debugPrint("onTap: $value");
                            
                            //Deacuerdo al valor devuelto por el ontap me lleva a la vista de origin o destination
                            //True significa que se selecciona el origen, false el destino
                            
                            value ? debugPrint("Seleccionar origen") :
                            debugPrint("Seleccionar destino");

                            value ? _panelNavigatorKey.currentState?.pushNamed('/position_selection_origin') :
                            _panelNavigatorKey.currentState?.pushNamed('/position_selection_destination');

                          },
                          
                        );
                        break;
                      case '/position_selection_origin':
                        page = PositionSelectionPageOrigin(
                          onTap: (){
                            // Navega a la página de creación de carpool
                            
                            _panelNavigatorKey.currentState?.pushNamed('/create_carpool');
                          }
                        );
                        break;
                      case '/position_selection_destination':
                        page = PositionSelectionPageDestination(
                          onTap: (){
                            // Navega a la página de creación de carpool
                            
                            _panelNavigatorKey.currentState?.pushNamed('/create_carpool');
                          }
                        );
                        break;
                      default:
                        page = CreateCarpoolPage(
                          onTap: (value) {
                            debugPrint("onTap: $value");
                            
                            value ? debugPrint("Seleccionar origen") :
                            debugPrint("Seleccionar destino");

                            value ? _panelNavigatorKey.currentState?.pushNamed('/position_selection_origin') :
                            _panelNavigatorKey.currentState?.pushNamed('/position_selection_destination');
                          }
                          
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