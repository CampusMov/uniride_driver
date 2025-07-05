import 'package:uniride_driver/core/utils/resource.dart';
import 'package:uniride_driver/features/profile/domain/entities/class_schedule.dart';

abstract class ProfileClassScheduleRepository {
  Future<Resource<List<ClassSchedule>>> getClassScheduleByProfileId(String profileId);
}