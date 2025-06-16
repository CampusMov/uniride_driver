enum UserStatus {
  // ignore: constant_identifier_names
  NOT_VERIFIED,
  // ignore: constant_identifier_names
  VERIFIED,
  // ignore: constant_identifier_names
  ACTIVE,
  // ignore: constant_identifier_names
  BLOCKED,
  // ignore: constant_identifier_names
  DELETED,
}

extension UserStatusExtension on UserStatus {
  static UserStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'not_verified':
        return UserStatus.NOT_VERIFIED;
      case 'verified':
        return UserStatus.VERIFIED;
      case 'active':
        return UserStatus.ACTIVE;
      case 'blocked':
        return UserStatus.BLOCKED;
      case 'deleted':
        return UserStatus.DELETED;
      default:
        return UserStatus.NOT_VERIFIED;
    }
  }
}