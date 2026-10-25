import 'package:equatable/equatable.dart';

class ClaimedOrderEntity extends Equatable {
  final String orderId;
  final String orderNumber;
  final String status;
  final String assignmentStatus;
  final DateTime assignedAt;

  const ClaimedOrderEntity({
    required this.orderId,
    required this.orderNumber,
    required this.status,
    required this.assignmentStatus,
    required this.assignedAt,
  });
  @override
  List<Object?> get props => [
    orderId,
    orderNumber,
    status,
    assignmentStatus,
    assignedAt,
  ];
}
