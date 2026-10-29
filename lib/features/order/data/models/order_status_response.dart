import 'package:json_annotation/json_annotation.dart';

part 'order_status_response.g.dart';

@JsonSerializable()
class OrderStatusResponse {
  final bool status;
  final int code;
  final String message;
  final OrderStatusData? data;

  const OrderStatusResponse({
    required this.status,
    required this.code,
    required this.message,
    this.data,
  });

  factory OrderStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderStatusResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderStatusResponseToJson(this);
}

@JsonSerializable()
class OrderStatusData {
  final String orderId;
  final String status;
  final String occurredAt;

  const OrderStatusData({
    required this.orderId,
    required this.status,
    required this.occurredAt,
  });

  factory OrderStatusData.fromJson(Map<String, dynamic> json) =>
      _$OrderStatusDataFromJson(json);

  Map<String, dynamic> toJson() => _$OrderStatusDataToJson(this);
}
