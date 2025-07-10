import 'dart:developer';
import 'dart:io';

import 'package:uniride_driver/core/utils/resource.dart';
import 'package:uniride_driver/features/home/data/model/carpool_request_model.dart';
import 'package:uniride_driver/features/home/data/model/location_request_model.dart';
import 'package:uniride_driver/features/shared/domain/entities/location.dart';

import '../../domain/entities/carpool.dart';
import '../../domain/repositories/carpool_repository.dart';
import '../../domain/services/carpool_service.dart';

class CarpoolRepositoryImpl implements CarpoolRepository {
  final CarpoolService carpoolService;

  CarpoolRepositoryImpl({required this.carpoolService});

  @override
  Future<Resource<Carpool>> createCarpool(Carpool request) async {
    try {
      log('TAG: CarpoolRepository - Creating carpool for driver: ${request.driverId}');

      final requestModel = CarpoolRequestModel.fromDomain(request);
      final carpoolResponse = await carpoolService.createCarpool(requestModel);

      final carpool = carpoolResponse.toDomain();

      log('TAG: CarpoolRepository - Successfully created carpool with ID: ${carpool.id}');
      return Success(carpool);
    } on SocketException {
      log('TAG: CarpoolRepository - Network error while creating carpool');
      return const Failure('No internet connection');
    } on HttpException {
      log('TAG: CarpoolRepository - HTTP error while creating carpool');
      return const Failure('Server error occurred');
    } catch (e) {
      log('TAG: CarpoolRepository - Unexpected error while creating carpool: $e');
      return Failure('An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<Resource<Carpool>> getCarpoolById(String carpoolId) async {
    try {
      log('TAG: CarpoolRepository - Fetching carpool by ID: $carpoolId');

      final carpoolResponse = await carpoolService.getCarpoolById(carpoolId);

      final carpool = carpoolResponse.toDomain();

      log('TAG: CarpoolRepository - Successfully fetched carpool with ID: ${carpool.id}');
      return Success(carpool);
    } on SocketException {
      log('TAG: CarpoolRepository - Network error while fetching carpool');
      return const Failure('No internet connection');
    } on HttpException {
      log('TAG: CarpoolRepository - HTTP error while fetching carpool');
      return const Failure('Server error occurred');
    } catch (e) {
      log('TAG: CarpoolRepository - Unexpected error while fetching carpool: $e');
      return Failure('An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<Resource<Carpool>> startCarpool(String carpoolId, Location request) async {
    try {
      log('TAG: CarpoolRepository - Starting carpool with ID: $carpoolId at location: ${request.name}');

      final requestModel = LocationRequestModel.fromDomain(request);

      final carpoolResponse = await carpoolService.startCarpool(carpoolId, requestModel);

      final carpool = carpoolResponse.toDomain();

      log('TAG: CarpoolRepository - Successfully started carpool with ID: ${carpool.id}');
      return Success(carpool);
    } on SocketException {
      log('TAG: CarpoolRepository - Network error while starting carpool');
      return const Failure('No internet connection');
    } on HttpException {
      log('TAG: CarpoolRepository - HTTP error while starting carpool');
      return const Failure('Server error occurred');
    } catch (e) {
      log('TAG: CarpoolRepository - Unexpected error while starting carpool: $e');
      return Failure('An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<Resource<Carpool>> finishCarpool(String carpoolId) async {
    try {
      log('TAG: CarpoolRepository - Finishing carpool with ID: $carpoolId');

      final carpoolResponse = await carpoolService.finishCarpool(carpoolId);

      final carpool = carpoolResponse.toDomain();

      log('TAG: CarpoolRepository - Successfully finished carpool with ID: ${carpool.id}');
      return Success(carpool);
    } on SocketException {
      log('TAG: CarpoolRepository - Network error while finishing carpool');
      return const Failure('No internet connection');
    } on HttpException {
      log('TAG: CarpoolRepository - HTTP error while finishing carpool');
      return const Failure('Server error occurred');
    } catch (e) {
      log('TAG: CarpoolRepository - Unexpected error while finishing carpool: $e');
      return Failure('An unexpected error occurred: ${e.toString()}');
    }
  }
}