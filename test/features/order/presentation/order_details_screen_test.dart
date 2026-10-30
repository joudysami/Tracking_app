import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/localization.dart';
import 'package:easy_localization/src/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/features/home/domain/entity/avaliable_order_entity.dart';
import 'package:tracking_app/features/order/presentation/order_details/view/screen/order_details_screen.dart';
import 'package:tracking_app/features/order/presentation/order_details/view/widgets/order_progress_bar.dart';

void main() {
  setUpAll(() {
    EasyLocalization.logger.enableBuildModes = [];
  });

  testWidgets('shows the selected order and hides unsupported sections', (
    tester,
  ) async {
    await _pumpDetails(tester, _order(status: 'Picked'));

    expect(find.text(LocaleKeys.orderDetailsTitle.tr()), findsOneWidget);
    expect(find.textContaining(LocaleKeys.statusPicked.tr()), findsOneWidget);
    expect(find.textContaining('order-42'), findsOneWidget);
    expect(find.text('Flowery store'), findsOneWidget);
    expect(find.text('20th st, Sheikh Zayed, Giza'), findsWidgets);
    expect(find.text('Nour mohamed'), findsOneWidget);
    expect(find.text(LocaleKeys.orderDetailsTotal.tr()), findsOneWidget);
    expect(find.textContaining('3000'), findsOneWidget);
    expect(
      tester.widget<OrderProgressBar>(find.byType(OrderProgressBar)).completed,
      2,
    );

    expect(find.byIcon(Icons.phone), findsNothing);
    expect(find.byIcon(Icons.phone_outlined), findsNothing);
    expect(find.text(LocaleKeys.orderDetailsStartDeliver.tr()), findsNothing);
    expect(
      find.text(LocaleKeys.orderDetailsArrivedAtPickup.tr()),
      findsNothing,
    );
    expect(find.text(LocaleKeys.orderDetailsPaymentMethod.tr()), findsNothing);
    expect(find.text('Red roses,15 Pink Rose Bouquet'), findsNothing);
    expect(find.byType(ElevatedButton), findsNothing);
  });

  testWidgets('uses fallbacks for blank store and address fields', (
    tester,
  ) async {
    await _pumpDetails(
      tester,
      _order(storeName: '  ', storeAddress: '', customerAddress: ''),
    );

    expect(find.text(LocaleKeys.orderDetailsUnknownStore.tr()), findsOneWidget);
    expect(find.text(LocaleKeys.orderDetailsNoAddress.tr()), findsNWidgets(2));
  });

  testWidgets('shows an error when no order was passed', (tester) async {
    await _pumpDetails(tester, null);

    expect(find.text(LocaleKeys.orderDetailsUnavailable.tr()), findsOneWidget);
    expect(find.byType(OrderProgressBar), findsNothing);
  });

  testWidgets('localizes a documented status and the created time', (
    tester,
  ) async {
    final arabic = jsonDecode(
      await rootBundle.loadString('assets/translations/ar.json'),
    );
    Localization.load(
      const Locale('ar'),
      translations: Translations(Map<String, dynamic>.from(arabic as Map)),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: OrderDetailsScreen(
          order: _order(status: 'AWAITING_DELIVERY_CONFIRMATION'),
        ),
      ),
    );
    await tester.pump();

    expect(find.textContaining('بانتظار تأكيد التسليم'), findsOneWidget);
    expect(
      find.textContaining('الثلاثاء, 03 سبتمبر 2024, 11:00 ص'),
      findsOneWidget,
    );
    expect(
      tester.widget<OrderProgressBar>(find.byType(OrderProgressBar)).completed,
      3,
    );
  });

  testWidgets('keeps an unrecognized status read-only', (tester) async {
    await _pumpDetails(tester, _order(status: 'available'));

    expect(find.textContaining('available'), findsOneWidget);
    expect(
      tester.widget<OrderProgressBar>(find.byType(OrderProgressBar)).completed,
      0,
    );
    expect(find.byType(ElevatedButton), findsNothing);
  });
}

AvailableOrderEntity _order({
  String status = 'Accepted',
  String storeName = 'Flowery store',
  String storeAddress = '20th st, Sheikh Zayed, Giza',
  String customerAddress = '20th st, Sheikh Zayed, Giza',
}) {
  return AvailableOrderEntity(
    orderId: 'order-42',
    customerName: 'Nour mohamed',
    customerAddress: customerAddress,
    storeId: 'store-1',
    storeName: storeName,
    storeAddress: storeAddress,
    totalAmount: 3000,
    status: status,
    createdAt: DateTime(2024, 9, 3, 11),
  );
}

Future<void> _pumpDetails(
  WidgetTester tester,
  AvailableOrderEntity? order,
) async {
  await tester.pumpWidget(MaterialApp(home: OrderDetailsScreen(order: order)));
  await tester.pumpAndSettle();
}
