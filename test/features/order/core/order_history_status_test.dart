import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/order/core/order_history_status.dart';

void main() {
  group('isOrderHistoryStatus', () {
    test('returns true for DELIVERED', () {
      expect(isOrderHistoryStatus('DELIVERED'), isTrue);
    });
    test('returns true for CANCELLED', () {
      expect(isOrderHistoryStatus('CANCELLED'), isTrue);
    });
    test('returns false for empty status', () {
      expect(isOrderHistoryStatus(''), isFalse);
    });
    for (final status in [
      'PLACED',
      'PREPARING',
      'PICKED_UP',
      'OUT_FOR_DELIVERY',
      'ARRIVED',
      'AWAITING_DELIVERY_CONFIRMATION',
    ]) {
      test('returns false for $status', () {
        expect(isOrderHistoryStatus(status), isFalse);
      });
    }
  });
}
