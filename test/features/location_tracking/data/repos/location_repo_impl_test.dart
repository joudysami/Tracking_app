import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/network/safe_call.dart';
import 'package:tracking_app/core/services/location_service.dart';
import 'package:tracking_app/features/location_tracking/data/data_sources/location_remote_data_source.dart';
import 'package:tracking_app/features/location_tracking/data/models/location_report_request_model.dart';
import 'package:tracking_app/features/location_tracking/data/models/location_report_response_model.dart';
import 'package:tracking_app/features/location_tracking/data/repos/location_repo_impl.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/location_entity.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/location_report_entity.dart';

import 'location_repo_impl_test.mocks.dart';

@GenerateMocks([LocationRemoteDataSource, LocationService])
void main() {
  provideDummy<LocationReportResponseModel>(
    LocationReportResponseModel(
      recordedAt: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      updatedOrderIds: const [],
      broadcast: false,
    ),
  );
  provideDummy<Position>(
    Position(
      longitude: 0.0,
      latitude: 0.0,
      timestamp: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      accuracy: 0.0,
      altitude: 0.0,
      altitudeAccuracy: 0.0,
      heading: 0.0,
      headingAccuracy: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    ),
  );

  late MockLocationRemoteDataSource mockRemoteDataSource;
  late MockLocationService mockLocationService;
  late SafeCall safeCall;
  late LocationRepoImpl repo;

  final tRecordedAt = DateTime.utc(2026, 10, 23, 12, 0, 0);
  final tLocation = LocationEntity(
    lat: 30.0444,
    lng: 31.2357,
    recordedAt: tRecordedAt,
  );
  final tPosition = Position(
    longitude: 31.2357,
    latitude: 30.0444,
    timestamp: tRecordedAt,
    accuracy: 5.0,
    altitude: 10.0,
    altitudeAccuracy: 1.0,
    heading: 90.0,
    headingAccuracy: 1.0,
    speed: 15.0,
    speedAccuracy: 0.5,
  );
  final tReportResponseModel = LocationReportResponseModel(
    recordedAt: tRecordedAt,
    updatedOrderIds: const ['order_1', 'order_2'],
    broadcast: true,
  );

  setUp(() {
    mockRemoteDataSource = MockLocationRemoteDataSource();
    mockLocationService = MockLocationService();
    safeCall = SafeCall();
    repo = LocationRepoImpl(
      mockLocationService,
      safeCall,
      remoteDataSource: mockRemoteDataSource,
    );
  });

  group('LocationRepoImpl - isLocationServiceEnabled', () {
    test('returns SuccessResponse with boolean value when enabled', () async {
      when(mockLocationService.isLocationServiceEnabled()).thenAnswer(
        (_) async => true,
      );

      final result = await repo.isLocationServiceEnabled();

      expect(result, isA<SuccessResponse<bool>>());
      final successResponse = result as SuccessResponse<bool>;
      expect(successResponse.data, true);
      verify(mockLocationService.isLocationServiceEnabled()).called(1);
    });

    test('returns ErrorResponse when service check throws an exception', () async {
      when(mockLocationService.isLocationServiceEnabled()).thenThrow(
        Exception('Service unavailable'),
      );

      final result = await repo.isLocationServiceEnabled();

      expect(result, isA<ErrorResponse<bool>>());
      verify(mockLocationService.isLocationServiceEnabled()).called(1);
    });
  });

  group('LocationRepoImpl - checkPermission', () {
    test('returns SuccessResponse with LocationPermission when check succeeds', () async {
      when(mockLocationService.checkPermission()).thenAnswer(
        (_) async => LocationPermission.whileInUse,
      );

      final result = await repo.checkPermission();

      expect(result, isA<SuccessResponse<LocationPermission>>());
      final successResponse = result as SuccessResponse<LocationPermission>;
      expect(successResponse.data, LocationPermission.whileInUse);
      verify(mockLocationService.checkPermission()).called(1);
    });

    test('returns ErrorResponse when checkPermission throws an exception', () async {
      when(mockLocationService.checkPermission()).thenThrow(
        Exception('Permission query failed'),
      );

      final result = await repo.checkPermission();

      expect(result, isA<ErrorResponse<LocationPermission>>());
      verify(mockLocationService.checkPermission()).called(1);
    });
  });

  group('LocationRepoImpl - requestPermission', () {
    test('returns SuccessResponse with LocationPermission when request succeeds', () async {
      when(mockLocationService.requestPermission()).thenAnswer(
        (_) async => LocationPermission.always,
      );

      final result = await repo.requestPermission();

      expect(result, isA<SuccessResponse<LocationPermission>>());
      final successResponse = result as SuccessResponse<LocationPermission>;
      expect(successResponse.data, LocationPermission.always);
      verify(mockLocationService.requestPermission()).called(1);
    });

    test('returns ErrorResponse when requestPermission throws an exception', () async {
      when(mockLocationService.requestPermission()).thenThrow(
        Exception('Permission request failed'),
      );

      final result = await repo.requestPermission();

      expect(result, isA<ErrorResponse<LocationPermission>>());
      verify(mockLocationService.requestPermission()).called(1);
    });
  });

  group('LocationRepoImpl - openLocationSettings', () {
    test('returns SuccessResponse when opening location settings succeeds', () async {
      when(mockLocationService.openLocationSettings()).thenAnswer(
        (_) async => true,
      );

      final result = await repo.openLocationSettings();

      expect(result, isA<SuccessResponse<bool>>());
      final successResponse = result as SuccessResponse<bool>;
      expect(successResponse.data, true);
      verify(mockLocationService.openLocationSettings()).called(1);
    });

    test('returns ErrorResponse when openLocationSettings throws an exception', () async {
      when(mockLocationService.openLocationSettings()).thenThrow(
        Exception('Failed to open location settings'),
      );

      final result = await repo.openLocationSettings();

      expect(result, isA<ErrorResponse<bool>>());
      verify(mockLocationService.openLocationSettings()).called(1);
    });
  });

  group('LocationRepoImpl - openAppSettings', () {
    test('returns SuccessResponse when opening app settings succeeds', () async {
      when(mockLocationService.openAppSettings()).thenAnswer(
        (_) async => true,
      );

      final result = await repo.openAppSettings();

      expect(result, isA<SuccessResponse<bool>>());
      final successResponse = result as SuccessResponse<bool>;
      expect(successResponse.data, true);
      verify(mockLocationService.openAppSettings()).called(1);
    });

    test('returns ErrorResponse when openAppSettings throws an exception', () async {
      when(mockLocationService.openAppSettings()).thenThrow(
        Exception('Failed to open app settings'),
      );

      final result = await repo.openAppSettings();

      expect(result, isA<ErrorResponse<bool>>());
      verify(mockLocationService.openAppSettings()).called(1);
    });
  });

  group('LocationRepoImpl - getCurrentPosition', () {
    test('returns SuccessResponse with Position on success', () async {
      when(mockLocationService.getCurrentPosition()).thenAnswer(
        (_) async => tPosition,
      );

      final result = await repo.getCurrentPosition();

      expect(result, isA<SuccessResponse<Position>>());
      final successResponse = result as SuccessResponse<Position>;
      expect(successResponse.data, tPosition);
      verify(mockLocationService.getCurrentPosition()).called(1);
    });

    test('returns ErrorResponse when getCurrentPosition throws an exception', () async {
      when(mockLocationService.getCurrentPosition()).thenThrow(
        Exception('GPS signal not found'),
      );

      final result = await repo.getCurrentPosition();

      expect(result, isA<ErrorResponse<Position>>());
      verify(mockLocationService.getCurrentPosition()).called(1);
    });
  });

  group('LocationRepoImpl - getPositionStream', () {
    test('maps Position stream from service to LocationEntity stream', () async {
      when(mockLocationService.getPositionStream()).thenAnswer(
        (_) => Stream.fromIterable([tPosition]),
      );

      final stream = repo.getPositionStream();
      final emitted = await stream.first;

      expect(emitted, isA<LocationEntity>());
      expect(emitted.lat, tPosition.latitude);
      expect(emitted.lng, tPosition.longitude);
      expect(emitted.recordedAt, tPosition.timestamp);
      verify(mockLocationService.getPositionStream()).called(1);
    });
  });

  group('LocationRepoImpl - reportLocation', () {
    test('returns SuccessResponse with mapped LocationReportEntity on success', () async {
      when(mockRemoteDataSource.reportLocation(any)).thenAnswer(
        (_) async => tReportResponseModel,
      );

      final result = await repo.reportLocation(tLocation);

      expect(result, isA<SuccessResponse<LocationReportEntity>>());
      final successResponse = result as SuccessResponse<LocationReportEntity>;
      expect(successResponse.data?.broadcast, true);
      expect(successResponse.data?.updatedOrderIds, ['order_1', 'order_2']);
      expect(successResponse.data?.recordedAt, tRecordedAt);
      verify(mockRemoteDataSource.reportLocation(any)).called(1);
    });

    test('throttles subsequent reportLocation calls within 5 seconds', () async {
      when(mockRemoteDataSource.reportLocation(any)).thenAnswer(
        (_) async => tReportResponseModel,
      );

      final firstResult = await repo.reportLocation(tLocation);
      expect(firstResult, isA<SuccessResponse<LocationReportEntity>>());
      verify(mockRemoteDataSource.reportLocation(any)).called(1);

      // Immediate second call should be throttled and return null
      final secondResult = await repo.reportLocation(tLocation);
      expect(secondResult, isNull);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('returns ErrorResponse when remote data source throws an exception', () async {
      when(mockRemoteDataSource.reportLocation(any)).thenThrow(
        Exception('Network connection lost'),
      );

      final result = await repo.reportLocation(tLocation);

      expect(result, isA<ErrorResponse<LocationReportEntity>>());
      verify(mockRemoteDataSource.reportLocation(any)).called(1);
    });
  });

  group('LocationRepoImpl - checkAndRequestPermission', () {
    test('returns existing permission when already granted (whileInUse)', () async {
      when(mockLocationService.checkPermission()).thenAnswer(
        (_) async => LocationPermission.whileInUse,
      );

      final result = await repo.checkAndRequestPermission();

      expect(result, isA<SuccessResponse<LocationPermission>>());
      final successResponse = result as SuccessResponse<LocationPermission>;
      expect(successResponse.data, LocationPermission.whileInUse);
      verify(mockLocationService.checkPermission()).called(1);
      verifyNever(mockLocationService.requestPermission());
    });

    test('requests permission when checkPermission returns denied', () async {
      when(mockLocationService.checkPermission()).thenAnswer(
        (_) async => LocationPermission.denied,
      );
      when(mockLocationService.requestPermission()).thenAnswer(
        (_) async => LocationPermission.whileInUse,
      );

      final result = await repo.checkAndRequestPermission();

      expect(result, isA<SuccessResponse<LocationPermission>>());
      final successResponse = result as SuccessResponse<LocationPermission>;
      expect(successResponse.data, LocationPermission.whileInUse);
      verify(mockLocationService.checkPermission()).called(1);
      verify(mockLocationService.requestPermission()).called(1);
    });

    test('returns ErrorResponse when checkPermission fails', () async {
      when(mockLocationService.checkPermission()).thenThrow(
        Exception('Permission check error'),
      );

      final result = await repo.checkAndRequestPermission();

      expect(result, isA<ErrorResponse<LocationPermission>>());
      verify(mockLocationService.checkPermission()).called(1);
      verifyNever(mockLocationService.requestPermission());
    });
  });
}
