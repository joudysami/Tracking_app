import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/features/home/domain/entity/avaliable_order_entity.dart';
import 'package:tracking_app/features/home/domain/entity/claim_order_entity.dart';
import 'package:tracking_app/features/home/domain/entity/pagenation_entity.dart';

abstract interface class HomeRepo {
  Future<
    BaseResponse<
      ({List<AvailableOrderEntity> orders, PaginationEntity pagination})
    >
  >
  getAvailableOrders({required int page, required int pageSize});

  Future<BaseResponse<ClaimedOrderEntity>> claimOrder({
    required String orderId,
  });
}
