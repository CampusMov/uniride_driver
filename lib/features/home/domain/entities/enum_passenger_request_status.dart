enum PassengerRequestStatus {
  pending('PENDING'),
  accepted('ACCEPTED'),
  rejected('REJECTED'),
  cancelled('CANCELLED');

  const PassengerRequestStatus(this.value);
  final String value;

  static PassengerRequestStatus fromString(String value) {
    switch (value.toUpperCase()) {
      case 'PENDING':
        return PassengerRequestStatus.pending;
      case 'ACCEPTED':
        return PassengerRequestStatus.accepted;
      case 'REJECTED':
        return PassengerRequestStatus.rejected;
      case 'CANCELLED':
        return PassengerRequestStatus.cancelled;
      default:
        return PassengerRequestStatus.pending;
    }
  }
}