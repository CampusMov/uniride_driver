enum EGender {
  male('MALE'),
  female('FEMALE');

  const EGender(this.value);
  final String value;

  static EGender fromString(String? value) {
    if (value == null || value.isEmpty) return EGender.male;
    switch (value.trim().toLowerCase()) {
      case 'male':
        return EGender.male;
      case 'female':
        return EGender.female;
      default:
        return EGender.male;
    }
  }
}