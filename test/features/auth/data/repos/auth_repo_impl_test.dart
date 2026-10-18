import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/error/app_error.dart';
import 'package:tracking_app/core/network/safe_call.dart';
import 'package:tracking_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:tracking_app/features/auth/data/models/apply_request_model.dart';
import 'package:tracking_app/features/auth/data/models/apply_response.dart';
import 'package:tracking_app/features/auth/data/models/forget_password/forget_password_request_dto.dart';
import 'package:tracking_app/features/auth/data/models/forget_password/forget_password_response_dto.dart';
import 'package:tracking_app/features/auth/data/models/forget_password/reset_password_request_dto.dart';
import 'package:tracking_app/features/auth/data/models/forget_password/verify_otp_request_dto.dart';
import 'package:tracking_app/features/auth/data/models/forget_password/verify_otp_response_dto.dart';
import 'package:tracking_app/features/auth/data/models/vehicle_type_model.dart';
import 'package:tracking_app/features/auth/data/models/vehicle_type_response.dart';
import 'package:tracking_app/features/auth/data/repos/auth_repo_impl.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_result_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/forget_password_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/reset_password_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/verify_otp_request.dart';
import 'package:tracking_app/features/auth/domain/entities/forget_password/verify_otp_response.dart';
import 'package:tracking_app/features/auth/domain/entities/gender.dart';
import 'package:tracking_app/features/auth/domain/entities/vehicle_type_entity.dart';

import 'auth_repo_impl_test.mocks.dart';

@GenerateMocks([AuthRemoteDataSource])
void main() {
  provideDummy<ApplyResponse>(ApplyResponse());
  provideDummy<VehicleTypesResponse>(VehicleTypesResponse());

  late MockAuthRemoteDataSource mockRemoteDataSource;
  late SafeCall safeCall;
  late AuthRepoImpl repo;
  late MockAuthRemoteDataSource remote;
  late Directory tempDir;
  late File licenseFile;
  late File nidFile;
  late ApplyParams tApplyParams;

  final tApplyData = ApplyData(
    id: '123',
    name: 'John Doe',
    email: 'john@example.com',
    phone: '01012345678',
    gender: 'male',
    notificationStatus: 'active',
  );

  final tApplyResult = tApplyData.toDomain();

  setUpAll(() {
    tempDir = Directory.systemTemp.createTempSync('auth_repo_test_');
    licenseFile = File('${tempDir.path}/license.png')..writeAsStringSync('dummy');
    nidFile = File('${tempDir.path}/nid.png')..writeAsStringSync('dummy');
  });

  tearDownAll(() {
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    remote = mockRemoteDataSource;
    safeCall = SafeCall();
    repo = AuthRepoImpl(
      remoteDataSource: mockRemoteDataSource,
      safeCall: safeCall,
    );

    tApplyParams = ApplyParams(
      firstName: 'John',
      lastName: 'Doe',
      email: 'john@example.com',
      phone: '01012345678',
      nid: '12345678901234',
      nidImage: nidFile.path,
      vehicleTypeId: '1',
      vehiclePlateNumber: '123 ABC',
      vehicleCapacity: 1,
      licenceImage: licenseFile.path,
      gender: Gender.male,
      password: 'Password123',
      confirmPassword: 'Password123',
      fcmToken: '',
    );
  });

  group('AuthRepoImpl - apply', () {
    test('returns SuccessResponse with mapped ApplyResultEntity on success', () async {
      when(mockRemoteDataSource.apply(any)).thenAnswer(
        (_) async => ApplyResponse(
          status: true,
          data: tApplyData,
        ),
      );

      final result = await repo.apply(tApplyParams);

      expect(result, isA<SuccessResponse<ApplyResultEntity>>());
      final successResponse = result as SuccessResponse<ApplyResultEntity>;
      expect(successResponse.data, tApplyResult);
      verify(mockRemoteDataSource.apply(any)).called(1);
    });

    test('returns ErrorResponse with message when envelope status is false', () async {
      const errorMessage = 'Invalid national ID';
      when(mockRemoteDataSource.apply(any)).thenAnswer(
        (_) async => ApplyResponse(
          status: false,
          message: errorMessage,
        ),
      );

      final result = await repo.apply(tApplyParams);

      expect(result, isA<ErrorResponse<ApplyResultEntity>>());
      final errorResponse = result as ErrorResponse<ApplyResultEntity>;
      expect(errorResponse.errorMessage, errorMessage);
      verify(mockRemoteDataSource.apply(any)).called(1);
    });

    test('returns ErrorResponse when remote data source throws an exception', () async {
      when(mockRemoteDataSource.apply(any)).thenThrow(Exception('Connection error'));

      final result = await repo.apply(tApplyParams);

      expect(result, isA<ErrorResponse<ApplyResultEntity>>());
      verify(mockRemoteDataSource.apply(any)).called(1);
    });
  });

  group('AuthRepoImpl - getVehicleTypes', () {
    test('returns SuccessResponse mapped to entities on success', () async {
      final tModels = [
        VehicleTypeModel(id: '1', name: 'Car'),
        VehicleTypeModel(id: '2', name: 'Motorcycle'),
      ];
      final expectedEntities = [
        const VehicleTypeEntity(id: '1', name: 'Car'),
        const VehicleTypeEntity(id: '2', name: 'Motorcycle'),
      ];

      when(mockRemoteDataSource.getVehicleTypes()).thenAnswer(
        (_) async => VehicleTypesResponse(
          status: true,
          data: tModels,
        ),
      );

      final result = await repo.getVehicleTypes();

      expect(result, isA<SuccessResponse<List<VehicleTypeEntity>>>());
      final successResponse = result as SuccessResponse<List<VehicleTypeEntity>>;
      expect(successResponse.data, expectedEntities);
      verify(mockRemoteDataSource.getVehicleTypes()).called(1);
    });

    test('returns ErrorResponse when envelope status is false', () async {
      const errorMessage = 'Failed to fetch vehicle types';
      when(mockRemoteDataSource.getVehicleTypes()).thenAnswer(
        (_) async => VehicleTypesResponse(
          status: false,
          message: errorMessage,
        ),
      );

      final result = await repo.getVehicleTypes();

      expect(result, isA<ErrorResponse<List<VehicleTypeEntity>>>());
      final errorResponse = result as ErrorResponse<List<VehicleTypeEntity>>;
      expect(errorResponse.errorMessage, errorMessage);
      verify(mockRemoteDataSource.getVehicleTypes()).called(1);
    });

    test('returns ErrorResponse when remote data source throws an exception', () async {
      when(mockRemoteDataSource.getVehicleTypes()).thenThrow(Exception('Server error'));

      final result = await repo.getVehicleTypes();

      expect(result, isA<ErrorResponse<List<VehicleTypeEntity>>>());
      verify(mockRemoteDataSource.getVehicleTypes()).called(1);
    });

    test('returns SuccessResponse with empty list when data is empty', () async {
      when(mockRemoteDataSource.getVehicleTypes()).thenAnswer(
        (_) async => VehicleTypesResponse(
          status: true,
          data: [],
        ),
      );

      final result = await repo.getVehicleTypes();

      expect(result, isA<SuccessResponse<List<VehicleTypeEntity>>>());
      final successResponse = result as SuccessResponse<List<VehicleTypeEntity>>;
      expect(successResponse.data, isEmpty);
      verify(mockRemoteDataSource.getVehicleTypes()).called(1);
    });
  });

  AppError errorOf(BaseResponse response) =>
      (response as ErrorResponse).appError;

  ForgetPasswordResponseDto okResponse() => ForgetPasswordResponseDto(
        status: true,
        code: 200,
        message: 'success',
        data: true,
      );

  ForgetPasswordResponseDto failedResponse({dynamic errors}) =>
      ForgetPasswordResponseDto(
        status: false,
        code: 400,
        message: 'Invalid email',
        errors: errors,
      );

  DioException dioError(DioExceptionType type) => DioException(
        requestOptions: RequestOptions(path: '/'),
        type: type,
      );

  group('forgetPassword', () {
    const request = ForgetPasswordRequest(email: 'a@b.com');

    test('returns SuccessResponse and maps the request to a DTO', () async {
      when(remote.forgetPassword(any)).thenAnswer((_) async => okResponse());

      final result = await repo.forgetPassword(forgetPasswordRequest: request);

      expect(result, isA<SuccessResponse>());
      final sent = verify(remote.forgetPassword(captureAny)).captured.single
      as ForgetPasswordRequestDto;
      expect(sent.email, 'a@b.com');
    });

    test('returns BadResponseError with the server message when status is false',
            () async {
          when(remote.forgetPassword(any))
              .thenAnswer((_) async => failedResponse());

          final result = await repo.forgetPassword(forgetPasswordRequest: request);

          expect(result, isA<ErrorResponse>());
          expect(errorOf(result), isA<BadResponseError>());
          expect(errorOf(result).message, 'Invalid email');
        });

    test('uses the field errors as the message when the server sends them',
            () async {
          when(remote.forgetPassword(any)).thenAnswer(
                (_) async => failedResponse(errors: {
              'email': ['Not found'],
            }),
          );

          final result = await repo.forgetPassword(forgetPasswordRequest: request);

          expect(errorOf(result).message, 'Not found');
        });

    test('falls back to the default message when message is null', () async {
      when(remote.forgetPassword(any)).thenAnswer(
            (_) async => ForgetPasswordResponseDto(status: false),
      );

      final result = await repo.forgetPassword(forgetPasswordRequest: request);

      expect(errorOf(result).message, 'Something went wrong.');
    });

    test('treats a null status as a failure', () async {
      when(remote.forgetPassword(any)).thenAnswer(
            (_) async => ForgetPasswordResponseDto(message: 'no status'),
      );

      final result = await repo.forgetPassword(forgetPasswordRequest: request);

      expect(result, isA<ErrorResponse>());
    });

    test('maps a timeout DioException to TimeOutError', () async {
      when(remote.forgetPassword(any)).thenAnswer(
            (_) async => throw dioError(DioExceptionType.connectionTimeout),
      );

      final result = await repo.forgetPassword(forgetPasswordRequest: request);

      expect(errorOf(result), isA<TimeOutError>());
    });
  });

  group('verifyOtp', () {
    const request = VerifyOtpRequest(email: 'a@b.com', otp: '123456');

    test('returns the entity mapped from the data DTO', () async {
      when(remote.verifyOtp(any)).thenAnswer(
            (_) async => VerifyOtpResponseDto(
          status: true,
          code: 200,
          message: 'OTP verified',
          data: VerifyOtpDataDto(otpToken: 'token-1', expiresInMinutes: 30),
        ),
      );

      final result = await repo.verifyOtp(verifyOtpRequest: request);

      expect(result, isA<SuccessResponse<VerifyOtpResponse>>());
      expect(
        (result as SuccessResponse<VerifyOtpResponse>).data,
        const VerifyOtpResponse(otpToken: 'token-1', expiresInMinutes: 30),
      );
      final sent = verify(remote.verifyOtp(captureAny)).captured.single
      as VerifyOtpRequestDto;
      expect(sent.email, 'a@b.com');
      expect(sent.otp, '123456');
    });

    test('returns an error when status is true but data is null', () async {
      when(remote.verifyOtp(any)).thenAnswer(
            (_) async => VerifyOtpResponseDto(status: true, code: 200),
      );

      final result = await repo.verifyOtp(verifyOtpRequest: request);

      expect(result, isA<ErrorResponse>());
      expect(errorOf(result).message, 'Something went wrong.');
    });

    test('returns the server message when the code is wrong', () async {
      when(remote.verifyOtp(any)).thenAnswer(
            (_) async => VerifyOtpResponseDto(
          status: false,
          code: 400,
          message: 'Invalid OTP',
        ),
      );

      final result = await repo.verifyOtp(verifyOtpRequest: request);

      expect(errorOf(result), isA<BadResponseError>());
      expect(errorOf(result).message, 'Invalid OTP');
    });

    test('maps a connection error to NoInternetError', () async {
      when(remote.verifyOtp(any)).thenAnswer(
            (_) async => throw DioException(
          requestOptions: RequestOptions(path: '/'),
          type: DioExceptionType.connectionError,
          message: 'offline',
        ),
      );

      final result = await repo.verifyOtp(verifyOtpRequest: request);

      expect(errorOf(result), isA<NoInternetError>());
    });
  });

  group('resetPassword', () {
    const request = ResetPasswordRequest(
      otpToken: 'token-1',
      password: 'Abcdef1',
      confirmPassword: 'Abcdef1',
    );

    test('returns SuccessResponse and maps the request to a DTO', () async {
      when(remote.resetPassword(any)).thenAnswer((_) async => okResponse());

      final result = await repo.resetPassword(resetPasswordRequest: request);

      expect(result, isA<SuccessResponse>());
      final sent = verify(remote.resetPassword(captureAny)).captured.single
      as ResetPasswordRequestDto;
      expect(sent.otpToken, 'token-1');
      expect(sent.password, 'Abcdef1');
      expect(sent.confirmPassword, 'Abcdef1');
    });

    test('returns BadResponseError when status is false', () async {
      when(remote.resetPassword(any)).thenAnswer(
            (_) async => failedResponse(),
      );

      final result = await repo.resetPassword(resetPasswordRequest: request);

      expect(errorOf(result), isA<BadResponseError>());
      expect(errorOf(result).message, 'Invalid email');
    });

    test('maps a 401 DioException to UnauthorizedError', () async {
      when(remote.resetPassword(any)).thenAnswer(
            (_) async => throw DioException(
          requestOptions: RequestOptions(path: '/'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/'),
            statusCode: 401,
          ),
        ),
      );

      final result = await repo.resetPassword(resetPasswordRequest: request);

      expect(errorOf(result), isA<UnauthorizedError>());
    });
  });
}
