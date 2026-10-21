import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/network/safe_call.dart';
import 'package:tracking_app/core/services/location_service.dart';
import 'package:tracking_app/features/location_tracking/domain/repos/location_repo.dart';

@Injectable(as: LocationRepo)
class LocationRepoImpl implements LocationRepo {
  LocationRepoImpl(this._locationService, this._safeCall);

  final LocationService _locationService;
  final SafeCall _safeCall;

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
  Stream<Position> getPositionStream() {
    return _locationService.getPositionStream();
  }

  @override
  Future<BaseResponse<Position>> getCurrentPosition() {
    return _safeCall.safeApiCall<Position>(
      _locationService.getCurrentPosition,
    );
  }
}