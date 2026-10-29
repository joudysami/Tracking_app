import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tracking_app/core/constant/api_endpoints.dart';
import 'package:tracking_app/core/constant/api_request_params.dart';
import 'package:tracking_app/features/home/data/models/available_orders_response.dart';
import 'package:tracking_app/features/home/data/models/claim_order_response.dart';

part 'order_api_client.g.dart';

@RestApi()
abstract class HomeApiClient {
  factory HomeApiClient(Dio dio, {String? baseUrl}) = _HomeApiClient;

  @GET(ApiEndpoints.availableOrders)
  Future<AvailableOrdersResponse> getAvailableOrders({
    @Query(ApiRequestParams.page) required int page,
    @Query(ApiRequestParams.pageSize) required int pageSize,
  });

  @POST(ApiEndpoints.claim)
  Future<ClaimOrderResponse> claimOrder({
    @Path(ApiRequestParams.orderId) required String orderId,
  });
}
