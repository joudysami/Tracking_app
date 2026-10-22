import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tracking_app/core/constant/api_endpoints.dart';
import 'package:tracking_app/features/location_tracking/data/models/location_report_request_model.dart';
import 'package:tracking_app/features/location_tracking/data/models/location_report_response_model.dart';

part 'location_api_client.g.dart';

@RestApi()
abstract class LocationApiClient {
  factory LocationApiClient(Dio dio, {String? baseUrl}) = _LocationApiClient;

  @POST(ApiEndpoints.reportDriverLocation)
  Future<LocationReportResponseModel> reportLocation(
    @Body() LocationReportRequestModel request,
  );
}
