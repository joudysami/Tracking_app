import 'package:injectable/injectable.dart';

import '../../../../core/base/base_response.dart';
import '../repos/order_repo.dart';

@Injectable()
class GetOrdersCountUseCase {
  final OrderRepo _repo;

  GetOrdersCountUseCase(this._repo);

  Future<BaseResponse<int?>> call({required String status}) async {
    final response = await _repo.getOrders(
      page: 1,
      pageSize: 1,
      status: status,
    );
    return switch (response) {
      SuccessResponse(:final data) => SuccessResponse<int?>(
        data?.pagination.totalCount,
      ),
      ErrorResponse(:final appError) => ErrorResponse<int?>(appError: appError),
    };
  }
}
