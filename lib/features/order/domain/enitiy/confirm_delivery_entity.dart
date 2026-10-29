import 'package:equatable/equatable.dart';

class ConfirmDeliveryEntity extends Equatable {
  final String orderId;
  final String status;
  final String confirmedAt;

  const ConfirmDeliveryEntity({
    required this.orderId,
    required this.status,
    required this.confirmedAt,
  });

  @override
  List<Object?> get props => [orderId, status, confirmedAt];
}
