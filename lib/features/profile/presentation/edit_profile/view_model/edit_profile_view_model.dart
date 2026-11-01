import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/base/base_state.dart';
import 'package:tracking_app/core/services/image_picker_service.dart';
import 'package:tracking_app/features/auth/domain/entities/gender.dart';
import 'package:tracking_app/features/profile/domain/entities/profile_params.dart';
import 'package:tracking_app/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tracking_app/features/profile/domain/use_cases/get_profile_use_case.dart';
import 'package:tracking_app/features/profile/domain/use_cases/update_profile_use_case.dart';

import 'edit_profile_event.dart';
import 'edit_profile_state.dart';
import 'edit_profile_ui_event.dart';

const _emptyProfile = 'The profile response is empty.';

@injectable
class EditProfileViewModel extends Cubit<EditProfileState> {
  EditProfileViewModel(this._getProfile, this._updateProfile, this._images)
    : super(const EditProfileState());

  final GetProfileUseCase _getProfile;
  final UpdateProfileUseCase _updateProfile;
  final ImagePickerService _images;
  final _ui = StreamController<EditProfileUiEvent>.broadcast(sync: true);

  Stream<EditProfileUiEvent> get uiEvents => _ui.stream;

  Future<void> doEvent(EditProfileEvent event) async {
    switch (event) {
      case EditProfileStarted():
        await _load();
      case UpdateProfileRequested():
        await _update();
      case PhotoPickRequested():
        await _pickPhoto();
      default:
        _changeField(event);
    }
  }

  void _changeField(EditProfileEvent event) {
    switch (event) {
      case FirstNameChanged(:final value):
        emit(state.copyWith(firstName: value));
      case LastNameChanged(:final value):
        emit(state.copyWith(lastName: value));
      case EmailChanged(:final value):
        emit(state.copyWith(email: value));
      case PhoneChanged(:final value):
        emit(state.copyWith(phone: value));
      case GenderChanged(:final value):
        emit(state.copyWith(gender: value));
      default:
        break;
    }
  }

  Future<void> _load() async {
    emit(state.copyWith(profile: const BaseState(isLoading: true)));
    emit(_afterLoad(await _getProfile()));
  }

  EditProfileState _afterLoad(BaseResponse<UserProfileEntity> result) {
    return switch (result) {
      SuccessResponse(:final data) => _seed(data),
      ErrorResponse(:final errorMessage) => state.copyWith(
        profile: BaseState(errorMessage: errorMessage),
      ),
    };
  }

  EditProfileState _seed(UserProfileEntity? profile) {
    if (profile == null) return _empty();
    return state.copyWith(
      profile: BaseState(data: profile),
      firstName: profile.firstName,
      lastName: profile.lastName,
      email: profile.email,
      phone: profile.phoneNumber,
      gender: profile.gender,
    );
  }

  EditProfileState _empty() {
    return state.copyWith(
      profile: const BaseState(errorMessage: _emptyProfile),
    );
  }

  Future<void> _pickPhoto() async {
    final image = await _images.pickImage();
    if (image == null) return;
    emit(state.copyWith(photoPath: image.path));
  }

  Future<void> _update() async {
    final gender = state.gender;
    if (gender == null || state.submit.isLoading) return;
    emit(state.copyWith(submit: const BaseState(isLoading: true)));
    _emitUpdate(await _updateProfile(_params(gender)));
  }

  UpdateProfileParams _params(Gender gender) {
    return UpdateProfileParams(
      firstName: state.firstName.trim(),
      lastName: state.lastName.trim(),
      phoneNumber: state.phone.trim(),
      gender: gender,
      photoPath: state.photoPath,
    );
  }

  void _emitUpdate(BaseResponse<UserProfileEntity> result) {
    switch (result) {
      case SuccessResponse(:final data):
        _saved(data);
      case ErrorResponse(:final errorMessage):
        emit(state.copyWith(submit: const BaseState()));
        _ui.add(ShowEditProfileError(errorMessage));
    }
  }

  void _saved(UserProfileEntity? data) {
    emit(state.copyWith(submit: BaseState(data: data)));
    _ui.add(const EditProfileSaved());
  }

  @override
  Future<void> close() async {
    await _ui.close();
    return super.close();
  }
}
