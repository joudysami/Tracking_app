import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/features/home/domain/entity/claim_order_entity.dart';
import 'package:tracking_app/features/home/domain/repo/home_repo.dart';

@injectable
class ClaimOrderUseCase {
  final HomeRepo repo;

  ClaimOrderUseCase(this.repo);

  Future<BaseResponse<ClaimedOrderEntity>> call({required String orderId}) {
    return repo.claimOrder(orderId: orderId);
  }
}
