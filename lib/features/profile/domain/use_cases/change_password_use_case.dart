import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/features/profile/domain/entities/profile_params.dart';
import 'package:tracking_app/features/profile/domain/repos/profile_repo.dart';

@injectable
class ChangePasswordUseCase {
  ChangePasswordUseCase(this._repo);

  final ProfileRepo _repo;

  Future<BaseResponse<void>> call(ChangePasswordParams params) {
    return _repo.changePassword(params);
  }
}
