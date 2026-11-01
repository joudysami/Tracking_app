import 'package:equatable/equatable.dart';

class AvailableOrderEntity extends Equatable {
  final String orderId;
  final String customerName;
  final String customerAddress;
  final String storeId;
  final String storeName;
  final String storeAddress;
  final double totalAmount;
  final String status;
  final DateTime createdAt;

  const AvailableOrderEntity({
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
  @override
  List<Object?> get props => [
    orderId,
    customerName,
    customerAddress,
    storeId,
    storeName,
    storeAddress,
    totalAmount,
    status,
    createdAt,
  ];
}
