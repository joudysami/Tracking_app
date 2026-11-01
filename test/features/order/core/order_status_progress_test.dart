import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/features/order/core/order_status_progress.dart';

void main() {
  group('completedOrderProgressSegments', () {
    test('maps known progress statuses onto segments', () {
      expect(completedOrderProgressSegments('Accepted'), 1);
      expect(completedOrderProgressSegments('picked'), 2);
      expect(completedOrderProgressSegments('PICKED_UP'), 2);
      expect(completedOrderProgressSegments('Out for delivery'), 3);
      expect(completedOrderProgressSegments('OUT_FOR_DELIVERY'), 3);
      expect(
        completedOrderProgressSegments('AWAITING_DELIVERY_CONFIRMATION'),
        3,
      );
      expect(
        completedOrderProgressSegments('arrived'),
        orderProgressSegmentCount,
      );
      expect(
        completedOrderProgressSegments('Delivered'),
        orderProgressSegmentCount,
      );
    });

    test('keeps zero for non-progress or unknown statuses', () {
      expect(completedOrderProgressSegments(''), 0);
      expect(completedOrderProgressSegments('available'), 0);
      expect(completedOrderProgressSegments('pending'), 0);
      expect(completedOrderProgressSegments('PLACED'), 0);
      expect(completedOrderProgressSegments('cancelled'), 0);
    });
  });

  group('orderStatusLocalizationKey', () {
    test('returns key for known statuses', () {
      expect(
        orderStatusLocalizationKey('out-for-delivery'),
        LocaleKeys.statusOutForDelivery,
      );
      expect(orderStatusLocalizationKey('PLACED'), LocaleKeys.statusPlaced);
      expect(orderStatusLocalizationKey('PICKED_UP'), LocaleKeys.statusPicked);
      expect(
        orderStatusLocalizationKey('AWAITING_DELIVERY_CONFIRMATION'),
        LocaleKeys.statusAwaitingDeliveryConfirmation,
      );
    });

    test('returns null for unknown status', () {
      expect(orderStatusLocalizationKey('ready'), isNull);
    });
  });

  group('normalizeOrderStatus', () {
    test('splits camelCase and lowercases', () {
      expect(normalizeOrderStatus('OutForDelivery'), 'out_for_delivery');
    });

    test('maps picked_up to picked', () {
      expect(normalizeOrderStatus('PICKED_UP'), 'picked');
    });

    test('trims and replaces spaces and hyphens', () {
      expect(normalizeOrderStatus('  Out-for-Delivery '), 'out_for_delivery');
    });
  });

  group('formatOrderAmount', () {
    test('drops decimals for whole amounts', () {
      expect(formatOrderAmount(3000), '3000');
    });

    test('keeps two decimals for fractional amounts', () {
      expect(formatOrderAmount(3000.5), '3000.50');
    });
  });

  group('formatOrderCreatedAt', () {
    test('formats with english labels', () {
      expect(
        formatOrderCreatedAt(DateTime(2024, 9, 3, 11)),
        'Tue, 03 Sep 2024, 11:00 AM',
      );
    });

    test('pads hour and uses pm in the afternoon', () {
      expect(
        formatOrderCreatedAt(DateTime(2024, 12, 9, 13, 5)),
        'Mon, 09 Dec 2024, 01:05 PM',
      );
    });

    test('honours injected labels', () {
      const labels = OrderDateLabels(
        weekdays: ['a', 'Tue', 'c', 'd', 'e', 'f', 'g'],
        months: [
          'Jan',
          'b',
          'c',
          'd',
          'e',
          'f',
          'g',
          'h',
          'Sep',
          'j',
          'k',
          'l',
        ],
        am: 'AM',
        pm: 'PM',
      );
      expect(
        formatOrderCreatedAt(DateTime(2024, 9, 3, 11), labels: labels),
        'Tue, 03 Sep 2024, 11:00 AM',
      );
    });
  });
}
