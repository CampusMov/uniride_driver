import 'package:uniride_driver/features/home/domain/entities/location_app.dart';
import 'package:uniride_driver/features/home/domain/entities/place_prediction.dart';

abstract class SelectLocationState {
  const SelectLocationState();
}
//Estado de inicio
class SelectLocationInitial extends SelectLocationState {
  
}
//Estado de carga
class SelectLocationLoading extends SelectLocationState {
  
}
//Evento para enviar respuesta de ubicacion desde seleslocation
class SelectLocationLoadesOrigin extends SelectLocationState {
  final LocationApp locationOrigin;

  const SelectLocationLoadesOrigin({required this.locationOrigin});
}
class SelectLocationLoadesDestination extends SelectLocationState {
  final LocationApp locationDestination;

  const SelectLocationLoadesDestination({required this.locationDestination});
}
//Estado de error
class SelectLocationError extends SelectLocationState {
  final String message;

  const SelectLocationError({required this.message});
}

//Estado de ubicacion seleccionada
class SelectLocationLive extends SelectLocationState {
  final String location;

  const SelectLocationLive({required this.location});
}

//Estado de buscando posibles ubicaciones
class SelectLocationSearch extends SelectLocationState {
  final List<Prediction> predictions;

  const SelectLocationSearch({required this.predictions});
}

//Estado de cambio de modo de seleccion
class SelectLocationMode extends SelectLocationState {
  final bool isMode;

  const SelectLocationMode({required this.isMode});
}