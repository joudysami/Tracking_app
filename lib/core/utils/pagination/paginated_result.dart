import '../../../features/order/domain/entities/pagination_params.dart';

class PaginatedResult<T> {
  final List<T> items;
  final PaginationParams pagination;

  const PaginatedResult({required this.items, required this.pagination});
}
