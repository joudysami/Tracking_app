import 'package:equatable/equatable.dart';

class OrderItemEntity extends Equatable {
  final String name;
  final String? imageUrl;
  final int quantity;
  final double price;

  const OrderItemEntity({
    required this.name,
    required this.imageUrl,
    required this.quantity,
    required this.price,
  });

  @override
  List<Object?> get props => [name, imageUrl, quantity, price];
}
