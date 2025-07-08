import 'package:uniride_driver/core/utils/resource.dart';

import '../../../shared/domain/entities/location.dart';
import '../entities/carpool.dart';

abstract class CarpoolRepository {
  Future<Resource<Carpool>> createCarpool(Carpool request);
  Future<Resource<Carpool>> getCarpoolById(String carpoolId);
  Future<Resource<Carpool>> startCarpool(String carpoolId, Location request);
}