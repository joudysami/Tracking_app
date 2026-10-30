import 'package:json_annotation/json_annotation.dart';

part 'order_history_response.g.dart';

@JsonSerializable()
class OrderHistoryResponse {
  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "orderNumber")
  final String? orderNumber;
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "statusDisplay")
  final String? statusDisplay;
  @JsonKey(name: "placedAt")
  final String? placedAt;
  @JsonKey(name: "assignedAt")
  final String? assignedAt;
  @JsonKey(name: "itemCount")
  final int? itemCount;
  @JsonKey(name: "total")
  final double? total;
  @JsonKey(name: "isGift")
  final bool? isGift;
  @JsonKey(name: "destination")
  final DestinationModel? destination;

  const OrderHistoryResponse({
    this.id,
    this.orderNumber,
    this.status,
    this.statusDisplay,
    this.placedAt,
    this.assignedAt,
    this.itemCount,
    this.total,
    this.isGift,
    this.destination,
  });

  factory OrderHistoryResponse.fromJson(Map<String, dynamic> json) {
    return _$OrderHistoryResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$OrderHistoryResponseToJson(this);
  }
}

@JsonSerializable()
class DestinationModel {
  @JsonKey(name: "recipientName")
  final String? recipientName;
  @JsonKey(name: "recipientPhone")
  final String? recipientPhone;
  @JsonKey(name: "addressLine")
  final String? addressLine;
  @JsonKey(name: "city")
  final String? city;
  @JsonKey(name: "area")
  final String? area;
  @JsonKey(name: "lat")
  final double? lat;
  @JsonKey(name: "lng")
  final double? lng;

  const DestinationModel({
    this.recipientName,
    this.recipientPhone,
    this.addressLine,
    this.city,
    this.area,
    this.lat,
    this.lng,
  });

  factory DestinationModel.fromJson(Map<String, dynamic> json) {
    return _$DestinationModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DestinationModelToJson(this);
  }
}
