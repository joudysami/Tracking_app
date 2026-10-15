
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/features/auth/data/models/login/login_request.dart';
import 'package:tracking_app/features/auth/domain/entities/login/login_entity.dart';
import 'package:tracking_app/features/auth/domain/use_cases/login_use_case.dart';
import 'package:tracking_app/features/auth/presentation/login/view/page/view_model/login_event.dart';
import 'package:tracking_app/features/auth/presentation/login/view/page/view_model/login_state.dart';

@injectable
class LoginViewModel extends Cubit<LoginState> {
  LoginViewModel(this._loginUseCase) : super(const LoginState());

  final LoginUseCase _loginUseCase;

  void doEvent(LoginEvent event) {
    switch (event) {
      case LoginSubmitted():
        _login(event.email, event.password);
        break;
    }
  }

  Future<void> _login(String email, String password) async {
    emit(
      state.copyWith(
        loginState: state.loginState.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
      ),
    );

    final request = LoginRequest(
      email: email,
      password: password,
    );

    final response = await _loginUseCase(request);

    switch (response) {
      case SuccessResponse<LoginEntity>():
        emit(
          state.copyWith(
            loginState: state.loginState.copyWith(
              isLoading: false,
              data: response.data,
              errorMessage: '',
            ),
          ),
        );
        break;

      case ErrorResponse<LoginEntity>():
        emit(
          state.copyWith(
            loginState: state.loginState.copyWith(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
    }
  }
}