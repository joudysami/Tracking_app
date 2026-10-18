import 'package:tracking_app/features/home/domain/entity/claim_order_entity.dart';
import 'package:tracking_app/features/home/domain/repo/order_repo.dart';

class ClaimOrderUseCase {
  final OrderRepo orderRepo;

  ClaimOrderUseCase(this.orderRepo);

  Future<ClaimedOrderEntity> call({
    required String orderId,
  }) {
    return orderRepo.claimOrder(orderId: orderId);
  }
}