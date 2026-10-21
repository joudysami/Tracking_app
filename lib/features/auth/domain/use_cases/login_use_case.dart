import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/features/auth/data/models/login/login_request.dart';
import 'package:tracking_app/features/auth/domain/entities/login/login_entity.dart';
import 'package:tracking_app/features/auth/domain/repos/auth_repo.dart';

@injectable
class LoginUseCase {
  final AuthRepo repo;

  LoginUseCase(this.repo);

  Future<BaseResponse<LoginEntity>> call(LoginRequest request) {
    return repo.signIn(request);
  }
}