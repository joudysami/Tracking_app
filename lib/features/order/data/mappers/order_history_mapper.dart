import 'package:tracking_app/features/order/data/models/order_history_response.dart';

import '../../domain/entities/order_history_entity.dart';

extension OrderHistoryMapper on OrderHistoryResponse {
  OrderHistoryEntity toEntity() {
    return OrderHistoryEntity(
      id: id,
      orderNumber: orderNumber,
      status: status,
      destination: destination?.toEntity(),
      assignedAt: assignedAt,
      isGift: isGift,
      itemCount: itemCount,
      placedAt: placedAt,
      statusDisplay: statusDisplay,
      total: total,
    );
  }
}

extension DestinationMapper on DestinationModel {
  Destination toEntity() {
    return Destination(
      addressLine: addressLine,
      area: area,
      city: city,
      lat: lat,
      lng: lng,
      recipientName: recipientName,
      recipientPhone: recipientPhone,
    );
  }
}
