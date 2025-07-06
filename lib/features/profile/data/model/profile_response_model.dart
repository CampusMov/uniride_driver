import '../../domain/entities/enum_gender.dart';
import '../../domain/entities/profile.dart';

class ProfileResponseModel {
  final String? id;
  final String? institutionalEmailAddress;
  final String? personalEmailAddress;
  final String? countryCode;
  final String? phoneNumber;
  final String? firstName;
  final String? lastName;
  final String? birthDate;
  final String? gender;
  final String? profilePictureUrl;
  final String? university;
  final String? faculty;
  final String? academicProgram;
  final String? semester;

  const ProfileResponseModel({
    this.id,
    this.institutionalEmailAddress,
    this.personalEmailAddress,
    this.countryCode,
    this.phoneNumber,
    this.firstName,
    this.lastName,
    this.birthDate,
    this.gender,
    this.profilePictureUrl,
    this.university,
    this.faculty,
    this.academicProgram,
    this.semester,
  });

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfileResponseModel(
      id: json['id'],
      institutionalEmailAddress: json['institutionalEmailAddress'],
      personalEmailAddress: json['personalEmailAddress'],
      countryCode: json['countryCode'],
      phoneNumber: json['phoneNumber'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      birthDate: json['birthDate'],
      gender: json['gender'],
      profilePictureUrl: json['profilePictureUrl'],
      university: json['university'],
      faculty: json['faculty'],
      academicProgram: json['academicProgram'],
      semester: json['semester'],
    );
  }

  Profile toDomain() {
    return Profile(
      userId: id ?? '',
      firstName: firstName ?? '',
      lastName: lastName ?? '',
      profilePictureUrl: profilePictureUrl ??
          'https://img.freepik.com/vector-gratis/circulo-azul-usuario-blanco_78370-4707.jpg?semt=ais_items_boosted&w=740',
      birthDate: birthDate,
      gender: EGender.fromString(gender),
      personalEmailAddress: personalEmailAddress ?? '',
      institutionalEmailAddress: institutionalEmailAddress ?? '',
      countryCode: countryCode ?? '+51',
      phoneNumber: phoneNumber ?? '',
      university: university ?? '',
      faculty: faculty ?? '',
      academicProgram: academicProgram ?? '',
      semester: semester ?? '',
      classSchedules: const [],
    );
  }
}