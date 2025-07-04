enum Role {
  passenger('PASSENGER'),
  driver('DRIVER');

  const Role(this.value);
  final String value;

  static Role fromString(String value) {
    switch (value.toLowerCase()) {
      case 'passenger':
        return Role.passenger;
      case 'driver':
        return Role.driver;
      default:
        return Role.driver;
    }
  }
}

extension UserRoleExtension on Role {
  String get name {
    switch (this) {
      case Role.passenger:
        return 'PASSENGER';
      case Role.driver:
        return 'DRIVER';
    }
  }

  static Role fromString(String role) {
    switch (role.toUpperCase()) {
      case 'PASSENGER':
        return Role.passenger;
      case 'DRIVER':
        return Role.driver;
      default:
        throw Exception('Invalid role: $role');
    }
  }
}