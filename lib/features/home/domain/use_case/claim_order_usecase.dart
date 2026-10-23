import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/features/home/domain/entity/claim_order_entity.dart';
import 'package:tracking_app/features/home/domain/repo/order_repo.dart';
@injectable
class ClaimOrderUseCase {
  final OrderRepo orderRepo;

  ClaimOrderUseCase(this.orderRepo);

  Future<BaseResponse<ClaimedOrderEntity>> call({
    required String orderId,
  }) {
    return orderRepo.claimOrder(orderId: orderId);
  }
}