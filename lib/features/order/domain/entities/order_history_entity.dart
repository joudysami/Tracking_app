import 'package:equatable/equatable.dart';

class OrderHistoryEntity extends Equatable {
  final String? id;
  final String? orderNumber;
  final String? status;
  final String? statusDisplay;
  final String? placedAt;
  final String? assignedAt;
  final int? itemCount;
  final double? total;
  final bool? isGift;
  final Destination? destination;

  const OrderHistoryEntity({
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

  @override
  List<Object?> get props => [
    id,
    orderNumber,
    status,
    statusDisplay,
    placedAt,
    assignedAt,
    itemCount,
    total,
    isGift,
    destination,
  ];
}

class Destination extends Equatable {
  final String? recipientName;
  final String? recipientPhone;
  final String? addressLine;
  final String? city;
  final String? area;
  final double? lat;
  final double? lng;

  const Destination({
    this.recipientName,
    this.recipientPhone,
    this.addressLine,
    this.city,
    this.area,
    this.lat,
    this.lng,
  });

  @override
  List<Object?> get props => [
    recipientName,
    recipientPhone,
    addressLine,
    city,
    area,
    lat,
    lng,
  ];
}
