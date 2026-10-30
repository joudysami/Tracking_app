import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/order/data/mappers/order_history_status_mapper.dart';
import 'package:tracking_app/features/order/presentation/order_history/view/widgets/complete_or_cancelled_text.dart';

void main() {
  group('CardStatusMapper.toCardStatus', () {
    test('maps cancelled variants to cancelled', () {
      expect('CANCELLED'.toCardStatus(), CardStatus.cancelled);
      expect('cancelled'.toCardStatus(), CardStatus.cancelled);
      expect('Cancelled'.toCardStatus(), CardStatus.cancelled);
    });

    test('maps non-cancelled statuses to complete', () {
      expect('DELIVERED'.toCardStatus(), CardStatus.complete);
      expect('PLACED'.toCardStatus(), CardStatus.complete);
    });

    test('maps null and empty to complete', () {
      const String? nullStatus = null;
      expect(nullStatus.toCardStatus(), CardStatus.complete);
      expect(''.toCardStatus(), CardStatus.complete);
    });
  });
}
