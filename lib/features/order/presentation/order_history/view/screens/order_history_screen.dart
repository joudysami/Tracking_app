import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_app/core/di/di.dart';

import '../../view_model/order_history_event.dart';
import '../../view_model/order_history_view_model.dart';
import 'order_history_view.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<OrderHistoryViewModel>()..onEvent(const LoadOrderHistory()),
      child: const OrderHistoryView(),
    );
  }
}
