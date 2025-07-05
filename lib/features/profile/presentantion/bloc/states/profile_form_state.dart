import 'package:equatable/equatable.dart';
import 'package:uniride_driver/features/profile/domain/entities/class_schedule.dart';
import 'package:uniride_driver/features/profile/domain/entities/enum_gender.dart';
import 'package:uniride_driver/features/profile/domain/entities/profile.dart';

class ProfileFormState extends Equatable {
  final String userId;
  final String firstName;
  final String lastName;
  final String profilePictureUrl;
  final DateTime? birthDate;
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

  const ProfileFormState({
    this.userId = '1',
    this.firstName = '',
    this.lastName = '',
    this.profilePictureUrl = '',
    this.birthDate,
    this.gender = EGender.male,
    this.institutionalEmailAddress = '',
    this.personalEmailAddress = '',
    this.countryCode = '+51',
    this.phoneNumber = '',
    this.university = '',
    this.faculty = '',
    this.academicProgram = '',
    this.semester = '',
    this.classSchedules = const [],
  });

  Profile toDomain() {
    return Profile(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      profilePictureUrl: profilePictureUrl,
      birthDate: birthDate?.toIso8601String(),
      gender: gender,
      institutionalEmailAddress: institutionalEmailAddress,
      personalEmailAddress: personalEmailAddress,
      countryCode: countryCode,
      phoneNumber: phoneNumber,
      university: university,
      faculty: faculty,
      academicProgram: academicProgram,
      semester: semester,
      classSchedules: classSchedules,
    );
  }

  ProfileFormState copyWith({
    String? userId,
    String? firstName,
    String? lastName,
    String? profilePictureUrl,
    DateTime? birthDate,
    EGender? gender,
    String? institutionalEmailAddress,
    String? personalEmailAddress,
    String? countryCode,
    String? phoneNumber,
    String? university,
    String? faculty,
    String? academicProgram,
    String? semester,
    List<ClassSchedule>? classSchedules,
  }) {
    return ProfileFormState(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      institutionalEmailAddress: institutionalEmailAddress ?? this.institutionalEmailAddress,
      personalEmailAddress: personalEmailAddress ?? this.personalEmailAddress,
      countryCode: countryCode ?? this.countryCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      university: university ?? this.university,
      faculty: faculty ?? this.faculty,
      academicProgram: academicProgram ?? this.academicProgram,
      semester: semester ?? this.semester,
      classSchedules: classSchedules ?? this.classSchedules,
    );
  }

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