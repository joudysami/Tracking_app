import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/forget_password_request.dart';
import 'package:tracking_app/features/auth/domain/repos/auth_repo.dart';

@Injectable()
class ForgetPasswordUseCase {
  final AuthRepo _repo;
  const ForgetPasswordUseCase(this._repo);

  Future<BaseResponse<void>> call({required ForgetPasswordRequest request}) {
    return _repo.forgetPassword(forgetPasswordRequest: request);
  }
}