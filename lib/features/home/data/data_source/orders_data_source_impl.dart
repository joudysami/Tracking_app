import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/home/data/api/order_api_client.dart';
import 'package:tracking_app/features/home/data/data_source/orders_data_source.dart';
import 'package:tracking_app/features/home/data/models/available_orders_response.dart';
import 'package:tracking_app/features/home/data/models/claim_order_response.dart';
@Injectable(as: OrdersRemoteDataSource)

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource{
  final HomeApiClient  homeApiClient ;
  OrdersRemoteDataSourceImpl({required this.homeApiClient});
  @override
Future<AvailableOrdersResponse> getAvailableOrders(
  {
  required int page,
  required int pageSize,

  }
) {
  return homeApiClient.getAvailableOrders(page: page, pageSize: pageSize);
}
@override
Future<ClaimOrderResponse> claimOrder({
  required String orderId,
}) {
  return homeApiClient.claimOrder(
    orderId: orderId,
  );
}
}