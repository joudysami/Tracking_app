import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/location_entity.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/location_report_entity.dart';
import 'package:tracking_app/features/location_tracking/domain/repos/location_repo.dart';
import 'package:tracking_app/features/location_tracking/domain/use_cases/location_tracking_use_case.dart';

class FakeLocationRepo implements LocationRepo {
  Stream<LocationEntity>? positionStream;
  int getPositionStreamCallCount = 0;

  @override
  Stream<LocationEntity> getPositionStream() {
    getPositionStreamCallCount++;
    return positionStream!;
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
  Future<BaseResponse<LocationReportEntity>?> reportLocation(
    LocationEntity location,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<BaseResponse<LocationPermission>> requestPermission() {
    throw UnimplementedError();
  }
}

void main() {
  late FakeLocationRepo fakeRepo;
  late LocationTrackingUseCase useCase;

  final tLocation = LocationEntity(
    lat: 30.0444,
    lng: 31.2357,
    recordedAt: DateTime.utc(2026, 10, 23, 12, 0, 0),
  );

  setUp(() {
    fakeRepo = FakeLocationRepo();
    useCase = LocationTrackingUseCase(fakeRepo);
  });

  group('LocationTrackingUseCase', () {
    test('delegates to the repo and returns the expected stream', () async {
      final expectedStream = Stream.fromIterable([tLocation]);
      fakeRepo.positionStream = expectedStream;

      final result = useCase();

      expect(await result.first, tLocation);
      expect(fakeRepo.getPositionStreamCallCount, 1);
    });

    test('increments call counter when invoked', () {
      final expectedStream = Stream<LocationEntity>.empty();
      fakeRepo.positionStream = expectedStream;

      useCase();

      expect(fakeRepo.getPositionStreamCallCount, 1);
    });
  });
}
