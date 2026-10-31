import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/error/app_error.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/location_entity.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/location_report_entity.dart';
import 'package:tracking_app/features/location_tracking/domain/repos/location_repo.dart';
import 'package:tracking_app/features/location_tracking/domain/use_cases/is_location_service_enabled_use_case.dart';

class FakeLocationRepo implements LocationRepo {
  BaseResponse<bool>? isLocationServiceEnabledResponse;
  int isLocationServiceEnabledCallCount = 0;

  @override
  Future<BaseResponse<bool>> isLocationServiceEnabled() async {
    isLocationServiceEnabledCallCount++;
    return isLocationServiceEnabledResponse!;
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
  late IsLocationServiceEnabledUseCase useCase;

  setUp(() {
    fakeRepo = FakeLocationRepo();
    useCase = IsLocationServiceEnabledUseCase(fakeRepo);
  });

  group('IsLocationServiceEnabledUseCase', () {
    test('delegates to the repo and returns the same response', () async {
      const expectedResponse = SuccessResponse<bool>(true);
      fakeRepo.isLocationServiceEnabledResponse = expectedResponse;

      final result = await useCase();

      expect(result, same(expectedResponse));
      expect(fakeRepo.isLocationServiceEnabledCallCount, 1);
    });

    test('passes an ErrorResponse through unchanged', () async {
      final expectedResponse = ErrorResponse<bool>(
        appError: BadResponseError('Service disabled'),
      );
      fakeRepo.isLocationServiceEnabledResponse = expectedResponse;

      final result = await useCase();

      expect(result, same(expectedResponse));
      expect(fakeRepo.isLocationServiceEnabledCallCount, 1);
    });

    test('increments call counter when invoked', () async {
      const expectedResponse = SuccessResponse<bool>(false);
      fakeRepo.isLocationServiceEnabledResponse = expectedResponse;

      await useCase();

      expect(fakeRepo.isLocationServiceEnabledCallCount, 1);
    });
  });
}
