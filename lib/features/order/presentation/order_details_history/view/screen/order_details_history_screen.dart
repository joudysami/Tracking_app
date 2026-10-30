import 'package:flutter/material.dart';

class OrderDetailsHistoryScreen extends StatelessWidget {
  const OrderDetailsHistoryScreen({super.key, this.orderId});

  final String? orderId;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SizedBox.shrink());
  }
}
