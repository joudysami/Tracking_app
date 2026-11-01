import 'package:tracking_app/features/order/core/order_status_progress.dart';

import '../../presentation/order_history/view/widgets/complete_or_cancelled_text.dart';

extension CardStatusMapper on String? {
  CardStatus toCardStatus() {
    return normalizeOrderStatus(this ?? '') == 'cancelled'
        ? CardStatus.cancelled
        : CardStatus.complete;
  }
}
