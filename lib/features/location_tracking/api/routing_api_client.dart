import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tracking_app/core/constant/routing_constants.dart';
import 'package:tracking_app/features/location_tracking/data/models/route_response_model.dart';

part 'routing_api_client.g.dart';

@RestApi(baseUrl: RoutingConstants.routingBaseUrl)
abstract class RoutingApiClient {
  factory RoutingApiClient(Dio dio, {String? baseUrl}) = _RoutingApiClient;

  @GET('/route/v1/${RoutingConstants.drivingProfile}/{coordinates}')
  Future<RouteResponseModel> getRoute(
    @Path(RoutingConstants.coordinatesParameter) String coordinates, {
    @Query(RoutingConstants.overviewParameter)
    String overview = RoutingConstants.overview,
    @Query(RoutingConstants.geometriesParameter)
    String geometries = RoutingConstants.geometries,
    @Query(RoutingConstants.stepsParameter)
    bool steps = RoutingConstants.includeSteps,
  });
}
