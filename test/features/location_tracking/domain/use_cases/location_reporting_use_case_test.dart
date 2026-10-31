import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/error/app_error.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/location_entity.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/location_report_entity.dart';
import 'package:tracking_app/features/location_tracking/domain/repos/location_repo.dart';
import 'package:tracking_app/features/location_tracking/domain/use_cases/location_reporting_use_case.dart';

class FakeLocationRepo implements LocationRepo {
  BaseResponse<LocationReportEntity>? reportLocationResponse;
  LocationEntity? capturedLocation;
  int reportLocationCallCount = 0;

  @override
  Future<BaseResponse<LocationReportEntity>?> reportLocation(
    LocationEntity location,
  ) async {
    reportLocationCallCount++;
    capturedLocation = location;
    return reportLocationResponse;
  }

  @override
  Future<BaseResponse<LocationPermission>> checkAndRequestPermission() {
    throw UnimplementedError();
  }

  @override
  Future<BaseResponse<LocationPermission>> checkPermission() {
    throw UnimplementedError();
  }

  @override
  Future<BaseResponse<Position>> getCurrentPosition() {
    throw UnimplementedError();
  }

  @override
  Stream<LocationEntity> getPositionStream() {
    throw UnimplementedError();
  }

  @override
  Future<BaseResponse<bool>> isLocationServiceEnabled() {
    throw UnimplementedError();
  }

  @override
  Future<BaseResponse<bool>> openAppSettings() {
    throw UnimplementedError();
  }

  @override
  Future<BaseResponse<bool>> openLocationSettings() {
    throw UnimplementedError();
  }

  @override
  Future<BaseResponse<LocationPermission>> requestPermission() {
    throw UnimplementedError();
  }
}

void main() {
  late FakeLocationRepo fakeRepo;
  late LocationReportingUseCase useCase;

  final tLocation = LocationEntity(
    lat: 30.0444,
    lng: 31.2357,
    recordedAt: DateTime.utc(2026, 10, 23, 12, 0, 0),
  );

  setUp(() {
    fakeRepo = FakeLocationRepo();
    useCase = LocationReportingUseCase(fakeRepo);
  });

  group('LocationReportingUseCase', () {
    test('delegates to the repo and returns the same response', () async {
      final expectedResponse = SuccessResponse<LocationReportEntity>(
        LocationReportEntity(
          recordedAt: tLocation.recordedAt,
          updatedOrderIds: const ['order_1'],
          broadcast: true,
        ),
      );
      fakeRepo.reportLocationResponse = expectedResponse;

      final result = await useCase(tLocation);

      expect(result, same(expectedResponse));
      expect(fakeRepo.reportLocationCallCount, 1);
      expect(fakeRepo.capturedLocation, tLocation);
    });

    test('passes an ErrorResponse through unchanged', () async {
      final expectedResponse = ErrorResponse<LocationReportEntity>(
        appError: BadResponseError('Network failure'),
      );
      fakeRepo.reportLocationResponse = expectedResponse;

      final result = await useCase(tLocation);

      expect(result, same(expectedResponse));
      expect(fakeRepo.reportLocationCallCount, 1);
      expect(fakeRepo.capturedLocation, tLocation);
    });

    test('returns null when repo reportLocation throttles', () async {
      fakeRepo.reportLocationResponse = null;

      final result = await useCase(tLocation);

      expect(result, isNull);
      expect(fakeRepo.reportLocationCallCount, 1);
      expect(fakeRepo.capturedLocation, tLocation);
    });
  });
}
