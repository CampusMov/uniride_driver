import '../../data/model/class_schedule_response_model.dart';

abstract class ProfileClassScheduleService {
  Future<List<ClassScheduleResponseModel>> getClassSchedulesByProfileId(String profileId);
}