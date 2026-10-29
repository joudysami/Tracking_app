import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/order/domain/enitiy/confirm_delivery_entity.dart';

part 'confirm_delivery_response.g.dart';

@JsonSerializable()
class ConfirmDeliveryResponse {
  final bool status;
  final int code;
  final String message;
  final ConfirmDeliveryData? data;

  const ConfirmDeliveryResponse({
    required this.status,
    required this.code,
    required this.message,
    this.data,
  });

  factory ConfirmDeliveryResponse.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$ConfirmDeliveryResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ConfirmDeliveryResponseToJson(this);
}

@JsonSerializable()
class ConfirmDeliveryData {
  final String orderId;
  final String status;
  final String confirmedAt;

  const ConfirmDeliveryData({
    required this.orderId,
    required this.status,
    required this.confirmedAt,
  });

  factory ConfirmDeliveryData.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$ConfirmDeliveryDataFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ConfirmDeliveryDataToJson(this);

  ConfirmDeliveryEntity toDomain() {
    return ConfirmDeliveryEntity(
      orderId: orderId,
      status: status,
      confirmedAt: confirmedAt,
    );
  }
}
