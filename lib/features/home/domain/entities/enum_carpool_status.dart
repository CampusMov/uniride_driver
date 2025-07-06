enum CarpoolStatus {
  created('CREATED'),
  inProgress('IN_PROGRESS'),
  completed('COMPLETED'),
  cancelled('CANCELLED');

  const CarpoolStatus(this.value);
  final String value;

  static CarpoolStatus fromString(String value) {
    switch (value.toUpperCase()) {
      case 'CREATED':
        return CarpoolStatus.created;
      case 'IN_PROGRESS':
        return CarpoolStatus.inProgress;
      case 'COMPLETED':
        return CarpoolStatus.completed;
      case 'CANCELLED':
        return CarpoolStatus.cancelled;
      default:
        return CarpoolStatus.created;
    }
  }
}