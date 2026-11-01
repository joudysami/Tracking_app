import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/features/home/domain/entity/claim_order_entity.dart';
import 'package:tracking_app/features/home/domain/repo/home_repo.dart';

@injectable
class GetAssignedOrderUseCase {
  final HomeRepo repo;

  GetAssignedOrderUseCase(this.repo);

  Future<BaseResponse<ClaimedOrderEntity?>> call() {
    return repo.getAssignedOrder();
  }
}
