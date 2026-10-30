import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/features/profile/domain/entities/profile_params.dart';
import 'package:tracking_app/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tracking_app/features/profile/domain/repos/profile_repo.dart';

@injectable
class UpdateProfileUseCase {
  UpdateProfileUseCase(this._repo);

  final ProfileRepo _repo;

  Future<BaseResponse<UserProfileEntity>> call(UpdateProfileParams params) {
    return _repo.updateProfile(params);
  }
}
