import 'package:json_annotation/json_annotation.dart';

part 'pagination_model.g.dart';

@JsonSerializable()
class PaginationModel {
  @JsonKey(name: "page")
  final int? page;
  @JsonKey(name: "pageSize")
  final int? pageSize;
  @JsonKey(name: "totalCount")
  final int? totalCount;
  @JsonKey(name: "totalPages")
  final int? totalPages;
  @JsonKey(name: "hasNextPage")
  final bool? hasNextPage;
  @JsonKey(name: "hasPreviousPage")
  final bool? hasPreviousPage;

  PaginationModel({
    this.page,
    this.pageSize,
    this.totalCount,
    this.totalPages,
    this.hasNextPage,
    this.hasPreviousPage,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return _$PaginationModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$PaginationModelToJson(this);
  }
}
