import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/home/domain/entity/avaliable_order_entity.dart';

part 'available_orders_model.g.dart';

@JsonSerializable()
class AvailableOrderModel extends AvailableOrderEntity {
  const AvailableOrderModel({
    required super.orderId,
    required super.customerName,
    required super.customerAddress,
    required super.storeId,
    required super.storeName,
    required super.storeAddress,
    required super.totalAmount,
    required super.status,
    required super.createdAt,
  });

  factory AvailableOrderModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$AvailableOrderModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AvailableOrderModelToJson(this);
}