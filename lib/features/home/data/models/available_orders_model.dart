import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/home/domain/entity/avaliable_order_entity.dart';

part 'available_orders_model.g.dart';

@JsonSerializable()
class AvailableOrderModel {
  final String orderId;
  final String customerName;
  final String customerAddress;
  final String storeId;
  final String storeName;

  final String storeAddress;
  final double totalAmount;
  final String status;
  final String createdAt;
  const AvailableOrderModel({
    required this.orderId,
    required this.customerName,
    required this.customerAddress,
    required this.storeId,
    required this.storeName,
    required this.storeAddress,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
  });

  factory AvailableOrderModel.fromJson(Map<String, dynamic> json) =>
      _$AvailableOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$AvailableOrderModelToJson(this);
  AvailableOrderEntity toDomain() {
    return AvailableOrderEntity(
      orderId: orderId,
      customerName: customerName,
      customerAddress: customerAddress,
      storeId: storeId,
      storeName: storeName,
      storeAddress: storeAddress,
      totalAmount: totalAmount,
      status: status,
      createdAt: DateTime.parse(createdAt),
    );
  }
}
