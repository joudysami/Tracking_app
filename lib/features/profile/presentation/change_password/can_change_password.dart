import 'package:tracking_app/core/helpers/app_validation.dart';
import 'package:tracking_app/features/profile/presentation/change_password/view_model/change_password_state.dart';

bool canChangePassword(ChangePasswordState state) {
  if (state.isLoading || state.invalidCurrentPassword) return false;
  if (state.currentPassword.isEmpty) return false;
  if (AppValidators.passwordValidator(state.newPassword) != null) {
    return false;
  }
  return state.confirmPassword == state.newPassword;
}
