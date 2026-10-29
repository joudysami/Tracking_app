import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:tracking_app/core/constant/api_endpoints.dart';
import 'package:tracking_app/core/constant/api_request_params.dart';
import 'package:tracking_app/features/order/data/models/confirm_delivery_response.dart';
import 'package:tracking_app/features/order/data/models/order_status_response.dart';
import 'package:tracking_app/features/order/data/models/update_status_request.dart';

part 'order_api_client.g.dart';

@RestApi()
abstract class OrderApiClient {
  factory OrderApiClient(Dio dio, {String? baseUrl}) = _OrderApiClient;

  @PATCH(ApiEndpoints.status)
  Future<OrderStatusResponse> updateStatus({
    @Path(ApiRequestParams.orderId) required String orderId,
    @Body() required UpdateStatusRequest request,
  });

  @POST(ApiEndpoints.confirmDelivery)
  Future<ConfirmDeliveryResponse> confirmDelivery({
    @Path(ApiRequestParams.orderId) required String orderId,
  });
}
