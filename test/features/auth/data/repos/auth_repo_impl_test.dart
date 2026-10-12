import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/network/safe_call.dart';
import 'package:tracking_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:tracking_app/features/auth/data/models/apply_request_model.dart';
import 'package:tracking_app/features/auth/data/models/apply_response.dart';
import 'package:tracking_app/features/auth/data/models/vehicle_type_model.dart';
import 'package:tracking_app/features/auth/data/models/vehicle_type_response.dart';
import 'package:tracking_app/features/auth/data/repos/auth_repo_impl.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_result_entity.dart';
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
}
