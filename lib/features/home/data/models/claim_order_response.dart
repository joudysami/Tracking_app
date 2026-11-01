import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/home/domain/entity/claim_order_entity.dart';

part 'claim_order_response.g.dart';

@JsonSerializable()
class ClaimOrderResponse {
  final bool? status;
  final int? code;
  final String? message;
  final ClaimOrderData? data;

  const ClaimOrderResponse({this.status, this.code, this.message, this.data});

  factory ClaimOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$ClaimOrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ClaimOrderResponseToJson(this);
}

/// The claim endpoint answers with the assignment summary only: no store,
/// customer, items or amounts. Use [AssignedOrderData] for the full order.
@JsonSerializable()
class ClaimOrderData {
  final String orderId;
  final String orderNumber;
  final String status;
  final String assignmentStatus;
  final DateTime assignedAt;

  const ClaimOrderData({
    required this.orderId,
    required this.orderNumber,
    required this.status,
    required this.assignmentStatus,
    required this.assignedAt,
  });

  factory ClaimOrderData.fromJson(Map<String, dynamic> json) =>
      _$ClaimOrderDataFromJson(json);

  Map<String, dynamic> toJson() => _$ClaimOrderDataToJson(this);

  ClaimedOrderEntity toDomain() {
    return ClaimedOrderEntity(
      orderId: orderId,
      orderNumber: orderNumber,
      status: status,
      assignmentStatus: assignmentStatus,
      assignedAt: assignedAt,
    );
  }
}
