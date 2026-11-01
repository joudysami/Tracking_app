import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';

import '../../../../core/utils/pagination/paginated_result.dart';
import '../../core/order_history_status.dart';
import '../entities/order_history_entity.dart';
import '../repos/order_repo.dart';

@Injectable()
class GetOrdersHistoryUseCase {
  final OrderRepo _orderRepo;

  GetOrdersHistoryUseCase(this._orderRepo);

  Future<BaseResponse<PaginatedResult<OrderHistoryEntity>>> call({
    required int page,
    required int pageSize,
  }) async {
    final response = await _orderRepo.getOrders(page: page, pageSize: pageSize);

    if (response is SuccessResponse<PaginatedResult<OrderHistoryEntity>>) {
      final data = response.data;
      if (data == null) return response;
      return SuccessResponse(
        PaginatedResult(
          items: _filterHistory(data.items),
          pagination: data.pagination,
        ),
      );
    }
    return response;
  }

  List<OrderHistoryEntity> _filterHistory(List<OrderHistoryEntity> orders) {
    return orders
        .where((order) => isOrderHistoryStatus(order.status ?? ''))
        .toList();
  }
}
