import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/features/auth/domain/entities/vehicle_type_entity.dart';
import 'package:tracking_app/features/auth/domain/repos/auth_repo.dart';

@injectable
class GetVehicleTypesUseCase {
  final AuthRepo _authRepo;
  GetVehicleTypesUseCase(this._authRepo);

  Future<BaseResponse<List<VehicleTypeEntity>>> call() {
    return _authRepo.getVehicleTypes();
  }
}
