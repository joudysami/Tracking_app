import '../../domain/entities/pagination_params.dart';
import '../models/pagination_model.dart';

extension PaginationMapper on PaginationModel {
  PaginationParams toEntity() => PaginationParams(
    page: page,
    pageSize: pageSize,
    totalCount: totalCount,
    totalPages: totalPages,
    hasNextPage: hasNextPage,
    hasPreviousPage: hasPreviousPage,
  );
}
