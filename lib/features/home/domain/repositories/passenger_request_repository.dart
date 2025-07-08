import 'package:uniride_driver/features/home/domain/entities/passenger_request.dart';

import '../../../../core/utils/resource.dart';

abstract class PassengerRequestRepository {
  Future<Resource<List<PassengerRequest>>> getPassengerRequestsByCarpoolId(String carpoolId);
}