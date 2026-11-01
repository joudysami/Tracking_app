import 'package:tracking_app/core/base/api_response.dart';
import 'package:tracking_app/features/order/data/models/order_history_response.dart';

abstract interface class OrderRemoteDataSource {
  Future<ApiResponse<List<OrderHistoryResponse>>> getOrderHistory({
    required int page,
    required int pageSize,
    String? status,
  });
}
