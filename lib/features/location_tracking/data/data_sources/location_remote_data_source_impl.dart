import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/location_tracking/api/location_api_client.dart';
import 'package:tracking_app/features/location_tracking/data/data_sources/location_remote_data_source.dart';
import 'package:tracking_app/features/location_tracking/data/models/location_report_request_model.dart';
import 'package:tracking_app/features/location_tracking/data/models/location_report_response_model.dart';

@Injectable(as: LocationRemoteDataSource)
class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  LocationRemoteDataSourceImpl({required this.apiClient});

  final LocationApiClient apiClient;

  @override
  Future<LocationReportResponseModel> reportLocation(
    LocationReportRequestModel request,
  ) {
    return apiClient.reportLocation(request);
  }
}
