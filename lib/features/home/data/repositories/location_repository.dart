import 'package:uniride_driver/features/home/data/datasources/location_service.dart';
import 'package:uniride_driver/features/home/data/model/place_dto.dart' as place_models;
import 'package:uniride_driver/features/home/data/model/place_prediction_dto.dart';
import 'package:uniride_driver/features/home/domain/entities/place_prediction.dart';

import '../../domain/entities/location_app.dart';

class LocationRepository {

  const LocationRepository({required this.locationService});

  final LocationService locationService;

  /// Obtiene detalles de ubicación usando Place Details API con placeId
  Future<LocationApp?> getLocationByPlaceId(String placeId) async {
    final place_models.PlaceDto? placeDto = await locationService.getPlaceDetails(placeId);

    if (placeDto == null) {
      return null;
    }

    return LocationApp(
      placeId: placeDto.placeId,
      address: placeDto.formattedAddress,
      locality: placeDto.postalAddress.locality,
      latitude: placeDto.location.latitude.toString(),
      longitude: placeDto.location.longitude.toString(),
    );
  }

  /// Método legacy para mantener compatibilidad (deprecado)
  @Deprecated('Use getLocationByPlaceId instead for consistent coordinates')
  Future<LocationApp?> getLocation(String address) async{
    final place_models.PlaceDto? placeDto = await locationService.getDirections(address);

    if (placeDto == null) {
      return null;
    }
    return LocationApp(
      placeId: placeDto.placeId,
      address: placeDto.formattedAddress,
      locality: placeDto.postalAddress.locality,
      latitude: placeDto.location.latitude.toString(),
      longitude: placeDto.location.longitude.toString(),
    );
  }

  Future<List<Prediction>> searchLocation(String query) async {
    final List<PredictionDto> predictions = await locationService.searchLocation(query);

    if (predictions.isEmpty) {
      return [];
    }

    return predictions.map((prediction) {
      return Prediction(
        placeId: prediction.placeId,
        description: prediction.description,
        isFavorite: false, 
      );
    }).toList();
  }
}