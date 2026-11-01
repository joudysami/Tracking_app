import 'package:tracking_app/core/helpers/app_validation.dart';
import 'package:tracking_app/features/profile/presentation/change_password/view_model/change_password_state.dart';

bool canChangePassword(ChangePasswordState state) {
  if (state.isLoading) return false;
  if (!_valid(
    state.currentPassword,
    AppValidators.registrationPasswordValidator,
  )) {
    return false;
  }
  if (!_valid(state.newPassword, AppValidators.passwordValidator)) return false;
  return state.confirmPassword == state.newPassword;
}

bool _valid(String value, String? Function(String?) validate) {
  if (value.isEmpty) return false;
  return validate(value) == null;
}
