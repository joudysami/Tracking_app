import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/constant/widget_keys.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/utils/pagination/pagination_state.dart';
import 'package:tracking_app/features/order/presentation/order_history/view/widgets/load_more_order_history.dart';

void main() {
  setUpAll(() {
    EasyLocalization.logger.enableBuildModes = [];
  });

  Future<void> pump(WidgetTester tester, {
    required PaginationStatus status,
    required VoidCallback onLoadMore,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OrderHistoryLoadMoreFooter(
            status: status,
            onLoadMore: onLoadMore,
          ),
        ),
      ),
    );
    await tester.pump();
  }

  group('OrderHistoryLoadMoreFooter', () {
    testWidgets('shows a spinner while loading more', (tester) async {
      await pump(
        tester,
        status: PaginationStatus.loadingMore,
        onLoadMore: () {},
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'renders nothing on success (auto-load handles it)', (tester,) async {
      await pump(
        tester,
        status: PaginationStatus.success,
        onLoadMore: () {},
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byKey(WidgetKeys.orderHistoryLoadMoreRetry), findsNothing);
    });

    testWidgets('shows retry only when loading more failed', (tester) async {
      var called = 0;
      await pump(
        tester,
        status: PaginationStatus.errorLoadingMore,
        onLoadMore: () => called++,
      );

      expect(find.text(LocaleKeys.commonRetry.tr()), findsOneWidget);
      await tester.tap(find.byKey(WidgetKeys.orderHistoryLoadMoreRetry));
      await tester.pump();

      expect(called, 1);
    });

    testWidgets(
        'renders nothing while the first page is loading', (tester,) async {
      await pump(
        tester,
        status: PaginationStatus.loading,
        onLoadMore: () {},
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byKey(WidgetKeys.orderHistoryLoadMoreRetry), findsNothing);
    });
  });
}
