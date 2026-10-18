import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/reset_password_request.dart';
import 'package:tracking_app/features/auth/domain/repos/auth_repo.dart';

@Injectable()
class ResetPasswordUseCase {
  final AuthRepo _repo;
  const ResetPasswordUseCase(this._repo);

  Future<BaseResponse<void>> call({required ResetPasswordRequest request}) {
    return _repo.resetPassword(resetPasswordRequest: request);
  }
}