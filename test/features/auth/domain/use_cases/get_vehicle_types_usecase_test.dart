import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/error/app_error.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_result_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/vehicle_type_entity.dart';
import 'package:tracking_app/features/auth/domain/repos/auth_repo.dart';
import 'package:tracking_app/features/auth/domain/use_cases/get_vehicle_types_usecase.dart';

class FakeAuthRepo implements AuthRepo {
  BaseResponse<List<VehicleTypeEntity>>? getVehicleTypesResponse;
  int getVehicleTypesCallCount = 0;

  @override
  Future<BaseResponse<ApplyResultEntity>> apply(ApplyParams entity) async {
    throw UnimplementedError();
  }

  @override
  Future<BaseResponse<List<VehicleTypeEntity>>> getVehicleTypes() async {
    getVehicleTypesCallCount++;
    return getVehicleTypesResponse!;
  }
}

void main() {
  late FakeAuthRepo fakeRepo;
  late GetVehicleTypesUseCase useCase;

  const tVehicleTypes = [
    VehicleTypeEntity(id: '1', name: 'Car'),
    VehicleTypeEntity(id: '2', name: 'Motorcycle'),
  ];

  setUp(() {
    fakeRepo = FakeAuthRepo();
    useCase = GetVehicleTypesUseCase(fakeRepo);
  });

  group('GetVehicleTypesUseCase', () {
    test('delegates to the repo and returns the same response', () async {
      const expectedResponse =
          SuccessResponse<List<VehicleTypeEntity>>(tVehicleTypes);
      fakeRepo.getVehicleTypesResponse = expectedResponse;

      final result = await useCase();

      expect(result, same(expectedResponse));
      expect(fakeRepo.getVehicleTypesCallCount, 1);
    });

    test('passes an ErrorResponse through unchanged', () async {
      final expectedResponse = ErrorResponse<List<VehicleTypeEntity>>(
        appError: BadResponseError('Failed to fetch vehicle types'),
      );
      fakeRepo.getVehicleTypesResponse = expectedResponse;

      final result = await useCase();

      expect(result, same(expectedResponse));
      expect(fakeRepo.getVehicleTypesCallCount, 1);
    });

    test('reaches the repo correctly', () async {
      const expectedResponse =
          SuccessResponse<List<VehicleTypeEntity>>([]);
      fakeRepo.getVehicleTypesResponse = expectedResponse;

      await useCase();

      expect(fakeRepo.getVehicleTypesCallCount, 1);
    });
  });
}
