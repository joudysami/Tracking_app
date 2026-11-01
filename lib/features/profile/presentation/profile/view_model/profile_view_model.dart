import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/base/base_state.dart';
import 'package:tracking_app/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tracking_app/features/profile/domain/entities/vehicle_info_entity.dart';
import 'package:tracking_app/features/profile/domain/use_cases/get_profile_use_case.dart';
import 'package:tracking_app/features/profile/domain/use_cases/get_vehicle_info_use_case.dart';
import 'package:tracking_app/features/profile/domain/use_cases/logout_session_use_case.dart';

import 'profile_event.dart';
import 'profile_state.dart';
import 'profile_ui_event.dart';

@injectable
class ProfileViewModel extends Cubit<ProfileState> {
  ProfileViewModel(this._getProfile, this._getVehicle, this._logout)
    : super(const ProfileState());

  final GetProfileUseCase _getProfile;
  final GetVehicleInfoUseCase _getVehicle;
  final LogoutSessionUseCase _logout;
  final _ui = StreamController<ProfileUiEvent>.broadcast(sync: true);

  Stream<ProfileUiEvent> get uiEvents => _ui.stream;

  Future<void> doEvent(ProfileEvent event) async {
    switch (event) {
      case ProfileRequested():
        await _load();
      case LogoutConfirmed():
        await _logoutSession();
    }
  }

  Future<void> _load() async {
    emit(_loading());
    final profile = _profileState(await _getProfile());
    final vehicle = await _vehicleState(profile.data != null);
    emit(state.copyWith(profile: profile, vehicle: vehicle));
  }

  Future<BaseState<VehicleInfoEntity>> _vehicleState(bool load) async {
    if (!load) return const BaseState();
    return _vehicleData(await _getVehicle());
  }

  ProfileState _loading() {
    return state.copyWith(
      profile: state.profile.copyWith(isLoading: true, errorMessage: ''),
    );
  }

  BaseState<UserProfileEntity> _profileState(
    BaseResponse<UserProfileEntity> result,
  ) {
    return switch (result) {
      SuccessResponse(:final data) => BaseState(data: data),
      ErrorResponse(:final errorMessage) => BaseState(
        errorMessage: errorMessage,
      ),
    };
  }

  Future<void> _logoutSession() async {
    emit(state.copyWith(isLoggingOut: true));
    await _logout();
    emit(state.copyWith(isLoggingOut: false));
    _ui.add(const LoggedOut());
  }

  @override
  Future<void> close() async {
    await _ui.close();
    return super.close();
  }
}

BaseState<VehicleInfoEntity> _vehicleData(
  BaseResponse<VehicleInfoEntity> result,
) {
  return switch (result) {
    SuccessResponse(:final data) => BaseState(data: data),
    ErrorResponse() => const BaseState(),
  };
}
