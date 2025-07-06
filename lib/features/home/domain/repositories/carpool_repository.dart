import 'package:uniride_driver/core/utils/resource.dart';

import '../entities/carpool.dart';

abstract class CarpoolRepository {
  Future<Resource<Carpool>> createCarpool(Carpool request);
}