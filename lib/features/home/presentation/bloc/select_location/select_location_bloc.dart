import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniride_driver/features/home/data/datasources/location_service.dart';
import 'package:uniride_driver/features/home/data/repositories/location_repository.dart';
import 'package:uniride_driver/features/home/domain/entities/location_app.dart';
import 'package:uniride_driver/features/home/domain/entities/place_prediction.dart';
import 'package:uniride_driver/features/home/presentation/bloc/select_location/select_location_event.dart';
import 'package:uniride_driver/features/home/presentation/bloc/select_location/select_location_state.dart';

class SelectLocationBloc extends Bloc<SelectLocationEvent, SelectLocationState> {
  SelectLocationBloc() : super(SelectLocationInitial()) {
    //Evento para obtener ubicación por placeId (Place Details API)
    on<GetLocationOriginByPlaceId>((event, emit) async{
      emit(SelectLocationInitial());
      final repository = LocationRepository(locationService: LocationService());

      final LocationApp? location = await repository.getLocationByPlaceId(event.placeId);

      if (location != null) {
        debugPrint("Ubicación por Place Details: ${location.latitude}, ${location.longitude}");
        emit(SelectLocationLoadesOrigin(locationOrigin: location));
      }
      else {
        debugPrint("No se pudo obtener la ubicación por Place Details.");
        emit(SelectLocationError(message: "No se pudo obtener la ubicación."));
      }
    });

    on<GetLocationDestinationByPlaceId>((event, emit) async{
      emit(SelectLocationInitial());
      final repository = LocationRepository(locationService: LocationService());

      final LocationApp? location = await repository.getLocationByPlaceId(event.placeId);

      if (location != null) {
        debugPrint("Ubicación por Place Details: ${location.latitude}, ${location.longitude}");
        emit(SelectLocationLoadesDestination(locationDestination: location));
      }
      else {
        debugPrint("No se pudo obtener la ubicación por Place Details.");
        emit(SelectLocationError(message: "No se pudo obtener la ubicación."));
      }
    });

    //Eventos legacy para mantener compatibilidad (deprecados)
    on<GetLocationOrigin>((event, emit) async{
      emit(SelectLocationInitial());
      final repository = LocationRepository(locationService: LocationService());

      final LocationApp? location = await repository.getLocation(event.address);

      if (location != null) {
        debugPrint("Ubicación: ${location.latitude}, ${location.longitude}");
        emit(SelectLocationLoadesOrigin(locationOrigin: location));
      }
      else {
        debugPrint("No se pudo obtener la ubicación.");
        emit(SelectLocationError(message: "No se pudo obtener la ubicación."));
      }
    });

    on<GetLocationDestination>((event, emit) async{
      emit(SelectLocationInitial());
      final repository = LocationRepository(locationService: LocationService());

      final LocationApp? location = await repository.getLocation(event.address);

      if (location != null) {
        debugPrint("Ubicación: ${location.latitude}, ${location.longitude}");
        emit(SelectLocationLoadesDestination(locationDestination: location));
      }
      else {
        debugPrint("No se pudo obtener la ubicación.");
        emit(SelectLocationError(message: "No se pudo obtener la ubicación."));
      }
    });

    //Actualizacion en pantalla de la ubicacion seleccionada
    on<UpdateSelecLocation>((event, emit) {
      emit(SelectLocationInitial());
      emit(SelectLocationLive(location: event.location));
    });

    on<SearchOriginLocation>((event,emit) async{
      emit(SelectLocationInitial());

      final repository = LocationRepository(locationService: LocationService());
      final List<Prediction> predictions = await repository.searchLocation(event.query);

      emit(SelectLocationSearch(predictions: predictions));
    });

    on<SearchDestinationLocation>((event,emit) async{
      emit(SelectLocationInitial());

      final repository = LocationRepository(locationService: LocationService());
      final List<Prediction> predictions = await repository.searchLocation(event.query);

      emit(SelectLocationSearch(predictions: predictions));
    });
  }
}