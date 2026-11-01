import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/api_response.dart';
import 'package:tracking_app/features/order/data/data_sources/order_remote_data_source.dart';
import 'package:tracking_app/features/order/data/models/order_history_response.dart';

import '../api/order_api_client.dart';

@Injectable(as: OrderRemoteDataSource)
class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final OrderApiClient apiClient;

  const OrderRemoteDataSourceImpl(this.apiClient);

  @override
  Future<ApiResponse<List<OrderHistoryResponse>>> getOrderHistory({
    required int page,
    required int pageSize,
    String? status,
  }) {
    return apiClient.getOrders(
      page: page.toString(),
      pageSize: pageSize.toString(),
      status: status,
    );
  }
}
