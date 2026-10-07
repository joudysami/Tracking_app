import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/features/auth/data/models/login_request.dart';
import 'package:tracking_app/features/auth/domain/entity/auth_session.dart';
import 'package:tracking_app/features/auth/domain/repo/auth_repo.dart';

@injectable
class LoginUseCase {
  LoginUseCase(this._repo);

  final AuthRepo _repo;

  Future<BaseResponse<AuthSession>> call(LoginRequest request) {
    return _repo.signIn(request);
  }
}
