import 'package:uniride_driver/features/auth/data/models/user_model.dart';

abstract class UserLocalService {
  Future<void> saveUser(UserModel user);
  Future<void> deleteAllUsers();
  Future<UserModel?> getUser();
}