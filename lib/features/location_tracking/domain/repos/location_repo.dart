import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/domain/entities/geo_point.dart';
import 'package:tracking_app/core/domain/entities/location_permission_status.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/location_entity.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/location_report_entity.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/route_entity.dart';

abstract interface class LocationRepo {
  Future<BaseResponse<bool>> isLocationServiceEnabled();

  Future<BaseResponse<LocationPermissionStatus>> checkPermission();

  Future<BaseResponse<LocationPermissionStatus>> requestPermission();

  Future<BaseResponse<bool>> openLocationSettings();

  Future<BaseResponse<bool>> openAppSettings();

  Stream<LocationEntity> getPositionStream();
  Future<BaseResponse<GeoPoint>> getCurrentPosition();

  Future<BaseResponse<LocationReportEntity>> reportLocation(
    LocationEntity location,
  );

  Future<BaseResponse<LocationPermissionStatus>> checkAndRequestPermission();
  
Future<BaseResponse<RouteEntity>> getRoute({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  });

}
