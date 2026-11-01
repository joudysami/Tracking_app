import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/domain/entities/geo_point.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/location_entity.dart';
import 'package:tracking_app/features/location_tracking/domain/repos/location_repo.dart';

@injectable
class LocationTrackingUseCase {
  LocationTrackingUseCase(this._locationRepo);

  final LocationRepo _locationRepo;

  Stream<LocationEntity> call() {
    return _locationRepo.getPositionStream();
  }

  Future<BaseResponse<GeoPoint>> getCurrentPosition() {
    return _locationRepo.getCurrentPosition();
  }

  Future<BaseResponse<GeoPoint?>> getLastKnownPosition() {
    return _locationRepo.getLastKnownPosition();
  }
}
