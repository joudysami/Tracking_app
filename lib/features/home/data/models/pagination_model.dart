import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/home/domain/entity/pagenation_entity.dart';

part 'pagination_model.g.dart';

@JsonSerializable()
class PaginationModel {
  final int page;
  final int pageSize;

  final int totalCount;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const PaginationModel({
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationModelToJson(this);
  PaginationEntity toDomain() {
    return PaginationEntity(
      page: page,
      pageSize: pageSize,
      totalCount: totalCount,
      totalPages: totalPages,
      hasNextPage: hasNextPage,
      hasPreviousPage: hasPreviousPage,
    );
  }
}
