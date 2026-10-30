import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/network/safe_call.dart';
import 'package:tracking_app/features/order/domain/entities/order_history_entity.dart';
import 'package:tracking_app/features/order/domain/repos/order_repo.dart';

import '../../../../core/base/api_response.dart';
import '../../../../core/utils/pagination/paginated_result.dart';
import '../../domain/entities/pagination_params.dart';
import '../data_sources/order_remote_data_source.dart';
import '../mappers/order_history_mapper.dart';
import '../mappers/pagination_mapper.dart';
import '../models/pagination_model.dart';

@Injectable(as: OrderRepo)
class OrderRepoImpl implements OrderRepo {
  final OrderRemoteDataSource dataSource;
  final SafeCall safeCall;

  const OrderRepoImpl(this.dataSource, this.safeCall);

  @override
  Future<BaseResponse<PaginatedResult<OrderHistoryEntity>>> getOrders({
    required int page,
    required int pageSize,
    String? status,
  }) {
    return safeCall.safeApiCall(() async {
      final response = await dataSource.getOrderHistory(
        page: page,
        pageSize: pageSize,
        status: status,
      );
      final rawPagination = response.pagination;
      return PaginatedResult(
        items: response.dataOrThrow().map((e) => e.toEntity()).toList(),
        pagination: rawPagination is Map<String, dynamic>
            ? PaginationModel.fromJson(rawPagination).toEntity()
            : const PaginationParams(),
      );
    });
  }
}
