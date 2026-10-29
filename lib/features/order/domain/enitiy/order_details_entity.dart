import 'package:equatable/equatable.dart';
import 'package:tracking_app/features/home/domain/entity/avaliable_order_entity.dart';
import 'package:tracking_app/features/home/domain/entity/claim_order_entity.dart';
import 'package:tracking_app/features/order/domain/enitiy/order_item_entity.dart';

class OrderDetailsEntity extends Equatable {
  final String orderId;
  final String orderNumber;
  final String status;
  final String createdAt;
  final String customerName;
  final String customerAddress;
  final String storeName;
  final String storeAddress;
  final double totalAmount;
  final String paymentMethod;
  final List<OrderItemEntity> items;

  const OrderDetailsEntity({
    required this.orderId,
    required this.orderNumber,
    required this.status,
    required this.createdAt,
    required this.customerName,
    required this.customerAddress,
    required this.storeName,
    required this.storeAddress,
    required this.totalAmount,
    required this.paymentMethod,
    required this.items,
  });

  factory OrderDetailsEntity.fromAvailableOrder(AvailableOrderEntity order) {
    return OrderDetailsEntity(
      orderId: order.orderId,
      orderNumber: order.orderId,
      status: order.status,
      createdAt: order.createdAt.toIso8601String(),
      customerName: order.customerName,
      customerAddress: order.customerAddress,
      storeName: order.storeName,
      storeAddress: order.storeAddress,
      totalAmount: order.totalAmount,
      paymentMethod: 'Cash on delivery',
      items: const [
        OrderItemEntity(
          name: 'Red roses,15 Pink Rose Bouquet',
          imageUrl: null,
          quantity: 1,
          price: 600,
        ),
        OrderItemEntity(
          name: 'Red roses,15 Pink Rose Bouquet',
          imageUrl: null,
          quantity: 1,
          price: 600,
        ),
      ],
    );
  }

  factory OrderDetailsEntity.fromClaimedOrder(ClaimedOrderEntity order) {
    return OrderDetailsEntity(
      orderId: order.orderId,
      orderNumber: order.orderNumber,
      status: order.status,
      createdAt: order.assignedAt.toIso8601String(),
      customerName: 'Nour mohamed',
      customerAddress: '20th st, Sheikh Zayed, Giza',
      storeName: 'Flowery store',
      storeAddress: '20th st, Sheikh Zayed, Giza',
      totalAmount: 3000,
      paymentMethod: 'Cash on delivery',
      items: const [
        OrderItemEntity(
          name: 'Red roses,15 Pink Rose Bouquet',
          imageUrl: null,
          quantity: 1,
          price: 600,
        ),
        OrderItemEntity(
          name: 'Red roses,15 Pink Rose Bouquet',
          imageUrl: null,
          quantity: 1,
          price: 600,
        ),
      ],
    );
  }

  OrderDetailsEntity copyWith({
    String? orderId,
    String? orderNumber,
    String? status,
    String? createdAt,
    String? customerName,
    String? customerAddress,
    String? storeName,
    String? storeAddress,
    double? totalAmount,
    String? paymentMethod,
    List<OrderItemEntity>? items,
  }) {
    return OrderDetailsEntity(
      orderId: orderId ?? this.orderId,
      orderNumber: orderNumber ?? this.orderNumber,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      customerName: customerName ?? this.customerName,
      customerAddress: customerAddress ?? this.customerAddress,
      storeName: storeName ?? this.storeName,
      storeAddress: storeAddress ?? this.storeAddress,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [
    orderId,
    orderNumber,
    status,
    createdAt,
    customerName,
    customerAddress,
    storeName,
    storeAddress,
    totalAmount,
    paymentMethod,
    items,
  ];
}
