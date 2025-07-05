import 'dart:developer';

import '../../../../core/utils/resource.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/services/profile_service.dart';
import '../model/profile_request_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileService profileService;

  ProfileRepositoryImpl({required this.profileService});

  @override
  Future<Resource<void>> saveProfile(Profile profile) async {
    try {
      await profileService.saveProfile(ProfileRequestModel.fromDomain(profile));
      log('TAG: ProfileRepositoryImpl: Profile saved successfully');
      return const Success(null);
    } catch (e) {
      log('TAG: ProfileRepositoryImpl: Error saving profile: $e');
      return Failure(e.toString());
    }
  }

  @override
  Future<Resource<Profile>> getProfileById(String profileId) async {
    try {
      final response = await profileService.getProfileById(profileId);
      log('TAG: ProfileRepositoryImpl: Profile fetched successfully for ID: $profileId');
      return Success(response.toDomain());
    } catch (e) {
      log('TAG: ProfileRepositoryImpl: Error fetching profile: $e');
      return Failure(e.toString());
    }
  }
}