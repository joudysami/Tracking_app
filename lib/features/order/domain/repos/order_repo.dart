import 'package:tracking_app/core/base/base_response.dart';

import '../../../../core/utils/pagination/paginated_result.dart';
import '../entities/order_history_entity.dart';

abstract interface class OrderRepo {
  Future<BaseResponse<PaginatedResult<OrderHistoryEntity>>> getOrders({
    required int page,
    required int pageSize,
    String? status,
  });
}
