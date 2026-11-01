import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/features/profile/domain/entities/profile_params.dart';
import 'package:tracking_app/features/profile/domain/use_cases/change_password_use_case.dart';
import 'package:tracking_app/features/profile/presentation/change_password/change_password_rules.dart';

import 'change_password_event.dart';
import 'change_password_state.dart';
import 'change_password_ui_event.dart';

@injectable
class ChangePasswordViewModel extends Cubit<ChangePasswordState> {
  ChangePasswordViewModel(this._changePassword)
    : super(const ChangePasswordState());

  final ChangePasswordUseCase _changePassword;
  final _ui = StreamController<ChangePasswordUiEvent>.broadcast(sync: true);

  Stream<ChangePasswordUiEvent> get uiEvents => _ui.stream;

  Future<void> doEvent(ChangePasswordEvent event) async {
    switch (event) {
      case CurrentPasswordChanged(:final value):
        emit(
          state.copyWith(currentPassword: value, invalidCurrentPassword: false),
        );
      case NewPasswordChanged(:final value):
        emit(state.copyWith(newPassword: value));
      case ConfirmPasswordChanged(:final value):
        emit(state.copyWith(confirmPassword: value));
      case ChangePasswordSubmitted():
        await _submit();
    }
  }

  Future<void> _submit() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true, invalidCurrentPassword: false));
    _emitResult(await _changePassword(_params()));
  }

  ChangePasswordParams _params() {
    return ChangePasswordParams(
      currentPassword: state.currentPassword,
      newPassword: state.newPassword,
      confirmPassword: state.confirmPassword,
    );
  }

  void _emitResult(BaseResponse<void> result) {
    switch (result) {
      case SuccessResponse():
        emit(state.copyWith(isLoading: false));
        _ui.add(const PasswordChanged());
      case ErrorResponse(:final errorMessage):
        _failed(errorMessage);
    }
  }

  void _failed(String message) {
    final invalid = isCurrentPasswordError(message);
    emit(state.copyWith(isLoading: false, invalidCurrentPassword: invalid));
    if (!invalid) _ui.add(ShowChangePasswordError(message));
  }

  @override
  Future<void> close() async {
    await _ui.close();
    return super.close();
  }
}
