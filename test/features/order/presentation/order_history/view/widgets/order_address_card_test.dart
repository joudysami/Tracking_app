import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/features/order/presentation/order_history/view/widgets/order_address_card.dart';

import '../../../../../../support/test_localization.dart';

void main() {
  setUpAll(loadEnglishTranslations);

  Future<void> pump(
    WidgetTester tester, {
    bool isStore = false,
    String? addressLine,
    String? userName,
  }) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        child: MaterialApp(
          home: Scaffold(
            body: OrderAddressCard(
              isStore: isStore,
              addressLine: addressLine,
              userName: userName,
            ),
          ),
        ),
      ),
    );
  }

  group('OrderAddressCard', () {
    testWidgets('shows store copy without a dummy address when isStore', (
        tester,) async {
      await pump(tester, isStore: true);

      expect(find.text(LocaleKeys.homePickupAddress.tr()), findsOneWidget);
      expect(find.text(LocaleKeys.homeFloweryStore.tr()), findsOneWidget);
      expect(
        find.text(LocaleKeys.orderDetailsNoAddress.tr()),
        findsOneWidget,
      );
    });

    testWidgets('shows recipient copy for a user address', (tester) async {
      await pump(tester, userName: 'Nour', addressLine: '20th st');

      expect(find.text(LocaleKeys.homeUserAddress.tr()), findsOneWidget);
      expect(find.text('Nour'), findsOneWidget);
      expect(find.text('20th st'), findsOneWidget);
    });

    testWidgets('falls back when fields are null', (tester) async {
      await pump(tester);

      expect(find.text('_'), findsOneWidget);
      expect(find.text(LocaleKeys.orderDetailsNoAddress.tr()), findsOneWidget);
    });

    testWidgets('treats a blank address as missing', (tester) async {
      await pump(tester, addressLine: '   ', userName: 'Nour');

      expect(find.text(LocaleKeys.orderDetailsNoAddress.tr()), findsOneWidget);
    });
  });
}
