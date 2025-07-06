import 'package:uniride_driver/features/home/domain/entities/location_app.dart';

abstract class SelectLocationEvent {
  const SelectLocationEvent();
}

//Nuevos eventos que usan Place Details API para coordenadas consistentes
class GetLocationOriginByPlaceId extends SelectLocationEvent {
  final String placeId;
  const GetLocationOriginByPlaceId({required this.placeId});
}

class GetLocationDestinationByPlaceId extends SelectLocationEvent {
  final String placeId;
  const GetLocationDestinationByPlaceId({required this.placeId});
}

//Eventos legacy para obtener la coordenadas de una direccion (deprecados)
@Deprecated('Use GetLocationOriginByPlaceId for consistent coordinates')
class GetLocationOrigin extends SelectLocationEvent {
  final String address;
  const GetLocationOrigin({required this.address});
}

@Deprecated('Use GetLocationDestinationByPlaceId for consistent coordinates')
class GetLocationDestination extends SelectLocationEvent {
  final String address;
  const GetLocationDestination({required this.address});
}

//Evento de busqueda de ubicaciones
class SearchOriginLocation extends SelectLocationEvent {
  final String query;
  const SearchOriginLocation({required this.query});
}
class SearchDestinationLocation extends SelectLocationEvent {
  final String query;

  SearchDestinationLocation({required this.query});
}

class SelectLocation extends SelectLocationEvent {
  final LocationApp locationApp;
  const SelectLocation({required this.locationApp});
}

//Evento para actualizar la ubicacion Seleccionada
class UpdateSelecLocation extends SelectLocationEvent {
  final String location;
  const UpdateSelecLocation({required this.location});
}

//Evento para definir seleccioar cierto punto de partida "Destino" o "Origen"
class GetModeSelection extends SelectLocationEvent {
  final bool isMode;
  const GetModeSelection({required this.isMode});
}