import 'package:sqflite/sqflite.dart';
import 'package:uniride_driver/features/auth/data/models/user_model.dart';
import 'package:uniride_driver/features/auth/domain/services/user_local_service.dart';

import '../../../../core/database/database_helper.dart';

class UserLocalServiceImpl implements UserLocalService {
  final DatabaseHelper databaseHelper;

  UserLocalServiceImpl({required this.databaseHelper});

  @override
  Future<void> deleteAllUsers() async {
    final db = await databaseHelper.database;

    await db.delete(DatabaseHelper.usersTable);
    print('All users deleted from local database');
  }

  @override
  Future<UserModel?> getUser() async {
    final db = await databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.usersTable,
      limit: 1,
      orderBy: 'created_at DESC',
    );

    if (maps.isNotEmpty) {
      return UserModel.fromJson(maps.first);
    }

    return null;
  }

  @override
  Future<void> saveUser(UserModel user) async {
    final db = await databaseHelper.database;

    await db.insert(
      DatabaseHelper.usersTable,
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    print('User saved locally: ${user.email}');
  }
}