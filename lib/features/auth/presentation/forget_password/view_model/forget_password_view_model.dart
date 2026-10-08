import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/forget_password_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/reset_password_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/verify_otp_request.dart';

import '../../../domain/use_cases/forget_password_use_case.dart';
import '../../../domain/use_cases/reset_password_use_case.dart';
import '../../../domain/use_cases/verify_otp_use_case.dart';
import 'forget_password_event.dart';
import 'forget_password_state.dart';
import 'forget_password_ui_event.dart';

@Injectable()
class ForgetPasswordViewModel extends Cubit<ForgetPasswordState> {
  final ForgetPasswordUseCase _forgetPasswordUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;

  ForgetPasswordViewModel(
      this._forgetPasswordUseCase,
      this._verifyOtpUseCase,
      this._resetPasswordUseCase,
      ) : super(const ForgetPasswordState());

  final _uiEventController =
  StreamController<ForgetPasswordUiEvent>.broadcast();
  Stream<ForgetPasswordUiEvent> get uiEvents => _uiEventController.stream;

  void onEvent(ForgetPasswordEvent event) {
    switch (event) {
      case SendEmailEvent(:final email):
        _sendEmail(email);
      case VerifyOtpEvent(:final otp):
        _verifyOtp(otp);
      case ResendOtpEvent():
        _resendOtp();
      case ResetPasswordEvent(:final password, :final confirmPassword):
        _resetPassword(password, confirmPassword);
      case GoBackEvent():
        _goBack();
    }
  }

  Future<void> _sendEmail(String email) async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));

    final result = await _forgetPasswordUseCase(
      request: ForgetPasswordRequest(email: email),
    );

    switch (result) {
      case SuccessResponse():
        emit(state.copyWith(
          isLoading: false,
          step: ForgetPasswordStep.otp,
          email: email,
        ));
      case ErrorResponse(:final errorMessage):
        emit(state.copyWith(isLoading: false));
        _uiEventController.add(ShowErrorUiEvent(errorMessage));
    }
  }

  Future<void> _verifyOtp(String otp) async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));

    final result = await _verifyOtpUseCase(
      request: VerifyOtpRequest(email: state.email, otp: otp),
    );

    switch (result) {
      case SuccessResponse(:final data):
        final otpToken = data?.otpToken;
        if (otpToken == null || otpToken.isEmpty) {
          emit(state.copyWith(isLoading: false));
          _uiEventController.add(ShowErrorUiEvent(LocaleKeys.commonError.tr()));
          return;
        }
        emit(state.copyWith(
          isLoading: false,
          step: ForgetPasswordStep.resetPassword,
          otpToken: otpToken,
        ));
      case ErrorResponse(:final errorMessage):
        emit(state.copyWith(isLoading: false));
        _uiEventController.add(ShowErrorUiEvent(errorMessage));
    }
  }

  Future<void> _resendOtp() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));

    final result = await _forgetPasswordUseCase(
      request: ForgetPasswordRequest(email: state.email),
    );

    emit(state.copyWith(isLoading: false));
    switch (result) {
      case SuccessResponse():
        _uiEventController.add(const OtpResentUiEvent());
      case ErrorResponse(:final errorMessage):
        _uiEventController.add(ShowErrorUiEvent(errorMessage));
    }
  }

  Future<void> _resetPassword(String password, String confirmPassword) async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));

    final result = await _resetPasswordUseCase(
      request: ResetPasswordRequest(
        otpToken: state.otpToken,
        password: password,
        confirmPassword: confirmPassword,
      ),
    );

    emit(state.copyWith(isLoading: false));
    switch (result) {
      case SuccessResponse():
        _uiEventController.add(const NavigateToLoginUiEvent());
      case ErrorResponse(:final errorMessage):
        _uiEventController.add(ShowErrorUiEvent(errorMessage));
    }
  }

  void _goBack() {
    switch (state.step) {
      case ForgetPasswordStep.otp:
        emit(state.copyWith(step: ForgetPasswordStep.email));
      case ForgetPasswordStep.resetPassword:
        emit(state.copyWith(step: ForgetPasswordStep.otp));
      case ForgetPasswordStep.email:
        break;
    }
  }

  @override
  Future<void> close() {
    _uiEventController.close();
    return super.close();
  }
}