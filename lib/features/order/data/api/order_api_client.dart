import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../../../../core/base/api_response.dart';
import '../../../../core/constant/api_endpoints.dart';
import '../../../../core/constant/api_request_params.dart';
import '../models/order_history_response.dart';

part 'order_api_client.g.dart';

@RestApi()
abstract class OrderApiClient {
  factory OrderApiClient(Dio dio, {String? baseUrl}) = _OrderApiClient;

  @GET(ApiEndpoints.orderHistory)
  Future<ApiResponse<List<OrderHistoryResponse>>> getOrders({
    @Query(ApiRequestParams.page) String? page,
    @Query(ApiRequestParams.pageSize) String? pageSize,
    @Query(ApiRequestParams.status) String? status,
  });
}
