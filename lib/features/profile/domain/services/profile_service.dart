import '../../data/model/profile_request_model.dart';
import '../../data/model/profile_response_model.dart';

abstract class ProfileService {
  Future<void> saveProfile(ProfileRequestModel profileRequest);
  Future<ProfileResponseModel> getProfileById(String profileId);
}