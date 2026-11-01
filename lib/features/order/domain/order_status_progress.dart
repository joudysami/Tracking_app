import 'package:easy_localization/easy_localization.dart';
import 'package:tracking_app/core/localization/local_key.dart';

const orderProgressSegmentCount = 5;

/// Read-only progress for the details header.
///
/// Unknown statuses stay at zero so the bar does not imply a step
/// the API did not report.
int completedOrderProgressSegments(String status) {
  switch (normalizeOrderStatus(status)) {
    // A claimed order stays 'placed' on the backend while the driver
    // works stage 1 (assignment status is 'Accepted').
    case 'placed':
    case 'preparing':
    case 'accepted':
      return 1;
    case 'picked':
      return 2;
    case 'out_for_delivery':
      return 3;
    case 'arrived':
      return 4;
    case 'awaiting_delivery_confirmation':
      return orderProgressSegmentCount;
    case 'delivered':
      return orderProgressSegmentCount;
    case 'pending':
    case 'cancelled':
      return 0;
    default:
      return 0;
  }
}

/// The status each stage button sends to PATCH /api/orders/{id}/status.
///
/// Backend timeline:
/// PLACED -> PREPARING -> PICKED_UP -> OUT_FOR_DELIVERY -> ARRIVED
/// -> AWAITING_DELIVERY_CONFIRMATION (DELIVERED is done by the customer).
String? getNextOrderStatus(String currentStatus) {
  switch (normalizeOrderStatus(currentStatus)) {
    case 'placed':
    case 'preparing':
    case 'accepted':
      return 'PICKED_UP';
    case 'picked':
      return 'OUT_FOR_DELIVERY';
    case 'out_for_delivery':
      return 'ARRIVED';
    case 'arrived':
      return 'AWAITING_DELIVERY_CONFIRMATION';
    default:
      return null;
  }
}

String? getOrderActionLabelKey(String currentStatus) {
  switch (normalizeOrderStatus(currentStatus)) {
    case 'placed':
    case 'preparing':
    case 'accepted':
      return LocaleKeys.orderDetailsArrivedAtPickup;

    case 'picked':
      return LocaleKeys.orderDetailsStartDeliver;

    case 'out_for_delivery':
      return LocaleKeys.orderDetailsArrivedToUser;

    case 'arrived':
    case 'awaiting_delivery_confirmation':
    case 'delivered':
      return LocaleKeys.orderDetailsDeliveredToUser;

    case 'pending':
    case 'cancelled':
    default:
      return null;
  }
}

String? orderStatusLocalizationKey(String status) {
  switch (normalizeOrderStatus(status)) {
    case 'pending':
      return LocaleKeys.statusPending;
    case 'placed':
      return LocaleKeys.statusPlaced;
    case 'preparing':
      return LocaleKeys.statusPreparing;
    case 'accepted':
      return LocaleKeys.statusAccepted;
    case 'picked':
      return LocaleKeys.statusPicked;
    case 'out_for_delivery':
      return LocaleKeys.statusOutForDelivery;
    case 'awaiting_delivery_confirmation':
      return LocaleKeys.statusAwaitingDeliveryConfirmation;
    case 'arrived':
      return LocaleKeys.statusArrived;
    case 'delivered':
      return LocaleKeys.statusDelivered;
    case 'cancelled':
      return LocaleKeys.statusCancelled;
    default:
      return null;
  }
}

String normalizeOrderStatus(String status) {
  final withWords = status.replaceAllMapped(
    RegExp(r'([a-z])([A-Z])'),
    (match) => '${match[1]}_${match[2]}',
  );
  final normalized = withWords.trim().toLowerCase().replaceAll(
    RegExp(r'[\s-]+'),
    '_',
  );
  switch (normalized) {
    case 'picked_up':
      return 'picked';
    default:
      return normalized;
  }
}

String formatOrderAmount(double amount) {
  if (amount == amount.roundToDouble()) {
    return amount.toStringAsFixed(0);
  }
  return amount.toStringAsFixed(2);
}

class OrderDateLabels {
  final List<String> weekdays;
  final List<String> months;
  final String am;
  final String pm;

  const OrderDateLabels({
    required this.weekdays,
    required this.months,
    required this.am,
    required this.pm,
  });

  static const english = OrderDateLabels(
    weekdays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    months: [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ],
    am: 'AM',
    pm: 'PM',
  );
}

OrderDateLabels currentOrderDateLabels() {
  return OrderDateLabels(
    weekdays: [
      LocaleKeys.dateMon.tr(),
      LocaleKeys.dateTue.tr(),
      LocaleKeys.dateWed.tr(),
      LocaleKeys.dateThu.tr(),
      LocaleKeys.dateFri.tr(),
      LocaleKeys.dateSat.tr(),
      LocaleKeys.dateSun.tr(),
    ],
    months: [
      LocaleKeys.dateJan.tr(),
      LocaleKeys.dateFeb.tr(),
      LocaleKeys.dateMar.tr(),
      LocaleKeys.dateApr.tr(),
      LocaleKeys.dateMay.tr(),
      LocaleKeys.dateJun.tr(),
      LocaleKeys.dateJul.tr(),
      LocaleKeys.dateAug.tr(),
      LocaleKeys.dateSep.tr(),
      LocaleKeys.dateOct.tr(),
      LocaleKeys.dateNov.tr(),
      LocaleKeys.dateDec.tr(),
    ],
    am: LocaleKeys.dateAm.tr(),
    pm: LocaleKeys.datePm.tr(),
  );
}

String formatOrderCreatedAt(
  DateTime createdAt, {
  OrderDateLabels labels = OrderDateLabels.english,
}) {
  final local = createdAt.toLocal();
  final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
  final minute = local.minute.toString().padLeft(2, '0');
  final suffix = local.hour >= 12 ? labels.pm : labels.am;
  final day = local.day.toString().padLeft(2, '0');
  final hourText = hour.toString().padLeft(2, '0');
  return '${labels.weekdays[local.weekday - 1]}, $day '
      '${labels.months[local.month - 1]} ${local.year}, $hourText:$minute $suffix';
}
