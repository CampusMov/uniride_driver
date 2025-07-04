import 'package:uniride_driver/features/auth/data/models/user_model.dart';
import 'package:uniride_driver/features/auth/domain/entities/user.dart';
import 'package:uniride_driver/features/auth/domain/repositories/user_repository.dart';

import '../../domain/services/user_local_service.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalService userLocalService;
  UserRepositoryImpl({required this.userLocalService});

  @override
  Future<void> deleteAllUsersLocally() async {
    try {
      await userLocalService.deleteAllUsers();
    } catch (e) {
      throw Exception('Error deleting users locally: $e');
    }
  }

  @override
  Future<User?> getUserLocally() async {
    try {
      final userModel = await userLocalService.getUser();
      return userModel;
    } catch (e) {
      throw Exception('Error getting user locally: $e');
    }
  }

  @override
  Future<void> saveUserLocally(User user) async {
    try {
      await userLocalService.saveUser(UserModel.fromDomain(user));
    } catch (e) {
      throw Exception('Error saving user locally: $e');
    }
  }
}