import 'package:uniride_driver/core/utils/resource.dart';
import 'package:uniride_driver/features/profile/domain/entities/profile.dart';

abstract class ProfileRepository {
  Future<Resource<void>> saveProfile(Profile profile);
  Future<Resource<Profile>> getProfileById(String profileId);
}