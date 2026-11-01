import 'order_status_progress.dart';

bool isOrderHistoryStatus(String status) {
  switch (normalizeOrderStatus(status)) {
    case 'delivered':
    case 'cancelled':
      return true;
    default:
      return false;
  }
}
