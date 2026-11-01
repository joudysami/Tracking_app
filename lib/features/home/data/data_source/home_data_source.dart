import 'package:tracking_app/features/home/data/models/assigned_order_response.dart';
import 'package:tracking_app/features/home/data/models/available_orders_response.dart';
import 'package:tracking_app/features/home/data/models/claim_order_response.dart';

abstract interface class HomeRemoteDataSource {
  Future<AvailableOrdersResponse> getAvailableOrders({
    required int page,
    required int pageSize,
  });

  Future<AssignedOrderResponse> getAssignedOrder();

  Future<ClaimOrderResponse> claimOrder({required String orderId});
}
