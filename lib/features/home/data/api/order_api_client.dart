import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tracking_app/core/constant/api_endpoints.dart';

part 'order_api_client.g.dart';

@RestApi()
abstract class OrderApiClient {
  factory OrderApiClient(Dio dio, {String? baseUrl}) = _OrderApiClient;

  @GET(ApiEndpoints.availableOrders)
  Future<Map<String, dynamic>> getAvailableOrders({
    @Query('page') required int page,
    @Query('pageSize') required int pageSize,
  });

  @POST(ApiEndpoints.claim)
  Future<Map<String, dynamic>> claimOrder({
    @Path('orderId') required String orderId,
  });
}
