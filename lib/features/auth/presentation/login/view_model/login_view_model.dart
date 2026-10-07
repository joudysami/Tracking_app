import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/base/base_state.dart';
import 'package:tracking_app/core/error/app_error.dart';
import 'package:tracking_app/features/auth/data/models/login_request.dart';
import 'package:tracking_app/features/auth/domain/entity/auth_session.dart';
import 'package:tracking_app/features/auth/domain/login_failure.dart';
import 'package:tracking_app/features/auth/domain/use_case/login_use_case.dart';
import 'package:tracking_app/features/auth/presentation/login/view_model/login_state.dart';

@injectable
class LoginViewModel extends ChangeNotifier {
  LoginViewModel(this._login);

  final LoginUseCase _login;
  LoginState state = const LoginState();

  Future<void> submit({required String email, required String password}) async {
    _emit(const LoginState(submission: BaseState(isLoading: true)));
    final response = await _login(
      LoginRequest(email: email.trim(), password: password),
    );
    _emit(_result(response));
  }

  void clearFailure() {
    if (state.submission.errorMessage.isEmpty) return;
    _emit(
      state.copyWith(
        submission: state.submission.copyWith(errorMessage: ''),
        credentialFailure: false,
      ),
    );
  }

  LoginState _result(BaseResponse<AuthSession> response) {
    return switch (response) {
      SuccessResponse(:final data) => LoginState(
        submission: BaseState(data: data),
      ),
      ErrorResponse(:final appError) => _failure(appError),
    };
  }

  LoginState _failure(AppError error) {
    return LoginState(
      submission: BaseState(errorMessage: error.message),
      credentialFailure: isCredentialLoginFailure(error),
    );
  }

  void _emit(LoginState next) {
    state = next;
    notifyListeners();
  }
}
