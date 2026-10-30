import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/features/order/core/load_more_button.dart';

void main() {
  setUpAll(() {
    EasyLocalization.logger.enableBuildModes = [];
  });

  group('LoadMoreButton', () {
    testWidgets('renders the load more label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: LoadMoreButton(onPressed: () {})),
        ),
      );

      expect(find.text(LocaleKeys.commonLoadMore.tr()), findsOneWidget);
    });

    testWidgets('invokes the callback when tapped', (tester) async {
      var called = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: LoadMoreButton(onPressed: () => called++)),
        ),
      );

      await tester.tap(find.byType(LoadMoreButton));
      await tester.pump();

      expect(called, 1);
    });
  });
}
