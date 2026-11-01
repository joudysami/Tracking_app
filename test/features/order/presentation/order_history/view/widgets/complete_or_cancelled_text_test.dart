import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/features/order/presentation/order_history/view/widgets/complete_or_cancelled_text.dart';

void main() {
  setUpAll(() {
    EasyLocalization.logger.enableBuildModes = [];
  });

  Future<void> pump(WidgetTester tester, CardStatus status) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        child: MaterialApp(
          home: Scaffold(
            body: Center(child: CompleteOrCancelledText(status: status)),
          ),
        ),
      ),
    );
  }

  group('CompleteOrCancelledText', () {
    testWidgets('shows delivered label and check icon', (tester) async {
      await pump(tester, CardStatus.complete);

      expect(find.text(LocaleKeys.statusDelivered.tr()), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline_rounded), findsOneWidget);
      expect(find.byIcon(Icons.cancel_outlined), findsNothing);
    });

    testWidgets('shows cancelled label and cancel icon', (tester) async {
      await pump(tester, CardStatus.cancelled);

      expect(find.text(LocaleKeys.statusCancelled.tr()), findsOneWidget);
      expect(find.byIcon(Icons.cancel_outlined), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline_rounded), findsNothing);
    });
  });
}
