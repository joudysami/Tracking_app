import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/order/presentation/order_details_history/view/screen/order_details_history_screen.dart';

void main() {
  group('OrderDetailsHistoryScreen', () {
    testWidgets('renders an empty scaffold', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: OrderDetailsHistoryScreen()),
      );

      expect(find.byType(OrderDetailsHistoryScreen), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('keeps the passed order id', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: OrderDetailsHistoryScreen(orderId: '7')),
      );

      final screen = tester.widget<OrderDetailsHistoryScreen>(
        find.byType(OrderDetailsHistoryScreen),
      );
      expect(screen.orderId, '7');
    });
  });
}
