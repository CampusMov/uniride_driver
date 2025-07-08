
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniride_driver/core/utils/resource.dart';
import 'package:uniride_driver/features/auth/domain/entities/user.dart';
import 'package:uniride_driver/features/auth/domain/repositories/auth_repository.dart';
import 'package:uniride_driver/features/auth/domain/repositories/user_repository.dart';
import 'package:uniride_driver/features/onboarding/presentation/blocs/skip_login_event.dart';
import 'package:uniride_driver/features/onboarding/presentation/blocs/skip_login_state.dart';

class SkipLoginBloc extends Bloc<SkipLoginEvent, SkipLoginState> {
  final UserRepository userRepository;
  final AuthRepository authRepository;

  SkipLoginBloc({
    required this.userRepository,
    required this.authRepository,
  }) : super(const SkipLoginState()) {
    on<LoadUserLocally>(_onLoadUserLocally);
    on<LoadUserById>(_onLoadUserById);
  }

  Future<void> _onLoadUserLocally(LoadUserLocally event, Emitter<SkipLoginState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final user = await userRepository.getUserLocally();
    if (user != null) {
      log('TAG: skipLoginBloc - local user found: ${user.id}');
      add(LoadUserById(user.id));
    } else {
      log('TAG: skipLoginBloc - local user is null');
      emit(state.copyWith(isLoading: false, errorMessage: 'No hay usuario local'));
    }
  }


  Future<void> _onLoadUserById(LoadUserById event, Emitter<SkipLoginState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final resource = await authRepository.getUserById(event.userId);

    if (resource is Success<User>) {
      log('TAG: skipLoginBloc - user found in backend: ${resource.data.id}');
      emit(state.copyWith(
        isLoading: false,
        isUserLoaded: true,
        user: resource.data,
        errorMessage: null,
      ));
    } else if (resource is Failure<User>) {
      log('TAG: skipLoginBloc - user not found in backend: ${resource.message}');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: resource.message,
        isUserLoaded: false,
        user: null,
      ));
    } else {
      emit(state.copyWith(isLoading: false, errorMessage: 'Error desconocido'));
    }
  }

}



