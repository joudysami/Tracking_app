import 'package:equatable/equatable.dart';
import 'package:tracking_app/features/order/domain/enitiy/order_item_entity.dart';

class ClaimedOrderEntity extends Equatable {
  final String orderId;
  final String orderNumber;
  final String status;
  final String assignmentStatus;
  final DateTime assignedAt;

  /// Filled only by the assigned-order endpoint; the claim response carries
  /// none of it, so every value below stays empty for a freshly claimed order.
  final String storeName;
  final String storeAddress;
  final String? storeImageUrl;
  final String customerName;
  final String customerAddress;
  final double totalAmount;
  final String paymentMethod;
  final List<OrderItemEntity> items;
  final double? storeLatitude;
  final double? storeLongitude;
  final double? customerLatitude;
  final double? customerLongitude;

  const ClaimedOrderEntity({
    required this.orderId,
    required this.orderNumber,
    required this.status,
    required this.assignmentStatus,
    required this.assignedAt,
    this.storeName = '',
    this.storeAddress = '',
    this.storeImageUrl,
    this.customerName = '',
    this.customerAddress = '',
    this.totalAmount = 0,
    this.paymentMethod = '',
    this.items = const [],
    this.storeLatitude,
    this.storeLongitude,
    this.customerLatitude,
    this.customerLongitude,
  });

  /// True when the backend sent the full order, not just the claim summary.
  bool get hasDetails => storeName.trim().isNotEmpty || items.isNotEmpty;

  @override
  List<Object?> get props => [
    orderId,
    orderNumber,
    status,
    assignmentStatus,
    assignedAt,
    storeName,
    storeAddress,
    storeImageUrl,
    customerName,
    customerAddress,
    totalAmount,
    paymentMethod,
    items,
    storeLatitude,
    storeLongitude,
    customerLatitude,
    customerLongitude,
  ];
}
