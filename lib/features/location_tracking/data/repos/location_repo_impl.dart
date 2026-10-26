import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/domain/entities/geo_point.dart';
import 'package:tracking_app/core/domain/entities/location_permission_status.dart';
import 'package:tracking_app/core/network/safe_call.dart';
import 'package:tracking_app/core/services/location_service.dart';
import 'package:tracking_app/features/location_tracking/data/data_sources/location_remote_data_source.dart';
import 'package:tracking_app/features/location_tracking/data/models/location_report_request_model.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/location_entity.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/location_report_entity.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/route_entity.dart';
import 'package:tracking_app/features/location_tracking/domain/repos/location_repo.dart';

@Injectable(as: LocationRepo)
class LocationRepoImpl implements LocationRepo {
  LocationRepoImpl(
    this._locationService,
    this._safeCall, {
    required this._remoteDataSource,
  });

  final LocationService _locationService;
  final SafeCall _safeCall;
  final LocationRemoteDataSource _remoteDataSource;

  @override
  Future<BaseResponse<bool>> isLocationServiceEnabled() {
    return _safeCall.safeApiCall<bool>(
      _locationService.isLocationServiceEnabled,
    );
  }

  @override
  Future<BaseResponse<LocationPermissionStatus>> checkPermission() {
    return _safeCall.safeApiCall<LocationPermissionStatus>(
      _locationService.checkPermission,
    );
  }

  @override
  Future<BaseResponse<LocationPermissionStatus>> requestPermission() {
    return _safeCall.safeApiCall<LocationPermissionStatus>(
      _locationService.requestPermission,
    );
  }

  @override
  Future<BaseResponse<bool>> openLocationSettings() {
    return _safeCall.safeApiCall<bool>(
      _locationService.openLocationSettings,
    );
  }

  @override
  Future<BaseResponse<bool>> openAppSettings() {
    return _safeCall.safeApiCall<bool>(
      _locationService.openAppSettings,
    );
  }

  @override
  Stream<LocationEntity> getPositionStream() {
    return _locationService.getPositionStream().map(
      (point) => LocationEntity(
        lat: point.latitude,
        lng: point.longitude,
        recordedAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<BaseResponse<GeoPoint>> getCurrentPosition() {
    return _safeCall.safeApiCall<GeoPoint>(
      _locationService.getCurrentPosition,
    );
  }

  @override
  Future<BaseResponse<LocationReportEntity>> reportLocation(
    LocationEntity location,
  ) {
    return _safeCall.safeApiCall<LocationReportEntity>(() async {
      final request = LocationReportRequestModel(
        lat: location.lat,
        lng: location.lng,
        recordedAt: location.recordedAt.toUtc(),
      );

      final response = await _remoteDataSource.reportLocation(request);

      return response.toDomain();
    });
  }

  @override
  Future<BaseResponse<LocationPermissionStatus>>
      checkAndRequestPermission() async {
    final permissionResponse = await checkPermission();

    switch (permissionResponse) {
      case ErrorResponse<LocationPermissionStatus>():
        return permissionResponse;

      case SuccessResponse<LocationPermissionStatus>(:final data):
        if (data == LocationPermissionStatus.denied) {
          return requestPermission();
        }

        return permissionResponse;
    }
  }

  @override
  Future<BaseResponse<RouteEntity>> getRoute({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    return _safeCall.safeApiCall<RouteEntity>(() async {
      final response = await _remoteDataSource.getRoute(
        startLatitude: startLatitude,
        startLongitude: startLongitude,
        endLatitude: endLatitude,
        endLongitude: endLongitude,
      );

      return response.toDomain();
    });
  }
}
