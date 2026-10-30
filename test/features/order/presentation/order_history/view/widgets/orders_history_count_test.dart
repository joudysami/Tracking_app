import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/features/order/presentation/order_history/view/widgets/orders_history_count.dart';

import '../../../../../../support/test_localization.dart';

void main() {
  setUpAll(loadEnglishTranslations);

  Future<void> pump(
    WidgetTester tester, {
    int? completedCount,
    int? cancelledCount,
  }) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        child: MaterialApp(
          home: Scaffold(
            body: OrdersHistoryCount(
              completedCount: completedCount,
              cancelledCount: cancelledCount,
            ),
          ),
        ),
      ),
    );
  }

  group('OrdersHistoryCount', () {
    testWidgets('shows the provided counts', (tester) async {
      await pump(tester, completedCount: 3, cancelledCount: 5);

      expect(find.text('5'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text(LocaleKeys.statusCancelled.tr()), findsOneWidget);
      expect(find.text(LocaleKeys.statusDelivered.tr()), findsOneWidget);
      expect(find.byIcon(Icons.cancel_outlined), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline_rounded), findsOneWidget);
    });

    testWidgets('falls back to zero for null counts', (tester) async {
      await pump(tester);

      expect(find.text('0'), findsNWidgets(2));
    });
  });
}
