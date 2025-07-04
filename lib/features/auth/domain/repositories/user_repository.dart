
import 'package:uniride_driver/features/auth/domain/entities/user.dart';

abstract class UserRepository {
  Future<void> saveUserLocally(User user);
  Future<void> deleteAllUsersLocally();
  Future<User?> getUserLocally();
}