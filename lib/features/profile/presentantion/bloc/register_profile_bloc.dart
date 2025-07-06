import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniride_driver/features/profile/presentantion/bloc/register_profile_event.dart';
import 'package:uniride_driver/features/profile/presentantion/bloc/states/current_class_schedule_state.dart';
import 'package:uniride_driver/features/profile/presentantion/bloc/states/register_profile_state.dart';

import '../../../../core/utils/resource.dart';
import '../../../auth/domain/repositories/user_repository.dart';
import '../../../file/domain/repositories/file_management_repository.dart';
import '../../../shared/domain/entities/location.dart';
import '../../../home/data/repositories/location_repository.dart';
import '../../domain/entities/class_schedule.dart';
import '../../domain/repositories/profile_repository.dart';

class RegisterProfileBloc extends Bloc<RegisterProfileEvent, RegisterProfileState> {
  final ProfileRepository profileRepository;
  final UserRepository userRepository;
  final FileManagementRepository fileManagementRepository;
  final LocationRepository locationRepository;

  RegisterProfileBloc({
    required this.profileRepository,
    required this.userRepository,
    required this.fileManagementRepository,
    required this.locationRepository,
  }) : super(const RegisterProfileState()) {
    on<LoadUserLocally>(_onLoadUserLocally);
    on<FirstNameChanged>(_onFirstNameChanged);
    on<LastNameChanged>(_onLastNameChanged);
    on<BirthDateChanged>(_onBirthDateChanged);
    on<GenderChanged>(_onGenderChanged);
    on<PersonalEmailChanged>(_onPersonalEmailChanged);
    on<PhoneNumberChanged>(_onPhoneNumberChanged);
    on<UniversityChanged>(_onUniversityChanged);
    on<FacultyChanged>(_onFacultyChanged);
    on<AcademicProgramChanged>(_onAcademicProgramChanged);
    on<SemesterChanged>(_onSemesterChanged);
    on<TermsAcceptedChanged>(_onTermsAcceptedChanged);
    on<NextStepChanged>(_onNextStepChanged);
    on<UploadProfileImage>(_onUploadProfileImage);
    on<SaveProfile>(_onSaveProfile);

    // Class Schedule Events
    on<OpenDialogToAddNewSchedule>(_onOpenDialogToAddNewSchedule);
    on<OpenDialogToEditSchedule>(_onOpenDialogToEditSchedule);
    on<CloseScheduleDialog>(_onCloseScheduleDialog);
    on<ScheduleCourseNameChanged>(_onScheduleCourseNameChanged);
    on<ScheduleStartTimeChanged>(_onScheduleStartTimeChanged);
    on<ScheduleEndTimeChanged>(_onScheduleEndTimeChanged);
    on<ScheduleDaySelected>(_onScheduleDaySelected);
    on<ScheduleLocationQueryChanged>(_onScheduleLocationQueryChanged);
    on<ScheduleLocationSelected>(_onScheduleLocationSelected);
    on<ScheduleLocationCleared>(_onScheduleLocationCleared);
    on<AddClassScheduleToProfile>(_onAddClassScheduleToProfile);
    on<EditExistingClassSchedule>(_onEditExistingClassSchedule);
    on<DeleteSchedule>(_onDeleteSchedule);

    // Initialize by loading user locally
    add(const LoadUserLocally());
  }

  void _onLoadUserLocally(LoadUserLocally event, Emitter<RegisterProfileState> emit) async {
    try {
      final result = await userRepository.getUserLocally();
      if (result != null) {
        log('TAG: RegisterProfileBloc: User loaded locally: ${result.email}');
        emit(state.copyWith(
          user: result,
          profileState: state.profileState.copyWith(
            userId: result.id,
            institutionalEmailAddress: result.email,
          ),
        ));
      }
    } catch (e) {
      log('TAG: RegisterProfileBloc: Error loading user locally: $e');
    }
  }

  void _onFirstNameChanged(FirstNameChanged event, Emitter<RegisterProfileState> emit) {
    emit(state.copyWith(
      profileState: state.profileState.copyWith(firstName: event.firstName),
    ));
  }

  void _onLastNameChanged(LastNameChanged event, Emitter<RegisterProfileState> emit) {
    emit(state.copyWith(
      profileState: state.profileState.copyWith(lastName: event.lastName),
    ));
  }

  void _onBirthDateChanged(BirthDateChanged event, Emitter<RegisterProfileState> emit) {
    emit(state.copyWith(
      profileState: state.profileState.copyWith(birthDate: event.birthDate),
    ));
  }

  void _onGenderChanged(GenderChanged event, Emitter<RegisterProfileState> emit) {
    emit(state.copyWith(
      profileState: state.profileState.copyWith(gender: event.gender),
    ));
  }

  void _onPersonalEmailChanged(PersonalEmailChanged event, Emitter<RegisterProfileState> emit) {
    emit(state.copyWith(
      profileState: state.profileState.copyWith(personalEmailAddress: event.email),
    ));
  }

  void _onPhoneNumberChanged(PhoneNumberChanged event, Emitter<RegisterProfileState> emit) {
    emit(state.copyWith(
      profileState: state.profileState.copyWith(phoneNumber: event.phoneNumber),
    ));
  }

  void _onUniversityChanged(UniversityChanged event, Emitter<RegisterProfileState> emit) {
    emit(state.copyWith(
      profileState: state.profileState.copyWith(university: event.university),
    ));
  }

  void _onFacultyChanged(FacultyChanged event, Emitter<RegisterProfileState> emit) {
    emit(state.copyWith(
      profileState: state.profileState.copyWith(faculty: event.faculty),
    ));
  }

  void _onAcademicProgramChanged(AcademicProgramChanged event, Emitter<RegisterProfileState> emit) {
    emit(state.copyWith(
      profileState: state.profileState.copyWith(academicProgram: event.academicProgram),
    ));
  }

  void _onSemesterChanged(SemesterChanged event, Emitter<RegisterProfileState> emit) {
    emit(state.copyWith(
      profileState: state.profileState.copyWith(semester: event.semester),
    ));
  }

  void _onTermsAcceptedChanged(TermsAcceptedChanged event, Emitter<RegisterProfileState> emit) {
    emit(state.copyWith(isTermsAccepted: event.isAccepted));
  }

  void _onNextStepChanged(NextStepChanged event, Emitter<RegisterProfileState> emit) {
    emit(state.copyWith(nextRecommendedStep: event.nextStep));
  }

  void _onUploadProfileImage(UploadProfileImage event, Emitter<RegisterProfileState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      final fileName = state.user?.id ??
          '${state.profileState.firstName}_${state.profileState.lastName}';
      final result = await fileManagementRepository.uploadImage(
        event.uri,
        'profile_driver_images',
        fileName,
      );

      switch (result) {
        case Success<String>():
          emit(state.copyWith(
            isLoading: false,
            profileState: state.profileState.copyWith(profilePictureUrl: result.data),
          ));
          break;
        case Failure<String>():
          log('TAG: RegisterProfileBloc: Error uploading profile image: ${result.message}');
          emit(state.copyWith(isLoading: false));
          break;
        case Loading<String>():
          break;
      }
    } catch (e) {
      log('TAG: RegisterProfileBloc: Error uploading profile image: $e');
      emit(state.copyWith(isLoading: false));
    }
  }

  void _onSaveProfile(SaveProfile event, Emitter<RegisterProfileState> emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      final result = await profileRepository.saveProfile(state.profileState.toDomain());

      switch (result) {
        case Success<void>():
          log('TAG: RegisterProfileBloc: Profile saved successfully');
          emit(state.copyWith(
              isLoading: false,
              registerProfileResponse: const Success(null),
              isRegisteredProfileSuccess: true
          ));
          break;
        case Failure<void>():
          log('TAG: RegisterProfileBloc: Error saving profile: ${result.message}');
          emit(state.copyWith(
            isLoading: false,
            registerProfileResponse: Failure(result.message),
            isRegisteredProfileSuccess: false,
          ));
          break;
        case Loading<void>():
          break;
      }
    } catch (e) {
      log('TAG: RegisterProfileBloc: Error saving profile: $e');
      emit(state.copyWith(
        isLoading: false,
        registerProfileResponse: Failure(e.toString()),
      ));
    }
  }

  void _onOpenDialogToAddNewSchedule(OpenDialogToAddNewSchedule event, Emitter<RegisterProfileState> emit) {
    emit(state.copyWith(
      currentClassScheduleState: const CurrentClassScheduleState(),
      isScheduleDialogOpen: true,
      locationPredictions: [],
    ));
  }

  void _onOpenDialogToEditSchedule(OpenDialogToEditSchedule event, Emitter<RegisterProfileState> emit) {
    final selectedClassSchedule = state.profileState.classSchedules
        .where((schedule) => schedule.id == event.index)
        .firstOrNull;

    if (selectedClassSchedule == null) {
      log('TAG: RegisterProfileBloc: Invalid schedule index: ${event.index}');
      return;
    }

    emit(state.copyWith(
      currentClassScheduleState: state.currentClassScheduleState.copyWith(
        isEditing: true,
        editingIndex: event.index,
        courseName: selectedClassSchedule.courseName,
        selectedLocation: Location(
          name: selectedClassSchedule.locationName,
          latitude: selectedClassSchedule.latitude,
          longitude: selectedClassSchedule.longitude,
          address: selectedClassSchedule.address,
        ),
        startedAt: selectedClassSchedule.startedAt,
        endedAt: selectedClassSchedule.endedAt,
        selectedDay: selectedClassSchedule.selectedDay,
      ),
      isScheduleDialogOpen: true,
      locationPredictions: [],
    ));
  }

  void _onCloseScheduleDialog(CloseScheduleDialog event, Emitter<RegisterProfileState> emit) {
    emit(state.copyWith(
      currentClassScheduleState: const CurrentClassScheduleState(),
      isScheduleDialogOpen: false,
      locationPredictions: [],
    ));
  }

  void _onScheduleCourseNameChanged(ScheduleCourseNameChanged event, Emitter<RegisterProfileState> emit) {
    emit(state.copyWith(
      currentClassScheduleState: state.currentClassScheduleState.copyWith(
        courseName: event.courseName,
      ),
    ));
  }

  void _onScheduleStartTimeChanged(ScheduleStartTimeChanged event, Emitter<RegisterProfileState> emit) {
    if (state.currentClassScheduleState.endedAt != null &&
        event.startTime.isAfter(state.currentClassScheduleState.endedAt!)) {
      log('TAG: RegisterProfileBloc: Start time cannot be after end time');
      return;
    }

    emit(state.copyWith(
      currentClassScheduleState: state.currentClassScheduleState.copyWith(
        startedAt: event.startTime,
      ),
    ));
  }

  void _onScheduleEndTimeChanged(ScheduleEndTimeChanged event, Emitter<RegisterProfileState> emit) {
    if (state.currentClassScheduleState.startedAt != null &&
        event.endTime.isBefore(state.currentClassScheduleState.startedAt!)) {
      log('TAG: RegisterProfileBloc: End time cannot be before start time');
      return;
    }

    emit(state.copyWith(
      currentClassScheduleState: state.currentClassScheduleState.copyWith(
        endedAt: event.endTime,
      ),
    ));
  }

  void _onScheduleDaySelected(ScheduleDaySelected event, Emitter<RegisterProfileState> emit) {
    emit(state.copyWith(
      currentClassScheduleState: state.currentClassScheduleState.copyWith(
        selectedDay: event.day,
      ),
    ));
  }

  void _onScheduleLocationQueryChanged(ScheduleLocationQueryChanged event, Emitter<RegisterProfileState> emit) async {
    if (event.query.isEmpty) {
      emit(state.copyWith(locationPredictions: []));
      return;
    }

    try {
      final predictions = await locationRepository.searchLocation(event.query);
      log('TAG: RegisterProfileBloc: Found ${predictions.length} location predictions');
      emit(state.copyWith(locationPredictions: predictions));
    } catch (e) {
      log('TAG: RegisterProfileBloc: Error getting place predictions: $e');
      emit(state.copyWith(locationPredictions: []));
    }
  }

  void _onScheduleLocationSelected(ScheduleLocationSelected event, Emitter<RegisterProfileState> emit) async {
    try {
      final location = await locationRepository.getLocation(event.placePrediction.description);

      if (location != null) {
        final selectedLocation = Location(
          name: event.placePrediction.description,
          latitude: double.parse(location.latitude),
          longitude: double.parse(location.longitude),
          address: location.address,
        );

        log('TAG: RegisterProfileBloc: Location selected: ${selectedLocation.address}');

        emit(state.copyWith(
          currentClassScheduleState: state.currentClassScheduleState.copyWith(
            selectedLocation: selectedLocation,
          ),
          locationPredictions: [],
        ));
      } else {
        log('TAG: RegisterProfileBloc: Could not get location details');
      }
    } catch (e) {
      log('TAG: RegisterProfileBloc: Error getting place details: $e');
    }
  }

  void _onScheduleLocationCleared(ScheduleLocationCleared event, Emitter<RegisterProfileState> emit) {
    emit(state.copyWith(
      currentClassScheduleState: state.currentClassScheduleState.copyWith(
        selectedLocation: null,
      ),
      locationPredictions: [],
    ));
  }

  void _onAddClassScheduleToProfile(AddClassScheduleToProfile event, Emitter<RegisterProfileState> emit) {
    if (!_isCurrentClassScheduleValid()) {
      log('TAG: RegisterProfileBloc: Current class schedule is not valid');
      return;
    }

    final newClassSchedule = state.currentClassScheduleState.toDomain();
    final updatedSchedules = List<ClassSchedule>.from(state.profileState.classSchedules)
      ..add(newClassSchedule);

    emit(state.copyWith(
      profileState: state.profileState.copyWith(classSchedules: updatedSchedules),
      currentClassScheduleState: const CurrentClassScheduleState(),
      isScheduleDialogOpen: false,
      locationPredictions: [],
    ));
  }

  void _onEditExistingClassSchedule(EditExistingClassSchedule event, Emitter<RegisterProfileState> emit) {
    if (state.currentClassScheduleState.editingIndex == null) {
      log('TAG: RegisterProfileBloc: Editing index is null');
      return;
    }

    if (!_isCurrentClassScheduleValid()) {
      log('TAG: RegisterProfileBloc: Current class schedule is not valid');
      return;
    }

    final updatedClassSchedule = state.currentClassScheduleState.toDomain();
    final updatedSchedules = state.profileState.classSchedules.map((schedule) {
      return schedule.id == state.currentClassScheduleState.editingIndex
          ? updatedClassSchedule
          : schedule;
    }).toList();

    emit(state.copyWith(
      profileState: state.profileState.copyWith(classSchedules: updatedSchedules),
      currentClassScheduleState: const CurrentClassScheduleState(),
      isScheduleDialogOpen: false,
      locationPredictions: [],
    ));
  }

  void _onDeleteSchedule(DeleteSchedule event, Emitter<RegisterProfileState> emit) {
    if (state.currentClassScheduleState.editingIndex == null) {
      log('TAG: RegisterProfileBloc: Editing index is null');
      return;
    }

    final updatedSchedules = state.profileState.classSchedules
        .where((schedule) => schedule.id != state.currentClassScheduleState.editingIndex)
        .toList();

    emit(state.copyWith(
      profileState: state.profileState.copyWith(classSchedules: updatedSchedules),
      currentClassScheduleState: const CurrentClassScheduleState(),
      isScheduleDialogOpen: false,
    ));
  }

  bool _isCurrentClassScheduleValid() {
    final scheduleState = state.currentClassScheduleState;
    return scheduleState.courseName.isNotEmpty &&
        scheduleState.startedAt != null &&
        scheduleState.endedAt != null &&
        scheduleState.selectedDay != null &&
        scheduleState.selectedLocation != null;
  }
}

extension on TimeOfDay {
  bool isAfter(TimeOfDay other) {
    return hour > other.hour || (hour == other.hour && minute > other.minute);
  }

  bool isBefore(TimeOfDay other) {
    return hour < other.hour || (hour == other.hour && minute < other.minute);
  }
}