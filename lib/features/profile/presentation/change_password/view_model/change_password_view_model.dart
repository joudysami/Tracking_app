import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/features/profile/domain/entities/profile_params.dart';
import 'package:tracking_app/features/profile/domain/use_cases/change_password_use_case.dart';

import 'change_password_event.dart';
import 'change_password_state.dart';
import 'change_password_ui_event.dart';

@injectable
class ChangePasswordViewModel extends Cubit<ChangePasswordState> {
  ChangePasswordViewModel(this._changePasswordUseCase)
    : super(const ChangePasswordState());

  final ChangePasswordUseCase _changePasswordUseCase;
  final _ui = StreamController<ChangePasswordUiEvent>.broadcast(sync: true);

  Stream<ChangePasswordUiEvent> get uiEvents => _ui.stream;

  Future<void> doEvent(ChangePasswordEvent event) async {
    switch (event) {
      case CurrentPasswordChanged(:final value):
        emit(state.copyWith(currentPassword: value));
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
    emit(state.copyWith(isLoading: true));
    _emitResult(await _changePasswordUseCase(_params()));
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
        emit(state.copyWith(isLoading: false));
        _ui.add(ShowChangePasswordError(errorMessage));
    }
  }

  @override
  Future<void> close() async {
    await _ui.close();
    return super.close();
  }
}
