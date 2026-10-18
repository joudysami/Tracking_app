import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/home/data/api/order_api_client.dart';
import 'package:tracking_app/features/home/data/data_source/orders_data_source.dart';
import 'package:tracking_app/features/home/data/models/available_orders_response.dart';
import 'package:tracking_app/features/home/data/models/claim_order_response.dart';
@Injectable(as: OrdersRemoteDataSource)

class OrdersRemoteDataSourceImpl  extends OrdersRemoteDataSource{
  final OrderApiClient orderApiClient;
  OrdersRemoteDataSourceImpl({required this.orderApiClient});
  @override
  Future<AvailableOrdersResponse> getAvailableOrders({
    required int page,
    required int pageSize,
  }) async {
    final json = await orderApiClient.getAvailableOrders(
      page: page,
      pageSize: pageSize,
    );

    return AvailableOrdersResponse.fromJson(json);
  }

  @override
  Future<ClaimOrderResponse> claimOrder({
    required String orderId,
  }) async {
    final json = await orderApiClient.claimOrder(
      orderId: orderId,
    );

    return ClaimOrderResponse.fromJson(json);
  }
}