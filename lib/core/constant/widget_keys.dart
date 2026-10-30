import 'package:flutter/widgets.dart';

abstract final class WidgetKeys {
  static const Key orderHistoryShimmer = ValueKey('order_history_shimmer');
  static const Key orderHistoryErrorRetry = ValueKey(
    'order_history_error_retry',
  );
  static const Key orderHistoryEmpty = ValueKey('order_history_empty');
  static const Key orderHistoryLoadMoreButton = ValueKey(
    'order_history_load_more_button',
  );
}
