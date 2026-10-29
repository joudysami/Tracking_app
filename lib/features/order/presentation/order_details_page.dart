// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:tracking_app/core/di/di.dart';
// import 'package:tracking_app/features/order/presentation/screen/order_details_screen.dart';
// import 'package:tracking_app/features/order/presentation/view_model/order_event.dart';
// import 'package:tracking_app/features/order/presentation/view_model/order_view_model.dart';

// Widget buildOrderDetailsPage(Object? extra) {
//   return BlocProvider(
//     create: (_) =>
//         getIt<OrderViewModel>()..doEvent(InitializeOrderEvent(extra)),
//     child: OrderDetailsScreen(order: extra),
//   );
// }
