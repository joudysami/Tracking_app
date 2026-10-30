import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/order/data/mappers/pagination_mapper.dart';
import 'package:tracking_app/features/order/data/models/pagination_model.dart';

void main() {
  group('PaginationMapper.toEntity', () {
    test('maps every field', () {
      final model = PaginationModel(
        page: 2,
        pageSize: 10,
        totalCount: 42,
        totalPages: 5,
        hasNextPage: true,
        hasPreviousPage: true,
      );

      final params = model.toEntity();

      expect(params.page, 2);
      expect(params.pageSize, 10);
      expect(params.totalCount, 42);
      expect(params.totalPages, 5);
      expect(params.hasNextPage, isTrue);
      expect(params.hasPreviousPage, isTrue);
    });

    test('keeps null fields null', () {
      final params = PaginationModel().toEntity();

      expect(params.page, isNull);
      expect(params.pageSize, isNull);
      expect(params.totalCount, isNull);
      expect(params.totalPages, isNull);
      expect(params.hasNextPage, isNull);
      expect(params.hasPreviousPage, isNull);
    });
  });
}
