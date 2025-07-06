enum EVehicleStatus {
  active('ACTIVE'),
  inactive('INACTIVE'),
  retired('RETIRED');

  const EVehicleStatus(this.value);
  final String value;

  static EVehicleStatus fromString(String? value) {
    if (value == null || value.isEmpty) return EVehicleStatus.active;
    switch (value.trim().toUpperCase()) {
      case 'ACTIVE':
        return EVehicleStatus.active;
      case 'INACTIVE':
        return EVehicleStatus.inactive;
      case 'RETIRED':
        return EVehicleStatus.retired;
      default:
        return EVehicleStatus.active;
    }
  }
}