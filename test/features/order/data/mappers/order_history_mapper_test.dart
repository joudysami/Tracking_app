import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/order/data/mappers/order_history_mapper.dart';
import 'package:tracking_app/features/order/data/models/order_history_response.dart';

void main() {
  group('OrderHistoryMapper.toEntity', () {
    test('maps all fields including destination', () {
      const response = OrderHistoryResponse(
        id: '1',
        orderNumber: '#100',
        status: 'DELIVERED',
        statusDisplay: 'Delivered',
        placedAt: '2024-09-03',
        assignedAt: '2024-09-04',
        itemCount: 3,
        total: 300.5,
        isGift: true,
        destination: DestinationModel(
          recipientName: 'Nour',
          recipientPhone: '0123',
          addressLine: '20th st',
          city: 'Giza',
          area: 'Zayed',
          lat: 30.0,
          lng: 31.0,
        ),
      );

      final entity = response.toEntity();

      expect(entity.id, '1');
      expect(entity.orderNumber, '#100');
      expect(entity.status, 'DELIVERED');
      expect(entity.statusDisplay, 'Delivered');
      expect(entity.placedAt, '2024-09-03');
      expect(entity.assignedAt, '2024-09-04');
      expect(entity.itemCount, 3);
      expect(entity.total, 300.5);
      expect(entity.isGift, isTrue);
      expect(entity.destination?.recipientName, 'Nour');
      expect(entity.destination?.recipientPhone, '0123');
      expect(entity.destination?.addressLine, '20th st');
      expect(entity.destination?.city, 'Giza');
      expect(entity.destination?.area, 'Zayed');
      expect(entity.destination?.lat, 30.0);
      expect(entity.destination?.lng, 31.0);
    });

    test('maps null destination to null entity destination', () {
      const response = OrderHistoryResponse(id: '2');

      expect(response.toEntity().destination, isNull);
    });
  });

  group('DestinationMapper.toEntity', () {
    test('maps every destination field', () {
      const model = DestinationModel(
        recipientName: 'A',
        recipientPhone: 'B',
        addressLine: 'C',
        city: 'D',
        area: 'E',
        lat: 1.0,
        lng: 2.0,
      );

      final destination = model.toEntity();

      expect(destination.recipientName, 'A');
      expect(destination.recipientPhone, 'B');
      expect(destination.addressLine, 'C');
      expect(destination.city, 'D');
      expect(destination.area, 'E');
      expect(destination.lat, 1.0);
      expect(destination.lng, 2.0);
    });
  });
}
