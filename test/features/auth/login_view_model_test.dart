import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/error/app_error.dart';
import 'package:tracking_app/features/auth/data/models/login_request.dart';
import 'package:tracking_app/features/auth/domain/entity/auth_session.dart';
import 'package:tracking_app/features/auth/domain/repo/auth_repo.dart';
import 'package:tracking_app/features/auth/domain/use_case/login_use_case.dart';
import 'package:tracking_app/features/auth/presentation/login/view_model/login_view_model.dart';

void main() {
  test('submit reports loading then the session', () async {
    final repo = _Repo(SuccessResponse(const AuthSession(role: 'CUSTOMER')));
    final model = LoginViewModel(LoginUseCase(repo));
    final states = <bool>[];
    model.addListener(() => states.add(model.state.submission.isLoading));

    await model.submit(email: ' rider@example.com ', password: 'secret');

    expect(states, [true, false]);
    expect(model.state.submission.data?.role, 'CUSTOMER');
    expect(repo.request?.email, 'rider@example.com');
  });

  test('submit distinguishes credential and server failures', () async {
    final credential = LoginViewModel(
      LoginUseCase(_Repo(ErrorResponse(appError: UnauthorizedError()))),
    );
    await credential.submit(email: 'a@b.com', password: 'bad');
    expect(credential.state.credentialFailure, isTrue);

    final server = LoginViewModel(
      LoginUseCase(
        _Repo(ErrorResponse(appError: TimeOutError(Exception('slow')))),
      ),
    );
    await server.submit(email: 'a@b.com', password: 'bad');
    expect(server.state.credentialFailure, isFalse);
    expect(server.state.submission.errorMessage, isNotEmpty);
  });
}

class _Repo implements AuthRepo {
  _Repo(this.result);

  final BaseResponse<AuthSession> result;
  LoginRequest? request;

  @override
  Future<BaseResponse<AuthSession>> signIn(LoginRequest request) async {
    this.request = request;
    return result;
  }

  @override
  Future<AuthSession?> currentSession() async => null;

  @override
  Future<bool> accessTokenExpired() async => false;

  @override
  Future<AuthSession> refreshSession() => throw UnimplementedError();
}
