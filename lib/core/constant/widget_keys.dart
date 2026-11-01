import 'package:flutter/widgets.dart';

abstract final class WidgetKeys {
  static const Key orderHistoryShimmer = ValueKey('order_history_shimmer');
  static const Key orderHistoryErrorRetry = ValueKey(
    'order_history_error_retry',
  );
  static const Key orderHistoryEmpty = ValueKey('order_history_empty');
  static const Key orderHistoryLoadMoreRetry = ValueKey(
    'order_history_load_more_retry',
  );
  static const Key completedCountCard = ValueKey('completed_count_card');
  static const Key cancelledCountCard = ValueKey('cancelled_count_card');
}
