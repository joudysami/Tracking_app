import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/error/app_error.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/location_entity.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/location_report_entity.dart';
import 'package:tracking_app/features/location_tracking/domain/repos/location_repo.dart';
import 'package:tracking_app/features/location_tracking/domain/use_cases/check_and_request_location_permission_use_case.dart';

class FakeLocationRepo implements LocationRepo {
  BaseResponse<LocationPermission>? checkAndRequestPermissionResponse;
  int checkAndRequestPermissionCallCount = 0;

  @override
  Future<BaseResponse<LocationPermission>> checkAndRequestPermission() async {
    checkAndRequestPermissionCallCount++;
    return checkAndRequestPermissionResponse!;
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
  late CheckAndRequestLocationPermissionUseCase useCase;

  setUp(() {
    fakeRepo = FakeLocationRepo();
    useCase = CheckAndRequestLocationPermissionUseCase(fakeRepo);
  });

  group('CheckAndRequestLocationPermissionUseCase', () {
    test('delegates to the repo and returns the same response', () async {
      const expectedResponse =
          SuccessResponse<LocationPermission>(LocationPermission.whileInUse);
      fakeRepo.checkAndRequestPermissionResponse = expectedResponse;

      final result = await useCase();

      expect(result, same(expectedResponse));
      expect(fakeRepo.checkAndRequestPermissionCallCount, 1);
    });

    test('passes an ErrorResponse through unchanged', () async {
      final expectedResponse = ErrorResponse<LocationPermission>(
        appError: BadResponseError('Permission request failed'),
      );
      fakeRepo.checkAndRequestPermissionResponse = expectedResponse;

      final result = await useCase();

      expect(result, same(expectedResponse));
      expect(fakeRepo.checkAndRequestPermissionCallCount, 1);
    });

    test('increments call counter when invoked', () async {
      const expectedResponse =
          SuccessResponse<LocationPermission>(LocationPermission.always);
      fakeRepo.checkAndRequestPermissionResponse = expectedResponse;

      await useCase();

      expect(fakeRepo.checkAndRequestPermissionCallCount, 1);
    });
  });
}
