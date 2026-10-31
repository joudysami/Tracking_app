import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/services/distance_service.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/location_entity.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/location_report_entity.dart';
import 'package:tracking_app/features/location_tracking/domain/repos/location_repo.dart';

@injectable
class LocationReportingUseCase {
  LocationReportingUseCase(this._locationRepo, this._distanceService);

  final LocationRepo _locationRepo;
  final DistanceService _distanceService;

  static const double _minimumDistanceInMeters = 30;

  LocationEntity? _lastReportedLocation;

  StreamSubscription<BaseResponse<LocationReportEntity>?> call(
    Stream<LocationEntity> locations,
  ) {
    return locations
        .asyncMap(_reportLocationIfNeeded)
        .listen((_) {});
  }

  Future<BaseResponse<LocationReportEntity>?> _reportLocationIfNeeded(
    LocationEntity location,
  ) async {
    final lastLocation = _lastReportedLocation;

    if (lastLocation != null) {
      final distance = _distanceService.calculateDistance(
        startLatitude: lastLocation.lat,
        startLongitude: lastLocation.lng,
        endLatitude: location.lat,
        endLongitude: location.lng,
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
