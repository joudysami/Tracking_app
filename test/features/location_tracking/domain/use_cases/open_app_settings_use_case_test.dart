import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/error/app_error.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/location_entity.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/location_report_entity.dart';
import 'package:tracking_app/features/location_tracking/domain/repos/location_repo.dart';
import 'package:tracking_app/features/location_tracking/domain/use_cases/open_app_settings_use_case.dart';

class FakeLocationRepo implements LocationRepo {
  BaseResponse<bool>? openAppSettingsResponse;
  int openAppSettingsCallCount = 0;

  @override
  Future<BaseResponse<bool>> openAppSettings() async {
    openAppSettingsCallCount++;
    return openAppSettingsResponse!;
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
  late OpenAppSettingsUseCase useCase;

  setUp(() {
    fakeRepo = FakeLocationRepo();
    useCase = OpenAppSettingsUseCase(fakeRepo);
  });

  group('OpenAppSettingsUseCase', () {
    test('delegates to the repo and returns the same response', () async {
      const expectedResponse = SuccessResponse<bool>(true);
      fakeRepo.openAppSettingsResponse = expectedResponse;

      final result = await useCase();

      expect(result, same(expectedResponse));
      expect(fakeRepo.openAppSettingsCallCount, 1);
    });

    test('passes an ErrorResponse through unchanged', () async {
      final expectedResponse = ErrorResponse<bool>(
        appError: BadResponseError('Cannot open app settings'),
      );
      fakeRepo.openAppSettingsResponse = expectedResponse;

      final result = await useCase();

      expect(result, same(expectedResponse));
      expect(fakeRepo.openAppSettingsCallCount, 1);
    });

    test('increments call counter when invoked', () async {
      const expectedResponse = SuccessResponse<bool>(false);
      fakeRepo.openAppSettingsResponse = expectedResponse;

      await useCase();

      expect(fakeRepo.openAppSettingsCallCount, 1);
    });
  });
}
