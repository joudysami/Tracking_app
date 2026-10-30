import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/core/constant/widget_keys.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/utils/pagination/pagination_state.dart';

import '../../../../core/load_more_button.dart';
import '../../view_model/order_history_state.dart';

class OrderHistoryLoadMoreFooter extends StatelessWidget {
  const OrderHistoryLoadMoreFooter({
    super.key,
    required this.state,
    required this.onLoadMore,
  });

  final OrderHistoryState state;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    if (state.status == PaginationStatus.loadingMore) {
      return const Center(child: CircularProgressIndicator());
    }
    if (!state.hasMore) return const SizedBox.shrink();

    if (state.status == PaginationStatus.errorLoadingMore) {
      return Center(
        child: TextButton(
          onPressed: onLoadMore,
          child: Text(LocaleKeys.commonRetry.tr()),
        ),
      );
    }
    return Center(
      child: LoadMoreButton(
        key: WidgetKeys.orderHistoryLoadMoreButton,
        onPressed: onLoadMore,
      ),
    );
  }
}
