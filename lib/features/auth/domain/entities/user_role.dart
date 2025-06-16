enum UserRole {
  student,
  driver,
}

extension UserRoleExtension on UserRole {
  String get name {
    switch (this) {
      case UserRole.student:
        return 'STUDENT';
      case UserRole.driver:
        return 'DRIVER';
    }
  }

  static UserRole fromString(String role) {
    switch (role.toUpperCase()) {
      case 'STUDENT':
        return UserRole.student;
      case 'DRIVER':
        return UserRole.driver;
      default:
        throw Exception('Rol no reconocido: $role');
    }
  }
}