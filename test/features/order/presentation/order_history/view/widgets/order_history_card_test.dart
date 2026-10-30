import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/features/order/domain/entities/order_history_entity.dart';
import 'package:tracking_app/features/order/presentation/order_history/view/widgets/complete_or_cancelled_text.dart';
import 'package:tracking_app/features/order/presentation/order_history/view/widgets/order_address_card.dart';
import 'package:tracking_app/features/order/presentation/order_history/view/widgets/order_history_card.dart';

import '../../../../../../support/test_localization.dart';

void main() {
  setUpAll(loadEnglishTranslations);

  Future<void> pump(
    WidgetTester tester,
    OrderHistoryEntity order, {
    VoidCallback? onTap,
  }) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        child: MaterialApp(
          home: Scaffold(
            body: OrderHistoryCard(order: order, onTap: onTap),
          ),
        ),
      ),
    );
  }

  group('OrderHistoryCard', () {
    testWidgets('renders title, number, status and both address cards', (
      tester,
    ) async {
      await pump(
        tester,
        const OrderHistoryEntity(
          id: '1',
          orderNumber: '#1',
          status: 'DELIVERED',
        ),
      );

      expect(find.text(LocaleKeys.homeFlowerOrder.tr()), findsOneWidget);
      expect(find.text('#1'), findsOneWidget);
      expect(find.byType(CompleteOrCancelledText), findsOneWidget);
      expect(find.text(LocaleKeys.statusDelivered.tr()), findsOneWidget);
      expect(find.byType(OrderAddressCard), findsNWidgets(2));
    });

    testWidgets('invokes onTap when tapped', (tester) async {
      var called = 0;
      await pump(
        tester,
        const OrderHistoryEntity(
          id: '1',
          orderNumber: '#1',
          status: 'CANCELLED',
        ),
        onTap: () => called++,
      );

      await tester.tap(find.byType(OrderHistoryCard));
      await tester.pump();

      expect(called, 1);
      expect(find.text(LocaleKeys.statusCancelled.tr()), findsOneWidget);
    });

    testWidgets('is inert without an onTap callback', (tester) async {
      await pump(
        tester,
        const OrderHistoryEntity(
          id: '1',
          orderNumber: '#1',
          status: 'DELIVERED',
        ),
      );

      await tester.tap(find.byType(OrderHistoryCard));
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });
}
