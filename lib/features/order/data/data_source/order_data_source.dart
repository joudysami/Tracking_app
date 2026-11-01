import 'package:tracking_app/features/order/data/models/confirm_delivery_response.dart';
import 'package:tracking_app/features/order/data/models/order_status_response.dart';

abstract interface class OrdersRemoteDataSource {
  Future<OrderStatusResponse> updateStatus({
    required String orderId,
    required String status,
    required String note,
  });

  Future<ConfirmDeliveryResponse> confirmDelivery({required String orderId});
}
