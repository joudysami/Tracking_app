import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/home/domain/entity/pagenation_entity.dart';

part 'pagination_model.g.dart';

@JsonSerializable()
class PaginationModel extends PaginationEntity {
  const PaginationModel({
    required super.page,
    required super.pageSize,
    required super.totalCount,
    required super.totalPages,
    required super.hasNextPage,
    required super.hasPreviousPage,
  });

  factory PaginationModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$PaginationModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$PaginationModelToJson(this);
}