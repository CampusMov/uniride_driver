import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:uniride_driver/features/home/domain/entities/routing-matching/enum_trip_state.dart';
import 'package:uniride_driver/features/home/presentation/bloc/carpool/create_carpool_bloc.dart';
import 'package:uniride_driver/features/home/presentation/pages/map/map_page.dart';
import 'package:uniride_driver/features/home/presentation/pages/panels/create_carpool_panel.dart';

import '../../../../core/di/injection_container.dart' as di;
import '../bloc/map/map_bloc.dart';
import '../bloc/map/map_event.dart';
import '../bloc/map/map_state.dart';
import 'dialogs/class_schedule_dialog.dart';
import 'dialogs/origin_location_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PanelController _panelController = PanelController();
  TripState _currentTripState = TripState.creatingCarpool;
  late CreateCarpoolBloc _createCarpoolBloc;

  @override
  void initState() {
    super.initState();
    _createCarpoolBloc = di.sl<CreateCarpoolBloc>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => MapBloc()),
            BlocProvider.value(value: _createCarpoolBloc),
          ],
        child: Scaffold(
          body: Stack(
            children: [
              _buildSlidingPanel(),
              _buildLocationButton(),
              // if (_currentTripState == TripState.ongoingCarpool || _currentTripState == TripState.waitingToStartCarpool)  TODO: Add button to open passengers request dialog
              _buildOriginLocationDialog(),
              _buildClassScheduleDialog(),
            ],
          ),
        ),
      ),
    );
  }

  /*
  * Builds the sliding panel that contains the trip information and controls.
   */
  Widget _buildSlidingPanel() {
    return SlidingUpPanel(
      controller: _panelController,
      minHeight: _getMinHeight(),
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
      panel: _buildPanel(),
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
  Widget _buildPanel() {
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
            child: _buildPanelContent(),
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
  Widget _buildPanelContent() {
    switch (_currentTripState) {
      case TripState.creatingCarpool:
        return Stack(
          children: [
            const CreateCarpoolPanel(),
            const CarpoolCreationResultDialog()
          ],
        );
      case TripState.waitingToStartCarpool:
        return Placeholder();
      case TripState.ongoingCarpool:
        return Placeholder();
      case TripState.finishedCarpool:
        return Placeholder();
      case TripState.cancelledCarpool:
        return Placeholder();
    }
  }

  /*
  * Builds the floating action button that centers the map on the user's location.
   */
  Widget _buildLocationButton() {
    return Positioned(
      bottom: _getMinHeight() + 20,
      right: 16,
      child: BlocBuilder<MapBloc, MapState>(
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
      ),
    );
  }

  /*
  * Builds the dialog for selecting the origin location when creating a carpool.
   */
  Widget _buildOriginLocationDialog() {
    if (_currentTripState != TripState.creatingCarpool) {
      return const SizedBox.shrink();
    }
    return const OriginLocationDialog();
  }

  /*
  * Builds the dialog for selecting the class schedule when creating a carpool.
   */
  Widget _buildClassScheduleDialog() {
    if (_currentTripState != TripState.creatingCarpool) {
      return const SizedBox.shrink();
    }
    return const ClassScheduleDialog();
  }

  /*
  * Returns the minimum height of the sliding panel based on the current trip state.
  * This is used to ensure that the panel has enough space for the content
   */
  double _getMinHeight() {
    switch (_currentTripState) {
      case TripState.creatingCarpool:
        return 450;
      case TripState.waitingToStartCarpool:
        return 400;
      case TripState.ongoingCarpool:
        return 350;
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
}