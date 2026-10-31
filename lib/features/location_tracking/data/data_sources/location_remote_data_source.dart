import 'package:tracking_app/features/location_tracking/data/models/location_report_request_model.dart';
import 'package:tracking_app/features/location_tracking/data/models/location_report_response_model.dart';
import 'package:tracking_app/features/location_tracking/data/models/route_response_model.dart';

abstract interface class LocationRemoteDataSource {
  Future<LocationReportResponseModel> reportLocation(
    LocationReportRequestModel request,
  );

  Future<RouteResponseModel> getRoute({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  });
}
