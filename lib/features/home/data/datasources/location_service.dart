import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:uniride_driver/core/constants/api_constants.dart';
import 'package:uniride_driver/features/home/data/model/place_dto.dart' as place_models;
import 'package:uniride_driver/features/home/data/model/place_prediction_dto.dart';

class LocationService {
  Future<List<PredictionDto>> searchLocation(String query) async {
    final Uri uri = Uri.parse(
      '${ApiConstants.googleMapSearchLocation}/json?input=${query}&key=${ApiConstants.googleMapApiKey}',
    );

    http.Response response = await http.get(uri);

    if(response.statusCode == HttpStatus.ok){

      final Map<String, dynamic> jsondto = jsonDecode(response.body);

      if (!jsondto.containsKey('predictions') || jsondto['predictions'] is! List) {
        debugPrint("Campo 'predictions' ausente o inválido.");
        return [];
      }

      final List items = jsondto['predictions'];

      debugPrint("Response: ${items}");

      return items.map((item) => PredictionDto.fromJson(item)).toList();

    }
    else{
      return [];
    }
  }

  Future<place_models.PlaceDto?> getPlaceDetails(String placeId) async {
    final Uri uri = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json?place_id=${placeId}&key=${ApiConstants.googleMapApiKey}&fields=place_id,name,formatted_address,geometry',
    );

    debugPrint("Place Details URL: ${uri.toString()}");

    http.Response response = await http.get(uri);

    if(response.statusCode == HttpStatus.ok){
      final Map<String, dynamic> jsondto = jsonDecode(response.body);

      debugPrint("Place Details Response: ${jsondto}");

      if (!jsondto.containsKey('result')) {
        debugPrint("Campo 'result' ausente o inválido.");
        return null;
      }

      final Map<String, dynamic> result = jsondto['result'];

      // Convertir el resultado de Place Details al formato PlaceDto
      return _convertPlaceDetailsToPlaceDto(result);
    }
    else{
      debugPrint("Error en Place Details: ${response.statusCode} - ${response.body}");
      return null;
    }
  }

  place_models.PlaceDto _convertPlaceDetailsToPlaceDto(Map<String, dynamic> placeDetails) {
    final geometry = placeDetails['geometry'];
    final location = geometry['location'];
    final viewport = geometry['viewport'];

    return place_models.PlaceDto(
      place: placeDetails['place_id'] ?? '',
      placeId: placeDetails['place_id'] ?? '',
      location: place_models.Location(
        latitude: location['lat']?.toDouble() ?? 0.0,
        longitude: location['lng']?.toDouble() ?? 0.0,
      ),
      granularity: 'ROOFTOP', // Default granularity
      viewport: place_models.Viewport(
        low: place_models.Location(
          latitude: viewport['southwest']['lat']?.toDouble() ?? 0.0,
          longitude: viewport['southwest']['lng']?.toDouble() ?? 0.0,
        ),
        high: place_models.Location(
          latitude: viewport['northeast']['lat']?.toDouble() ?? 0.0,
          longitude: viewport['northeast']['lng']?.toDouble() ?? 0.0,
        ),
      ),
      bounds: null, // Place Details doesn't always provide bounds
      formattedAddress: placeDetails['formatted_address'] ?? '',
      postalAddress: place_models.PostalAddress(
        regionCode: '',
        languageCode: '',
        postalCode: '',
        administrativeArea: null,
        locality: '',
        addressLines: [placeDetails['formatted_address'] ?? ''],
      ),
      addressComponents: [], // We can add this if needed
      types: List<String>.from(placeDetails['types'] ?? []),
      plusCode: null, // Place Details doesn't provide plus code
    );
  }

  // Método legacy para mantener compatibilidad (deprecado)
  @Deprecated('Use getPlaceDetails instead')
  Future<place_models.PlaceDto?> getDirections(String address) async {
    final encodedAddress = Uri.encodeComponent(address);

    final Uri uri = Uri.parse(
      '${ApiConstants.apiGeolocation}/${encodedAddress}?key=${ApiConstants.googleMapApiKey}',
    );
    debugPrint("url: ${ApiConstants.apiGeolocation}/${encodedAddress}?key=${ApiConstants.googleMapApiKey}");
    http.Response response = await http.get(uri);

    if(response.statusCode == HttpStatus.ok){

      final Map<String, dynamic> jsondto = jsonDecode(response.body);


      if (!jsondto.containsKey('results') || jsondto['results'] is! List) {
        debugPrint("Campo 'results' ausente o inválido.");
        return null;
      }

      final List items = jsondto['results'] ;

      debugPrint("Response: ${items}");

      return items.map((item) => place_models.PlaceDto.fromJson(item)).first;

    }
    else{
      return null;
    }
  }
}