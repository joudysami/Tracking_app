import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/home/domain/entity/claim_order_entity.dart';

part 'claim_order_response.g.dart';

@JsonSerializable()
class ClaimOrderResponse {
  final bool status;
  final int code;
  final String message;
  final ClaimOrderData? data;

  const ClaimOrderResponse({
    required this.status,
    required this.code,
    required this.message,
    this.data,
  });

  factory ClaimOrderResponse.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$ClaimOrderResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ClaimOrderResponseToJson(this);
}

@JsonSerializable()
class ClaimOrderData extends ClaimedOrderEntity {
  const ClaimOrderData({
    required super.orderId,
    required super.orderNumber,
    required super.status,
    required super.assignmentStatus,
    required super.assignedAt,
  });

  factory ClaimOrderData.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$ClaimOrderDataFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ClaimOrderDataToJson(this);
}