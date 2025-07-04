enum UserStatus {
  notVerified('NOT_VERIFIED'),
  verified('VERIFIED'),
  active('ACTIVE'),
  blocked('BLOCKED'),
  deleted('DELETED');

  const UserStatus(this.value);
  final String value;

  static UserStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'not_verified':
        return UserStatus.notVerified;
      case 'verified':
        return UserStatus.verified;
      case 'active':
        return UserStatus.active;
      case 'blocked':
        return UserStatus.blocked;
      case 'deleted':
        return UserStatus.deleted;
      default:
        return UserStatus.notVerified;
    }
  }
}

extension UserStatusExtension on UserStatus {
  static UserStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'not_verified':
        return UserStatus.notVerified;
      case 'verified':
        return UserStatus.verified;
      case 'active':
        return UserStatus.active;
      case 'blocked':
        return UserStatus.blocked;
      case 'deleted':
        return UserStatus.deleted;
      default:
        return UserStatus.notVerified;
    }
  }
}