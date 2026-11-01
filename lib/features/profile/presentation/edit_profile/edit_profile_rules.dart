import 'package:tracking_app/core/helpers/app_validation.dart';
import 'package:tracking_app/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile/view_model/edit_profile_state.dart';

bool canUpdateProfile(EditProfileState state) {
  final saved = state.profile.data;
  if (!_ready(state) || saved == null || state.gender == null) return false;
  if (!_fieldsValid(state)) return false;
  return _isDirty(state, saved);
}

bool _ready(EditProfileState state) {
  return !state.profile.isLoading && !state.submit.isLoading;
}

bool _fieldsValid(EditProfileState state) {
  if (state.firstName.trim().isEmpty || state.lastName.trim().isEmpty) {
    return false;
  }
  if (AppValidators.emailValidator(state.email) != null) return false;
  return AppValidators.phoneValidator(state.phone) == null;
}

bool _isDirty(EditProfileState state, UserProfileEntity saved) {
  return state.firstName.trim() != saved.firstName ||
      state.lastName.trim() != saved.lastName ||
      state.phone.trim() != saved.phoneNumber ||
      state.gender != saved.gender ||
      _hasPhoto(state.photoPath);
}

bool _hasPhoto(String? path) => path != null && path.isNotEmpty;
