import 'package:json_annotation/json_annotation.dart';

part 'order_status_response.g.dart';

@JsonSerializable()
class OrderStatusResponse {
  final bool? status;
  final int? code;
  final String? message;
  final OrderStatusData? data;

  const OrderStatusResponse({this.status, this.code, this.message, this.data});

  factory OrderStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderStatusResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderStatusResponseToJson(this);
}

/// A status change can be acknowledged with a message and no payload, so
/// every field here is optional.
@JsonSerializable()
class OrderStatusData {
  final String? orderId;
  final String? status;
  final String? occurredAt;

  const OrderStatusData({this.orderId, this.status, this.occurredAt});

  factory OrderStatusData.fromJson(Map<String, dynamic> json) =>
      _$OrderStatusDataFromJson(json);

  Map<String, dynamic> toJson() => _$OrderStatusDataToJson(this);
}
