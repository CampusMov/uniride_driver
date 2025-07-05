import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/enum_day.dart';
import '../../domain/entities/enum_gender.dart';

abstract class RegisterProfileEvent extends Equatable {
  const RegisterProfileEvent();

  @override
  List<Object?> get props => [];
}

// User loading event
class LoadUserLocally extends RegisterProfileEvent {
  const LoadUserLocally();
}

// Profile form events
class FirstNameChanged extends RegisterProfileEvent {
  final String firstName;

  const FirstNameChanged(this.firstName);

  @override
  List<Object?> get props => [firstName];
}

class LastNameChanged extends RegisterProfileEvent {
  final String lastName;

  const LastNameChanged(this.lastName);

  @override
  List<Object?> get props => [lastName];
}

class BirthDateChanged extends RegisterProfileEvent {
  final DateTime birthDate;

  const BirthDateChanged(this.birthDate);

  @override
  List<Object?> get props => [birthDate];
}

class GenderChanged extends RegisterProfileEvent {
  final EGender gender;

  const GenderChanged(this.gender);

  @override
  List<Object?> get props => [gender];
}

class PersonalEmailChanged extends RegisterProfileEvent {
  final String email;

  const PersonalEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class PhoneNumberChanged extends RegisterProfileEvent {
  final String phoneNumber;

  const PhoneNumberChanged(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class UniversityChanged extends RegisterProfileEvent {
  final String university;

  const UniversityChanged(this.university);

  @override
  List<Object?> get props => [university];
}

class FacultyChanged extends RegisterProfileEvent {
  final String faculty;

  const FacultyChanged(this.faculty);

  @override
  List<Object?> get props => [faculty];
}

class AcademicProgramChanged extends RegisterProfileEvent {
  final String academicProgram;

  const AcademicProgramChanged(this.academicProgram);

  @override
  List<Object?> get props => [academicProgram];
}

class SemesterChanged extends RegisterProfileEvent {
  final String semester;

  const SemesterChanged(this.semester);

  @override
  List<Object?> get props => [semester];
}

class TermsAcceptedChanged extends RegisterProfileEvent {
  final bool isAccepted;

  const TermsAcceptedChanged(this.isAccepted);

  @override
  List<Object?> get props => [isAccepted];
}

class NextStepChanged extends RegisterProfileEvent {
  final int nextStep;

  const NextStepChanged(this.nextStep);

  @override
  List<Object?> get props => [nextStep];
}

// File upload events
class UploadProfileImage extends RegisterProfileEvent {
  final Uri uri;

  const UploadProfileImage(this.uri);

  @override
  List<Object?> get props => [uri];
}

// Profile save event
class SaveProfile extends RegisterProfileEvent {
  const SaveProfile();
}

// Class Schedule Events
class OpenDialogToAddNewSchedule extends RegisterProfileEvent {
  const OpenDialogToAddNewSchedule();
}

class OpenDialogToEditSchedule extends RegisterProfileEvent {
  final String index;

  const OpenDialogToEditSchedule(this.index);

  @override
  List<Object?> get props => [index];
}

class CloseScheduleDialog extends RegisterProfileEvent {
  const CloseScheduleDialog();
}

class ScheduleCourseNameChanged extends RegisterProfileEvent {
  final String courseName;

  const ScheduleCourseNameChanged(this.courseName);

  @override
  List<Object?> get props => [courseName];
}

class ScheduleStartTimeChanged extends RegisterProfileEvent {
  final TimeOfDay startTime;

  const ScheduleStartTimeChanged(this.startTime);

  @override
  List<Object?> get props => [startTime];
}

class ScheduleEndTimeChanged extends RegisterProfileEvent {
  final TimeOfDay endTime;

  const ScheduleEndTimeChanged(this.endTime);

  @override
  List<Object?> get props => [endTime];
}

class ScheduleDaySelected extends RegisterProfileEvent {
  final EDay day;

  const ScheduleDaySelected(this.day);

  @override
  List<Object?> get props => [day];
}

class ScheduleLocationQueryChanged extends RegisterProfileEvent {
  final String query;

  const ScheduleLocationQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class ScheduleLocationSelected extends RegisterProfileEvent {
  // final PlacePrediction placePrediction;
  //
  // const ScheduleLocationSelected(this.placePrediction);
  //
  // @override
  // List<Object?> get props => [placePrediction];
}

class ScheduleLocationCleared extends RegisterProfileEvent {
  const ScheduleLocationCleared();
}

class AddClassScheduleToProfile extends RegisterProfileEvent {
  const AddClassScheduleToProfile();
}

class EditExistingClassSchedule extends RegisterProfileEvent {
  const EditExistingClassSchedule();
}

class DeleteSchedule extends RegisterProfileEvent {
  const DeleteSchedule();
}