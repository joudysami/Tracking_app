import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/error/app_error.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_result_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/gender.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/forget_password_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/reset_password_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/verify_otp_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/verify_otp_response.dart';
import 'package:tracking_app/features/auth/domain/entities/vehicle_type_entity.dart';
import 'package:tracking_app/features/auth/domain/repos/auth_repo.dart';
import 'package:tracking_app/features/auth/domain/use_cases/apply_use_case.dart';

class FakeAuthRepo implements AuthRepo {
  BaseResponse<ApplyResultEntity>? applyResponse;
  ApplyParams? capturedApplyParams;
  int applyCallCount = 0;

  @override
  Future<BaseResponse<ApplyResultEntity>> apply(ApplyParams entity) async {
    applyCallCount++;
    capturedApplyParams = entity;
    return applyResponse!;
  }

  @override
  Future<BaseResponse<List<VehicleTypeEntity>>> getVehicleTypes() async {
    throw UnimplementedError();
  }

  @override
  Future<BaseResponse<void>> forgetPassword({
    required ForgetPasswordRequest forgetPasswordRequest,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<BaseResponse<VerifyOtpResponse>> verifyOtp({
    required VerifyOtpRequest verifyOtpRequest,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<BaseResponse<void>> resetPassword({
    required ResetPasswordRequest resetPasswordRequest,
  }) async {
    throw UnimplementedError();
  }
}

void main() {
  late FakeAuthRepo fakeRepo;
  late ApplyUseCase useCase;

  const tParams = ApplyParams(
    firstName: 'John',
    lastName: 'Doe',
    email: 'john@example.com',
    phone: '01012345678',
    nid: '12345678901234',
    nidImage: 'nid.png',
    vehicleTypeId: '1',
    vehiclePlateNumber: '123 ABC',
    vehicleCapacity: 1,
    licenceImage: 'license.png',
    gender: Gender.male,
    password: 'Password123',
    confirmPassword: 'Password123',
    fcmToken: '',
  );

  const tApplyResult = ApplyResultEntity(
    id: '123',
    name: 'John Doe',
    email: 'john@example.com',
    phone: '01012345678',
    gender: 'male',
    notificationStatus: 'active',
  );

  setUp(() {
    fakeRepo = FakeAuthRepo();
    useCase = ApplyUseCase(fakeRepo);
  });

  group('ApplyUseCase', () {
    test('delegates to the repo and returns the same response', () async {
      const expectedResponse = SuccessResponse<ApplyResultEntity>(tApplyResult);
      fakeRepo.applyResponse = expectedResponse;

      final result = await useCase(tParams);

      expect(result, same(expectedResponse));
      expect(fakeRepo.applyCallCount, 1);
    });

    test('passes an ErrorResponse through unchanged', () async {
      final expectedResponse = ErrorResponse<ApplyResultEntity>(
        appError: BadResponseError('Application failed'),
      );
      fakeRepo.applyResponse = expectedResponse;

      final result = await useCase(tParams);

      expect(result, same(expectedResponse));
      expect(fakeRepo.applyCallCount, 1);
    });

    test('passes the request parameters to the repo correctly', () async {
      const expectedResponse = SuccessResponse<ApplyResultEntity>(tApplyResult);
      fakeRepo.applyResponse = expectedResponse;

      await useCase(tParams);

      expect(fakeRepo.capturedApplyParams, tParams);
    });
  });
}
