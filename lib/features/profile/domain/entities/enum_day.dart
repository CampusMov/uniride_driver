enum EDay {
  monday('MONDAY'),
  tuesday('TUESDAY'),
  wednesday('WEDNESDAY'),
  thursday('THURSDAY'),
  friday('FRIDAY'),
  saturday('SATURDAY'),
  sunday('SUNDAY');

  const EDay(this.value);
  final String value;

  static EDay fromString(String? value) {
    if (value == null || value.isEmpty) return EDay.monday;
    switch (value.trim().toUpperCase()) {
      case 'MONDAY':
        return EDay.monday;
      case 'TUESDAY':
        return EDay.tuesday;
      case 'WEDNESDAY':
        return EDay.wednesday;
      case 'THURSDAY':
        return EDay.thursday;
      case 'FRIDAY':
        return EDay.friday;
      case 'SATURDAY':
        return EDay.saturday;
      case 'SUNDAY':
        return EDay.sunday;
      default:
        return EDay.monday;
    }
  }

  String showDay() {
    switch (this) {
      case EDay.monday:
        return 'Lunes';
      case EDay.tuesday:
        return 'Martes';
      case EDay.wednesday:
        return 'Miércoles';
      case EDay.thursday:
        return 'Jueves';
      case EDay.friday:
        return 'Viernes';
      case EDay.saturday:
        return 'Sábado';
      case EDay.sunday:
        return 'Domingo';
    }
  }
}