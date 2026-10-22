import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/features/location_tracking/domain/repos/location_repo.dart';

@injectable
class CheckAndRequestLocationPermissionUseCase {
  CheckAndRequestLocationPermissionUseCase(this._locationRepo);

  final LocationRepo _locationRepo;

  Future<BaseResponse<LocationPermission>> call() {
    return _locationRepo.checkAndRequestPermission();
  }
}
