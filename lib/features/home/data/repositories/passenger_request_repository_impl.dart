
import 'dart:developer';
import 'dart:io';

import 'package:uniride_driver/core/utils/resource.dart';

import 'package:uniride_driver/features/home/domain/entities/passenger_request.dart';

import '../../domain/repositories/passenger_request_repository.dart';
import '../../domain/services/passenger_request_service.dart';

class PassengerRequestRepositoryImpl implements PassengerRequestRepository {
  final PassengerRequestService passengerRequestService;

  PassengerRequestRepositoryImpl({required this.passengerRequestService});

  @override
  Future<Resource<List<PassengerRequest>>> getPassengerRequestsByCarpoolId(String carpoolId) async {
    try {
      final passengerRequestsResponse = await passengerRequestService.getPassengerRequestsByCarpoolId(carpoolId);
      if (passengerRequestsResponse.isEmpty) {
        log('TAG: PassengerRequestRepositoryImpl: No passenger requests found for carpool ID: $carpoolId');
        return Success([]);
      } else {
        log('TAG: PassengerRequestRepositoryImpl: Passenger requests fetched successfully for carpool ID: $carpoolId');
        return Success(passengerRequestsResponse.map((request) => request.toDomain()).toList());
      }
    } on IOException catch (e) {
      log('TAG: PassengerRequestRepositoryImpl: Network error while fetching passenger requests for carpool ID: $carpoolId');
      return Failure('Network error: ${e.toString()}');
    } catch (e) {
      log('TAG: PassengerRequestRepositoryImpl: Unexpected error while fetching passenger requests for carpool ID: $carpoolId');
      return Failure('An unexpected error occurred: ${e.toString()}');
    }
  }
}