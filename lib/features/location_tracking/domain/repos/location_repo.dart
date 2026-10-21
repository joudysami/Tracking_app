import 'package:geolocator/geolocator.dart';
import 'package:tracking_app/core/base/base_response.dart';

abstract interface class LocationRepo {
  Future<BaseResponse<bool>> isLocationServiceEnabled();

  Future<BaseResponse<LocationPermission>> checkPermission();

  Future<BaseResponse<LocationPermission>> requestPermission();

  Future<BaseResponse<bool>> openLocationSettings();

  Future<BaseResponse<bool>> openAppSettings();

  Stream<Position> getPositionStream();

  Future<BaseResponse<Position>> getCurrentPosition();
}
