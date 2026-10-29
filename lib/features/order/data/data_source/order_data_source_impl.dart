import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/order/data/api/order_api_client.dart';
import 'package:tracking_app/features/order/data/data_source/order_data_source.dart';
import 'package:tracking_app/features/order/data/models/confirm_delivery_response.dart';
import 'package:tracking_app/features/order/data/models/order_status_response.dart';
import 'package:tracking_app/features/order/data/models/update_status_request.dart';

@Injectable(as: OrdersRemoteDataSource)
class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final OrderApiClient orderApiClient;
  OrdersRemoteDataSourceImpl({required this.orderApiClient});

  @override
  Future<ConfirmDeliveryResponse> confirmDelivery({required String orderId}) {
    return orderApiClient.confirmDelivery(orderId: orderId);
  }

  @override
  Future<OrderStatusResponse> updateStatus({
    required String orderId,
    required String status,
    required String note,
  }) {
    return orderApiClient.updateStatus(
      orderId: orderId,
      request: UpdateStatusRequest(status: status, note: note),
    );
  }
}
