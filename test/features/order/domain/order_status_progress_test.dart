import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/features/order/domain/order_status_progress.dart';

void main() {
  test('maps verified statuses onto the four screenshot segments', () {
    expect(completedOrderProgressSegments('Accepted'), 1);
    expect(completedOrderProgressSegments('picked'), 2);
    expect(completedOrderProgressSegments('PICKED_UP'), 2);
    expect(completedOrderProgressSegments('Out for delivery'), 3);
    expect(completedOrderProgressSegments('OUT_FOR_DELIVERY'), 3);
    expect(completedOrderProgressSegments('AWAITING_DELIVERY_CONFIRMATION'), 3);
    expect(completedOrderProgressSegments('arrived'), 4);
    expect(completedOrderProgressSegments('ARRIVED'), 4);
    expect(completedOrderProgressSegments('Delivered'), 4);
  });

  test('does not invent progress for unknown or empty statuses', () {
    expect(completedOrderProgressSegments(''), 0);
    expect(completedOrderProgressSegments('available'), 0);
    expect(completedOrderProgressSegments('pending'), 0);
    expect(completedOrderProgressSegments('Placed'), 0);
    expect(completedOrderProgressSegments('PLACED'), 0);
    expect(completedOrderProgressSegments('cancelled'), 0);
  });

  test('localizes only known status values', () {
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
    expect(orderStatusLocalizationKey('ready'), isNull);
  });

  test('formats money without trailing zeros', () {
    expect(formatOrderAmount(3000), '3000');
    expect(formatOrderAmount(3000.5), '3000.50');
  });

  test('formats the created date from the order timestamp', () {
    final createdAt = DateTime(2024, 9, 3, 11);
    expect(formatOrderCreatedAt(createdAt), 'Tue, 03 Sep 2024, 11:00 AM');
  });

  test('formats the created date with Arabic labels', () {
    const labels = OrderDateLabels(
      weekdays: [
        'الإثنين',
        'الثلاثاء',
        'الأربعاء',
        'الخميس',
        'الجمعة',
        'السبت',
        'الأحد',
      ],
      months: [
        'يناير',
        'فبراير',
        'مارس',
        'أبريل',
        'مايو',
        'يونيو',
        'يوليو',
        'أغسطس',
        'سبتمبر',
        'أكتوبر',
        'نوفمبر',
        'ديسمبر',
      ],
      am: 'ص',
      pm: 'م',
    );
    final createdAt = DateTime(2024, 9, 3, 11);
    expect(
      formatOrderCreatedAt(createdAt, labels: labels),
      'الثلاثاء, 03 سبتمبر 2024, 11:00 ص',
    );
  });
}
