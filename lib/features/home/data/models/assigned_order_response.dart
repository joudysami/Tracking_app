import 'package:json_annotation/json_annotation.dart';
import 'package:tracking_app/features/home/domain/entity/claim_order_entity.dart';
import 'package:tracking_app/features/order/domain/enitiy/order_item_entity.dart';

part 'assigned_order_response.g.dart';

/// GET /api/orders/drivers/me/assigned-order
///
/// Every field is nullable on purpose: this endpoint answers `data: null`
/// when the driver holds no order, and a partially-shaped payload must never
/// turn into a parse error (that is what produced "Something went wrong.").
@JsonSerializable()
class AssignedOrderResponse {
  final bool? status;
  final int? code;
  final String? message;
  final AssignedOrderData? data;

  const AssignedOrderResponse({
    this.status,
    this.code,
    this.message,
    this.data,
  });

  factory AssignedOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$AssignedOrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AssignedOrderResponseToJson(this);
}

@JsonSerializable()
class AssignedOrderData {
  final String? id;
  final String? orderNumber;
  final String? status;
  final String? assignmentStatus;
  final String? placedAt;
  final String? assignedAt;
  final double? total;
  final String? paymentMethod;
  final String? paymentMethodDisplay;
  final AssignedOrderParty? pickup;
  final AssignedOrderParty? user;
  final AssignedOrderParty? destination;
  final List<AssignedOrderItem>? items;

  const AssignedOrderData({
    this.id,
    this.orderNumber,
    this.status,
    this.assignmentStatus,
    this.placedAt,
    this.assignedAt,
    this.total,
    this.paymentMethod,
    this.paymentMethodDisplay,
    this.pickup,
    this.user,
    this.destination,
    this.items,
  });

  factory AssignedOrderData.fromJson(Map<String, dynamic> json) =>
      _$AssignedOrderDataFromJson(json);

  Map<String, dynamic> toJson() => _$AssignedOrderDataToJson(this);

  ClaimedOrderEntity toDomain() {
    final recipient = destination ?? user;

    return ClaimedOrderEntity(
      orderId: id ?? '',
      orderNumber: orderNumber ?? id ?? '',
      status: status ?? '',
      assignmentStatus: assignmentStatus ?? '',
      assignedAt:
          DateTime.tryParse(assignedAt ?? placedAt ?? '') ?? DateTime.now(),
      storeName: pickup?.name ?? '',
      storeAddress: pickup?.fullAddress ?? '',
      customerName: recipient?.displayName ?? '',
      customerAddress: recipient?.fullAddress ?? '',
      totalAmount: total ?? 0,
      paymentMethod: paymentMethodDisplay ?? paymentMethod ?? '',
      items: (items ?? const []).map((item) => item.toDomain()).toList(),
      storeLatitude: pickup?.lat,
      storeLongitude: pickup?.lng,
      customerLatitude: recipient?.lat,
      customerLongitude: recipient?.lng,
    );
  }
}

/// One side of the delivery: the store, the ordering user or the destination.
/// The three payloads name their people differently (`name` versus
/// `recipientName`), which is resolved here instead of in three models.
@JsonSerializable()
class AssignedOrderParty {
  final String? storeId;
  final String? id;
  final String? name;
  final String? recipientName;
  final String? phone;
  final String? phoneNumber;
  final String? addressLine;
  final String? city;
  final String? area;
  final double? lat;
  final double? lng;

  const AssignedOrderParty({
    this.storeId,
    this.id,
    this.name,
    this.recipientName,
    this.phone,
    this.phoneNumber,
    this.addressLine,
    this.city,
    this.area,
    this.lat,
    this.lng,
  });

  factory AssignedOrderParty.fromJson(Map<String, dynamic> json) =>
      _$AssignedOrderPartyFromJson(json);

  Map<String, dynamic> toJson() => _$AssignedOrderPartyToJson(this);

  String get displayName =>
      _firstOfNonEmpty([name, recipientName, addressLine]);

  String get fullAddress => _join([addressLine, area, city]);
}

@JsonSerializable()
class AssignedOrderItem {
  final String? productId;
  final String? productName;
  final String? productImageUrl;
  final double? unitPrice;
  final int? quantity;

  const AssignedOrderItem({
    this.productId,
    this.productName,
    this.productImageUrl,
    this.unitPrice,
    this.quantity,
  });

  factory AssignedOrderItem.fromJson(Map<String, dynamic> json) =>
      _$AssignedOrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$AssignedOrderItemToJson(this);

  OrderItemEntity toDomain() {
    return OrderItemEntity(
      name: productName ?? '',
      imageUrl: productImageUrl,
      quantity: quantity ?? 0,
      price: unitPrice ?? 0,
    );
  }
}

String _firstOfNonEmpty(List<String?> values) {
  for (final value in values) {
    if (value != null && value.trim().isNotEmpty) return value.trim();
  }
  return '';
}

String _join(List<String?> values) {
  return values
      .where((value) => value != null && value.trim().isNotEmpty)
      .map((value) => value!.trim())
      .join(', ');
}
