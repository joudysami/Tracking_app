import 'package:geolocator/geolocator.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/location_entity.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/location_report_entity.dart';

abstract interface class LocationRepo {
  Future<BaseResponse<bool>> isLocationServiceEnabled();

  Future<BaseResponse<LocationPermission>> checkPermission();

  Future<BaseResponse<LocationPermission>> requestPermission();

  Future<BaseResponse<bool>> openLocationSettings();

  Future<BaseResponse<bool>> openAppSettings();

  Stream<LocationEntity> getPositionStream();

  Future<BaseResponse<Position>> getCurrentPosition();

 Future<BaseResponse<LocationReportEntity>?>  reportLocation(
    LocationEntity location,
  );
  Future<BaseResponse<LocationPermission>> checkAndRequestPermission();
}
