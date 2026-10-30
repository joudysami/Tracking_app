import 'package:easy_localization/easy_localization.dart';
import 'package:tracking_app/core/localization/local_key.dart';

const orderProgressSegmentCount = 4;

/// Read-only progress for the details header.
///
/// Unknown statuses stay at zero so the bar does not imply a step
/// the API did not report.
int completedOrderProgressSegments(String status) {
  switch (normalizeOrderStatus(status)) {
    case 'accepted':
      return 1;
    case 'picked':
      return 2;
    case 'out_for_delivery':
    case 'awaiting_delivery_confirmation':
      return 3;
    case 'arrived':
    case 'delivered':
      return orderProgressSegmentCount;
    case 'placed':
    case 'pending':
    case 'cancelled':
      return 0;
    default:
      return 0;
  }
}

String? orderStatusLocalizationKey(String status) {
  switch (normalizeOrderStatus(status)) {
    case 'pending':
      return LocaleKeys.statusPending;
    case 'placed':
      return LocaleKeys.statusPlaced;
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
