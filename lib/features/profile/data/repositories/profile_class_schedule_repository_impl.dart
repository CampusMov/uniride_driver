import 'dart:developer';
import 'dart:io';

import '../../../../core/utils/resource.dart';
import '../../domain/entities/class_schedule.dart';
import '../../domain/repositories/profile_class_schedule_repository.dart';
import '../../domain/services/profile_class_schedule_service.dart';

class ProfileClassScheduleRepositoryImpl implements ProfileClassScheduleRepository {
  final ProfileClassScheduleService profileClassScheduleService;

  ProfileClassScheduleRepositoryImpl({required this.profileClassScheduleService});

  @override
  Future<Resource<List<ClassSchedule>>> getClassScheduleByProfileId(String profileId) async {
    try {
      final classSchedulesListResponse = await profileClassScheduleService.getClassSchedulesByProfileId(profileId);
      if (classSchedulesListResponse.isEmpty) {
        log('TAG: ProfileClassScheduleRepositoryImpl: No class schedules found for profile ID: $profileId');
        return const Failure('No class schedules found for profile ID');
      } else {
        log('TAG: ProfileClassScheduleRepositoryImpl: Class schedules fetched successfully for profile ID: $profileId');
        return Success(classSchedulesListResponse.map((schedule) => schedule.toDomain()).toList());
      }
    } on IOException catch (e) {
      log('TAG: ProfileClassScheduleRepositoryImpl: Network error while fetching class schedules for profile ID: $profileId');
      return Failure('Network error: ${e.toString()}');
    } catch (e) {
      log('TAG: ProfileClassScheduleRepositoryImpl: Unexpected error while fetching class schedules for profile ID: $profileId');
      return Failure('An unexpected error occurred: ${e.toString()}');
    }
  }
}
