import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/resource.dart';
import '../../../../auth/domain/repositories/user_repository.dart';
import '../../../../profile/domain/entities/profile.dart';
import '../../../../profile/domain/repositories/profile_repository.dart';
import 'drawer_menu_event.dart';
import 'drawer_menu_state.dart';

class DrawerMenuBloc extends Bloc<DrawerMenuEvent, DrawerMenuState> {
  final UserRepository userRepository;
  final ProfileRepository profileRepository;

  DrawerMenuBloc({
    required this.userRepository,
    required this.profileRepository,
  }) : super(const DrawerMenuState()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<LogoutUser>(_onLogoutUser);
  }

  void _onLoadUserProfile(LoadUserProfile event, Emitter<DrawerMenuState> emit) async {
    emit(state.copyWith(status: DrawerMenuStatus.loading));

    try {
      final user = await userRepository.getUserLocally();

      if (user == null) {
        log('TAG: DrawerMenuBloc: No user found locally');
        emit(state.copyWith(
          status: DrawerMenuStatus.error,
          errorMessage: 'No user found locally',
        ));
        return;
      }

      log('TAG: DrawerMenuBloc: User loaded locally: ${user.email}');

      final profileResult = await profileRepository.getProfileById(user.id);

      switch (profileResult) {
        case Success<Profile>():
          log('TAG: DrawerMenuBloc: Profile loaded successfully for user: ${user.email}');
          emit(state.copyWith(
            status: DrawerMenuStatus.loaded,
            user: user,
            profile: profileResult.data,
          ));
          break;
        case Failure<Profile>():
          log('TAG: DrawerMenuBloc: Error loading profile: ${profileResult.message}');
          emit(state.copyWith(
            status: DrawerMenuStatus.error,
            user: user,
            errorMessage: profileResult.message,
          ));
          break;
        case Loading<Profile>():
        // El estado ya está en loading
          break;
      }
    } catch (e) {
      log('TAG: DrawerMenuBloc: Error loading user profile: $e');
      emit(state.copyWith(
        status: DrawerMenuStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onLogoutUser(LogoutUser event, Emitter<DrawerMenuState> emit) async {
    emit(state.copyWith(status: DrawerMenuStatus.loggingOut));

    try {
      await userRepository.deleteAllUsersLocally();

      log('TAG: DrawerMenuBloc: User data deleted successfully');

      emit(state.copyWith(
        status: DrawerMenuStatus.loggedOut,
        logoutResult: const Success(null),
        user: null,
        profile: null,
      ));
    } catch (e) {
      log('TAG: DrawerMenuBloc: Error during logout: $e');
      emit(state.copyWith(
        status: DrawerMenuStatus.error,
        errorMessage: 'Error during logout: $e',
        logoutResult: Failure(e.toString()),
      ));
    }
  }
}