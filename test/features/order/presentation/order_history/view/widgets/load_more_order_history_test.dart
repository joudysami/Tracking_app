import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/utils/pagination/pagination_state.dart';
import 'package:tracking_app/features/order/core/load_more_button.dart';
import 'package:tracking_app/features/order/presentation/order_history/view/widgets/load_more_order_history.dart';
import 'package:tracking_app/features/order/presentation/order_history/view_model/order_history_state.dart';

void main() {
  setUpAll(() {
    EasyLocalization.logger.enableBuildModes = [];
  });

  Future<void> pump(
    WidgetTester tester,
    OrderHistoryState state,
    VoidCallback onLoadMore,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OrderHistoryLoadMoreFooter(
            state: state,
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
        const OrderHistoryState(status: PaginationStatus.loadingMore),
        () {},
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('hides everything when there is no more data', (tester) async {
      await pump(
        tester,
        const OrderHistoryState(
          status: PaginationStatus.success,
          hasMore: false,
        ),
        () {},
      );

      expect(find.byType(LoadMoreButton), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows retry when loading more failed', (tester) async {
      var called = 0;
      await pump(
        tester,
        const OrderHistoryState(status: PaginationStatus.errorLoadingMore),
        () => called++,
      );

      expect(find.text(LocaleKeys.commonRetry.tr()), findsOneWidget);
      await tester.tap(find.text(LocaleKeys.commonRetry.tr()));
      await tester.pump();

      expect(called, 1);
    });

    testWidgets('shows the load more button on success', (tester) async {
      var called = 0;
      await pump(
        tester,
        const OrderHistoryState(status: PaginationStatus.success),
        () => called++,
      );

      expect(find.byType(LoadMoreButton), findsOneWidget);
      await tester.tap(find.byType(LoadMoreButton));
      await tester.pump();

      expect(called, 1);
    });
  });
}
