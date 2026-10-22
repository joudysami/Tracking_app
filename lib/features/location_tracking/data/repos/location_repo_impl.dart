import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/network/safe_call.dart';
import 'package:tracking_app/core/services/location_service.dart';
import 'package:tracking_app/features/location_tracking/data/data_sources/location_remote_data_source.dart';
import 'package:tracking_app/features/location_tracking/data/models/location_report_request_model.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/location_entity.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/location_report_entity.dart';
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

  static const Duration _throttleDuration = Duration(seconds: 5);

  DateTime? _lastReportAttemptAt;

  @override
  Future<BaseResponse<bool>> isLocationServiceEnabled() {
    return _safeCall.safeApiCall<bool>(
      _locationService.isLocationServiceEnabled,
    );
  }

  @override
  Future<BaseResponse<LocationPermission>> checkPermission() {
    return _safeCall.safeApiCall<LocationPermission>(
      _locationService.checkPermission,
    );
  }

  @override
  Future<BaseResponse<LocationPermission>> requestPermission() {
    return _safeCall.safeApiCall<LocationPermission>(
      _locationService.requestPermission,
    );
  }

  @override
  Future<BaseResponse<bool>> openLocationSettings() {
    return _safeCall.safeApiCall<bool>(_locationService.openLocationSettings);
  }

  @override
  Future<BaseResponse<bool>> openAppSettings() {
    return _safeCall.safeApiCall<bool>(_locationService.openAppSettings);
  }

  @override
  Stream<LocationEntity> getPositionStream() {
    return _locationService.getPositionStream().map(
      (position) => LocationEntity(
        lat: position.latitude,
        lng: position.longitude,
        recordedAt: position.timestamp,
      ),
    );
  }

  @override
  Future<BaseResponse<Position>> getCurrentPosition() {
    return _safeCall.safeApiCall<Position>(_locationService.getCurrentPosition);
  }

  @override
  Future<BaseResponse<LocationReportEntity>?> reportLocation(
    LocationEntity location,
  ) async {
    final now = DateTime.now();

    if (_lastReportAttemptAt != null &&
        now.difference(_lastReportAttemptAt!) < _throttleDuration) {
      return null;
    }

    _lastReportAttemptAt = now;

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
  Future<BaseResponse<LocationPermission>> checkAndRequestPermission() async {
    final permissionResponse = await checkPermission();

    if (permissionResponse is ErrorResponse<LocationPermission>) {
      return permissionResponse;
    }

    final permission =
        (permissionResponse as SuccessResponse<LocationPermission>).data;

    if (permission == LocationPermission.denied) {
      return requestPermission();
    }

    return permissionResponse;
  }
}
