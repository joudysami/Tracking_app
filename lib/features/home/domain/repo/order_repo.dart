import 'package:tracking_app/features/home/domain/entity/avaliable_order_entity.dart';
import 'package:tracking_app/features/home/domain/entity/claim_order_entity.dart';
import 'package:tracking_app/features/home/domain/entity/pagenation_entity.dart';

abstract interface class OrderRepo {
  Future<({List<AvailableOrderEntity> orders, PaginationEntity pagination})>
  getAvailableOrders({required int page, required int pageSize});

  Future<ClaimedOrderEntity> claimOrder({required String orderId});
}
