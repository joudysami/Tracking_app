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

  /// Delivery coordinates, when the backend provided them. `null` means the
  /// map falls back to the sample locations in [orderMapMock].
  final double? storeLatitude;
  final double? storeLongitude;
  final double? customerLatitude;
  final double? customerLongitude;

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
    this.storeLatitude,
    this.storeLongitude,
    this.customerLatitude,
    this.customerLongitude,
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

  /// The claim response carries no store, customer, items or amounts, so the
  /// sample values below are still what a freshly accepted order shows. The
  /// assigned-order endpoint fills them in, and real data always wins.
  factory OrderDetailsEntity.fromClaimedOrder(ClaimedOrderEntity order) {
    final hasRealData = order.hasDetails;

    return OrderDetailsEntity(
      orderId: order.orderId,
      orderNumber: order.orderNumber.isEmpty
          ? order.orderId
          : order.orderNumber,
      status: order.status,
      createdAt: order.assignedAt.toIso8601String(),
      customerName: hasRealData ? order.customerName : 'Nour mohamed',
      customerAddress: hasRealData
          ? order.customerAddress
          : '20th st, Sheikh Zayed, Giza',
      storeName: hasRealData ? order.storeName : 'Flowery store',
      storeAddress: hasRealData
          ? order.storeAddress
          : '20th st, Sheikh Zayed, Giza',
      totalAmount: hasRealData ? order.totalAmount : 3000,
      paymentMethod: order.paymentMethod.isEmpty
          ? 'Cash on delivery'
          : order.paymentMethod,
      items: hasRealData && order.items.isNotEmpty
          ? order.items
          : const [
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
      storeLatitude: order.storeLatitude,
      storeLongitude: order.storeLongitude,
      customerLatitude: order.customerLatitude,
      customerLongitude: order.customerLongitude,
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
    double? storeLatitude,
    double? storeLongitude,
    double? customerLatitude,
    double? customerLongitude,
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
      storeLatitude: storeLatitude ?? this.storeLatitude,
      storeLongitude: storeLongitude ?? this.storeLongitude,
      customerLatitude: customerLatitude ?? this.customerLatitude,
      customerLongitude: customerLongitude ?? this.customerLongitude,
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
    storeLatitude,
    storeLongitude,
    customerLatitude,
    customerLongitude,
  ];
}
