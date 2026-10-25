import 'package:flutter/widgets.dart';
import 'package:tracking_app/features/home/domain/entity/avaliable_order_entity.dart';
import 'package:tracking_app/features/order/presentation/screen/order_details_screen.dart';

Widget buildOrderDetailsPage(Object? extra) {
  final order = extra is AvailableOrderEntity ? extra : null;
  return OrderDetailsScreen(order: order);
}
