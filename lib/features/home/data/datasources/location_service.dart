import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:uniride_driver/core/constants/api_constants.dart';
import 'package:uniride_driver/features/home/data/model/place_dto.dart';
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

  Future<PlaceDto?> getDirections(String address) async {

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

      return items.map((item) => PlaceDto.fromJson(item)).first;

    }
    else{
      return null;
    }

    
  }
}