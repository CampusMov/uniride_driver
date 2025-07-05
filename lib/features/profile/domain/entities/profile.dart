import 'package:equatable/equatable.dart';

import 'class_schedule.dart';
import 'enum_gender.dart';

class Profile extends Equatable {
  final String userId;
  final String firstName;
  final String lastName;
  final String profilePictureUrl;
  final String? birthDate;
  final EGender gender;
  final String institutionalEmailAddress;
  final String personalEmailAddress;
  final String countryCode;
  final String phoneNumber;
  final String university;
  final String faculty;
  final String academicProgram;
  final String semester;
  final List<ClassSchedule> classSchedules;

  const Profile({
    this.userId = '1',
    required this.firstName,
    required this.lastName,
    required this.profilePictureUrl,
    this.birthDate,
    this.gender = EGender.male,
    this.institutionalEmailAddress = 'u202500000@upc.edu.pe',
    required this.personalEmailAddress,
    this.countryCode = '+51',
    required this.phoneNumber,
    required this.university,
    required this.faculty,
    required this.academicProgram,
    required this.semester,
    required this.classSchedules,
  });

  @override
  List<Object?> get props => [
    userId,
    firstName,
    lastName,
    profilePictureUrl,
    birthDate,
    gender,
    institutionalEmailAddress,
    personalEmailAddress,
    countryCode,
    phoneNumber,
    university,
    faculty,
    academicProgram,
    semester,
    classSchedules,
  ];
}