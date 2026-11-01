import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/constant/widget_keys.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/features/order/data/api/order_status_api_values.dart';
import 'package:tracking_app/features/order/presentation/order_history/view/widgets/orders_history_count.dart';
import 'package:tracking_app/features/order/presentation/order_history/view_model/order_history_state.dart';

import '../../../../../../support/test_localization.dart';

void main() {
  setUpAll(loadEnglishTranslations);

  Future<void> pump(
    WidgetTester tester, {
        OrderCountState completed = const OrderCountState(),
        OrderCountState cancelled = const OrderCountState(),
        ValueChanged<String>? onRetry,
  }) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        child: MaterialApp(
          home: Scaffold(
            body: OrdersHistoryCount(
              completed: completed,
              cancelled: cancelled,
              onRetry: onRetry,
            ),
          ),
        ),
      ),
    );
  }

  group('OrdersHistoryCount', () {
    testWidgets('shows the provided counts', (tester) async {
      await pump(
        tester,
        completed: const OrderCountState(value: 3),
        cancelled: const OrderCountState(value: 5),
      );

      expect(find.text('5'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text(LocaleKeys.statusCancelled.tr()), findsOneWidget);
      expect(find.text(LocaleKeys.statusDelivered.tr()), findsOneWidget);
      expect(find.byIcon(Icons.cancel_outlined), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline_rounded), findsOneWidget);
    });

    testWidgets('falls back to zero for empty states', (tester) async {
      await pump(tester);

      expect(find.text('0'), findsNWidgets(2));
    });

    testWidgets('shows a spinner while a count is loading', (tester) async {
      await pump(
        tester,
        completed: const OrderCountState(loading: true),
      );

      expect(
        find.descendant(
          of: find.byKey(WidgetKeys.completedCountCard),
          matching: find.byType(CircularProgressIndicator),
        ),
        findsOneWidget,
      );
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('shows a refresh icon for a failed count', (tester) async {
      await pump(
        tester,
        cancelled: const OrderCountState(failed: true),
      );

      expect(
        find.descendant(
          of: find.byKey(WidgetKeys.cancelledCountCard),
          matching: find.byIcon(Icons.refresh_rounded),
        ),
        findsOneWidget,
      );
    });

    testWidgets('tapping a failed count calls onRetry with its status', (
        tester,) async {
      final retried = <String>[];
      await pump(
        tester,
        completed: const OrderCountState(failed: true),
        onRetry: retried.add,
      );

      await tester.tap(find.byKey(WidgetKeys.completedCountCard));
      await tester.pump();

      expect(retried, [OrderStatusApiValues.delivered]);
    });

    testWidgets('tapping a successful count does not retry', (tester) async {
      final retried = <String>[];
      await pump(
        tester,
        completed: const OrderCountState(value: 2),
        onRetry: retried.add,
      );

      await tester.tap(find.byKey(WidgetKeys.completedCountCard));
      await tester.pump();

      expect(retried, isEmpty);
    });
  });
}
