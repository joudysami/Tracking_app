import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/verify_otp_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/verify_otp_response.dart';
import 'package:tracking_app/features/auth/domain/repos/auth_repo.dart';

@Injectable()
class VerifyOtpUseCase {
  final AuthRepo _repo;
  const VerifyOtpUseCase(this._repo);

  Future<BaseResponse<VerifyOtpResponse>> call({
    required VerifyOtpRequest request,
  }) {
    return _repo.verifyOtp(verifyOtpRequest: request);
  }
}