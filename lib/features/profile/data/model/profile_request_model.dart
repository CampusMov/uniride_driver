import '../../domain/entities/enum_gender.dart';
import '../../domain/entities/profile.dart';
import 'class_schedule_request_model.dart';

class ProfileRequestModel {
  final String userId;
  final String institutionalEmailAddress;
  final String personalEmailAddress;
  final String countryCode;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String birthDate;
  final EGender gender;
  final String profilePictureUrl;
  final String university;
  final String faculty;
  final String academicProgram;
  final String semester;
  final List<ClassScheduleRequestModel> classSchedules;

  const ProfileRequestModel({
    required this.userId,
    required this.institutionalEmailAddress,
    required this.personalEmailAddress,
    required this.countryCode,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.gender,
    required this.profilePictureUrl,
    required this.university,
    required this.faculty,
    required this.academicProgram,
    required this.semester,
    required this.classSchedules,
  });

  factory ProfileRequestModel.fromDomain(Profile profile) {
    return ProfileRequestModel(
      userId: profile.userId,
      institutionalEmailAddress: profile.institutionalEmailAddress,
      personalEmailAddress: profile.personalEmailAddress,
      countryCode: profile.countryCode,
      phoneNumber: profile.phoneNumber,
      firstName: profile.firstName,
      lastName: profile.lastName,
      birthDate: profile.birthDate ?? DateTime.now().toIso8601String(),
      gender: profile.gender,
      profilePictureUrl: profile.profilePictureUrl,
      university: profile.university,
      faculty: profile.faculty,
      academicProgram: profile.academicProgram,
      semester: profile.semester,
      classSchedules: profile.classSchedules
          .map((schedule) => ClassScheduleRequestModel.fromDomain(schedule))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'institutionalEmailAddress': institutionalEmailAddress,
      'personalEmailAddress': personalEmailAddress,
      'countryCode': countryCode,
      'phoneNumber': phoneNumber,
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate,
      'gender': gender.value,
      'profilePictureUrl': profilePictureUrl,
      'university': university,
      'faculty': faculty,
      'academicProgram': academicProgram,
      'semester': semester,
      'classSchedules': classSchedules.map((schedule) => schedule.toJson()).toList(),
    };
  }
}