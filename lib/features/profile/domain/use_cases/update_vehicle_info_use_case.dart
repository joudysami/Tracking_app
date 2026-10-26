import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/features/profile/domain/entities/profile_params.dart';
import 'package:tracking_app/features/profile/domain/entities/vehicle_info_entity.dart';
import 'package:tracking_app/features/profile/domain/repos/profile_repo.dart';

@injectable
class UpdateVehicleInfoUseCase {
  UpdateVehicleInfoUseCase(this._repo);

  final ProfileRepo _repo;

  Future<BaseResponse<VehicleInfoEntity>> call(UpdateVehicleParams params) {
    return _repo.updateVehicle(params);
  }
}
