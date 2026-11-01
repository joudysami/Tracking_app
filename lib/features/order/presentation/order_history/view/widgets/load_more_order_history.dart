import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/core/constant/widget_keys.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/utils/pagination/pagination_state.dart';

class OrderHistoryLoadMoreFooter extends StatelessWidget {
  const OrderHistoryLoadMoreFooter({
    super.key,
    required this.status,
    required this.onLoadMore,
  });

  final PaginationStatus status;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    if (status == PaginationStatus.loadingMore) {
      return const Center(child: CircularProgressIndicator());
    }

    if (status == PaginationStatus.errorLoadingMore) {
      return Center(
        child: TextButton(
          key: WidgetKeys.orderHistoryLoadMoreRetry,
          onPressed: onLoadMore,
          child: Text(LocaleKeys.commonRetry.tr()),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
