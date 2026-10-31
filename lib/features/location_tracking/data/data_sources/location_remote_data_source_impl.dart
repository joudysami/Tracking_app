import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/location_tracking/api/location_api_client.dart';
import 'package:tracking_app/features/location_tracking/api/routing_api_client.dart';
import 'package:tracking_app/features/location_tracking/data/data_sources/location_remote_data_source.dart';
import 'package:tracking_app/features/location_tracking/data/models/location_report_request_model.dart';
import 'package:tracking_app/features/location_tracking/data/models/location_report_response_model.dart';
import 'package:tracking_app/features/location_tracking/data/models/route_response_model.dart';

@Injectable(as: LocationRemoteDataSource)
class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  LocationRemoteDataSourceImpl({
    required this.apiClient,
    required this.routingApiClient,
  });

  final LocationApiClient apiClient;
  final RoutingApiClient routingApiClient;

  @override
  Future<LocationReportResponseModel> reportLocation(
    LocationReportRequestModel request,
  ) {
    return apiClient.reportLocation(request);
  }

  @override
  Future<RouteResponseModel> getRoute({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) async {
    final coordinates =
        '$startLongitude,$startLatitude;$endLongitude,$endLatitude';

    final response = await routingApiClient.getRoute(
      coordinates,
      overview: 'full',
      geometries: 'geojson',
      steps: true,
    );

    return response;
  }
}
