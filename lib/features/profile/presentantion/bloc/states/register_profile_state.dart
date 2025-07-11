import 'package:equatable/equatable.dart';
import 'package:uniride_driver/core/utils/resource.dart';
import 'package:uniride_driver/features/auth/domain/entities/user.dart';
import 'package:uniride_driver/features/profile/presentantion/bloc/states/current_class_schedule_state.dart';
import 'package:uniride_driver/features/profile/presentantion/bloc/states/profile_form_state.dart';
import 'package:uniride_driver/features/home/domain/entities/place_prediction.dart';

class RegisterProfileState extends Equatable {
  final ProfileFormState profileState;
  final CurrentClassScheduleState currentClassScheduleState;
  final User? user;
  final bool isLoading;
  final Resource<void>? registerProfileResponse;
  final int nextRecommendedStep;
  final bool isTermsAccepted;
  final bool isScheduleDialogOpen;
  final bool isRegisteredProfileSuccess;
  final List<Prediction> locationPredictions;

  // Vehicle information
  final String vehicleBrand;
  final String vehicleModel;
  final int vehicleYear;
  final String vehicleLicensePlate;

  const RegisterProfileState({
    this.profileState = const ProfileFormState(),
    this.currentClassScheduleState = const CurrentClassScheduleState(),
    this.user,
    this.isLoading = false,
    this.registerProfileResponse,
    this.nextRecommendedStep = 0,
    this.isTermsAccepted = false,
    this.isScheduleDialogOpen = false,
    this.isRegisteredProfileSuccess = false,
    this.locationPredictions = const [],
    this.vehicleBrand = '',
    this.vehicleModel = '',
    this.vehicleYear = 2020,
    this.vehicleLicensePlate = '',
  });

  // Validation computed properties
  bool get isFullNameRegisterValid =>
      profileState.firstName.isNotEmpty && profileState.lastName.isNotEmpty;

  bool get isTermsAcceptedValid => isTermsAccepted;

  bool get isPersonalInformationRegisterValid =>
      profileState.firstName.isNotEmpty &&
          profileState.lastName.isNotEmpty &&
          profileState.birthDate != null;

  bool get isContactInformationRegisterValid =>
      _isValidPersonalEmailAddress() &&
          profileState.countryCode.isNotEmpty &&
          _isValidPhoneNumber();

  bool get isAcademicInformationRegisterValid =>
      profileState.university.isNotEmpty &&
          profileState.faculty.isNotEmpty &&
          profileState.academicProgram.isNotEmpty &&
          _isValidSemester();

  bool get isVehicleInformationRegisterValid =>
      vehicleBrand.isNotEmpty &&
          vehicleModel.isNotEmpty &&
          vehicleYear >= 1900 &&
          vehicleYear <= DateTime.now().year + 1 &&
          vehicleLicensePlate.isNotEmpty &&
          _isValidLicensePlate();

  bool get isCurrentClassScheduleValid =>
      currentClassScheduleState.courseName.isNotEmpty &&
          currentClassScheduleState.startedAt != null &&
          currentClassScheduleState.endedAt != null &&
          currentClassScheduleState.selectedDay != null &&
          currentClassScheduleState.selectedLocation != null;

  bool get isRegisterProfileValid =>
      isFullNameRegisterValid &&
          isTermsAcceptedValid &&
          isPersonalInformationRegisterValid &&
          isContactInformationRegisterValid &&
          isAcademicInformationRegisterValid &&
          isVehicleInformationRegisterValid;

  bool _isValidPersonalEmailAddress() {
    final email = profileState.personalEmailAddress;
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return email.isNotEmpty && emailRegex.hasMatch(email);
  }

  bool _isValidPhoneNumber() {
    final phone = profileState.phoneNumber;
    final phoneRegex = RegExp(r'^\d{9}$');
    return phone.isNotEmpty && phoneRegex.hasMatch(phone);
  }

  bool _isValidSemester() {
    final sem = profileState.semester;
    final semesterRegex = RegExp(r'^\d{4}-\d{2}$');
    return sem.isNotEmpty && semesterRegex.hasMatch(sem);
  }

  bool _isValidLicensePlate() {
    final plate = vehicleLicensePlate.trim();
    // Formato peruano: ABC-123 o ABC1234
    final plateRegex = RegExp(r'^[A-Z]{3}-?\d{3,4}$');
    return plate.isNotEmpty && plateRegex.hasMatch(plate.toUpperCase());
  }

  RegisterProfileState copyWith({
    ProfileFormState? profileState,
    CurrentClassScheduleState? currentClassScheduleState,
    User? user,
    bool? isLoading,
    Resource<void>? registerProfileResponse,
    int? nextRecommendedStep,
    bool? isTermsAccepted,
    bool? isScheduleDialogOpen,
    bool? isRegisteredProfileSuccess,
    List<Prediction>? locationPredictions,
    String? vehicleBrand,
    String? vehicleModel,
    int? vehicleYear,
    String? vehicleLicensePlate,
  }) {
    return RegisterProfileState(
      profileState: profileState ?? this.profileState,
      currentClassScheduleState: currentClassScheduleState ?? this.currentClassScheduleState,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      registerProfileResponse: registerProfileResponse ?? this.registerProfileResponse,
      nextRecommendedStep: nextRecommendedStep ?? this.nextRecommendedStep,
      isTermsAccepted: isTermsAccepted ?? this.isTermsAccepted,
      isScheduleDialogOpen: isScheduleDialogOpen ?? this.isScheduleDialogOpen,
      isRegisteredProfileSuccess: isRegisteredProfileSuccess ?? this.isRegisteredProfileSuccess,
      locationPredictions: locationPredictions ?? this.locationPredictions,
      vehicleBrand: vehicleBrand ?? this.vehicleBrand,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      vehicleYear: vehicleYear ?? this.vehicleYear,
      vehicleLicensePlate: vehicleLicensePlate ?? this.vehicleLicensePlate,
    );
  }

  @override
  List<Object?> get props => [
    profileState,
    currentClassScheduleState,
    user,
    isLoading,
    registerProfileResponse,
    nextRecommendedStep,
    isTermsAccepted,
    isScheduleDialogOpen,
    isRegisteredProfileSuccess,
    locationPredictions,
    vehicleBrand,
    vehicleModel,
    vehicleYear,
    vehicleLicensePlate,
  ];
}