import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/home/data/models/available_orders_model.dart';
import 'package:tracking_app/features/home/data/models/pagination_model.dart';

part 'available_orders_response.g.dart';

@JsonSerializable()
class AvailableOrdersResponse {
  final bool status;
  final int code;
  final String message;
  final List<AvailableOrderModel> data;
  final PaginationModel pagination;

  const AvailableOrdersResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
    required this.pagination,
  });

  factory AvailableOrdersResponse.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$AvailableOrdersResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AvailableOrdersResponseToJson(this);
}