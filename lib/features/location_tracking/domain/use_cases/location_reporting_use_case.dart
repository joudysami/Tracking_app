import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/location_entity.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/location_report_entity.dart';
import 'package:tracking_app/features/location_tracking/domain/repos/location_repo.dart';

@injectable
class LocationReportingUseCase {
  LocationReportingUseCase(this._locationRepo);

  final LocationRepo _locationRepo;

  static const double _minimumDistanceInMeters = 30;

  LocationEntity? _lastReportedLocation;

  Future<BaseResponse<LocationReportEntity>?> call(
    LocationEntity location,
  ) async {
    final lastLocation = _lastReportedLocation;

    if (lastLocation != null) {
      final distance = Geolocator.distanceBetween(
        lastLocation.lat,
        lastLocation.lng,
        location.lat,
        location.lng,
      );

      if (distance < _minimumDistanceInMeters) {
        return null;
      }
    }

    final response = await _locationRepo.reportLocation(location);

    if (response is SuccessResponse<LocationReportEntity>) {
      _lastReportedLocation = location;
    }

    return response;
  }
}
