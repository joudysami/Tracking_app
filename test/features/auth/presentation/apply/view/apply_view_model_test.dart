import 'package:bloc_test/bloc_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/base/base_state.dart';
import 'package:tracking_app/core/error/app_error.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/services/image_picker_service.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_result_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/gender.dart';
import 'package:tracking_app/features/auth/domain/entities/vehicle_type_entity.dart';
import 'package:tracking_app/features/auth/domain/use_cases/apply_use_case.dart';
import 'package:tracking_app/features/auth/domain/use_cases/get_vehicle_types_usecase.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/apply_view_model/apply_event.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/apply_view_model/apply_state.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/apply_view_model/apply_view_model.dart';

import 'apply_view_model_test.mocks.dart';

@GenerateMocks([
  ApplyUseCase,
  GetVehicleTypesUseCase,
  ImagePickerService,
])
void main() {
  provideDummy<BaseResponse<ApplyResultEntity>>(
    const SuccessResponse<ApplyResultEntity>(null),
  );
  provideDummy<BaseResponse<List<VehicleTypeEntity>>>(
    const SuccessResponse<List<VehicleTypeEntity>>([]),
  );

  late MockApplyUseCase mockApplyUseCase;
  late MockGetVehicleTypesUseCase mockGetVehicleTypesUseCase;
  late MockImagePickerService mockImagePickerService;
  late ApplyViewModel viewModel;

  const tVehicleType = VehicleTypeEntity(id: '1', name: 'Car');
  const tApplyResult = ApplyResultEntity(
    id: '123',
    name: 'John Doe',
    email: 'john@example.com',
    phone: '01012345678',
    gender: 'male',
    notificationStatus: 'active',
  );

  setUp(() {
    mockApplyUseCase = MockApplyUseCase();
    mockGetVehicleTypesUseCase = MockGetVehicleTypesUseCase();
    mockImagePickerService = MockImagePickerService();
    viewModel = ApplyViewModel(
      mockApplyUseCase,
      mockGetVehicleTypesUseCase,
      mockImagePickerService,
    );
  });

  group('ApplyViewModel - Initial State', () {
    test('initial state has expected default values', () {
      expect(viewModel.state, const ApplyState());
      expect(viewModel.state.firstName, '');
      expect(viewModel.state.lastName, '');
      expect(viewModel.state.email, '');
      expect(viewModel.state.phone, '');
      expect(viewModel.state.nid, '');
      expect(viewModel.state.plateNumber, '');
      expect(viewModel.state.password, '');
      expect(viewModel.state.confirmPassword, '');
      expect(viewModel.state.selectedVehicleType, isNull);
      expect(viewModel.state.gender, isNull);
      expect(viewModel.state.licenseImage, isNull);
      expect(viewModel.state.idImage, isNull);
      expect(
        viewModel.state.vehicleTypesState,
        const BaseState<List<VehicleTypeEntity>>(),
      );
      expect(
        viewModel.state.applyState,
        const BaseState<ApplyResultEntity>(),
      );
    });
  });

  group('ApplyViewModel - Field Change Events', () {
    blocTest<ApplyViewModel, ApplyState>(
      'updates firstName when FirstNameChanged is received',
      build: () => viewModel,
      act: (vm) => vm.doEvent(FirstNameChanged('John')),
      expect: () => [
        const ApplyState(firstName: 'John'),
      ],
    );

    blocTest<ApplyViewModel, ApplyState>(
      'updates lastName when LastNameChanged is received',
      build: () => viewModel,
      act: (vm) => vm.doEvent(LastNameChanged('Doe')),
      expect: () => [
        const ApplyState(lastName: 'Doe'),
      ],
    );

    blocTest<ApplyViewModel, ApplyState>(
      'updates selectedVehicleType when VehicleTypeChanged is received',
      build: () => viewModel,
      act: (vm) => vm.doEvent(VehicleTypeChanged(tVehicleType)),
      expect: () => [
        const ApplyState(selectedVehicleType: tVehicleType),
      ],
    );

    blocTest<ApplyViewModel, ApplyState>(
      'updates plateNumber when PlateNumberChanged is received',
      build: () => viewModel,
      act: (vm) => vm.doEvent(PlateNumberChanged('123 ABC')),
      expect: () => [
        const ApplyState(plateNumber: '123 ABC'),
      ],
    );

    blocTest<ApplyViewModel, ApplyState>(
      'updates email when EmailChanged is received',
      build: () => viewModel,
      act: (vm) => vm.doEvent(EmailChanged('john@example.com')),
      expect: () => [
        const ApplyState(email: 'john@example.com'),
      ],
    );

    blocTest<ApplyViewModel, ApplyState>(
      'updates phone when PhoneChanged is received',
      build: () => viewModel,
      act: (vm) => vm.doEvent(PhoneChanged('01012345678')),
      expect: () => [
        const ApplyState(phone: '01012345678'),
      ],
    );

    blocTest<ApplyViewModel, ApplyState>(
      'updates nid when NidChanged is received',
      build: () => viewModel,
      act: (vm) => vm.doEvent(NidChanged('12345678901234')),
      expect: () => [
        const ApplyState(nid: '12345678901234'),
      ],
    );

    blocTest<ApplyViewModel, ApplyState>(
      'updates password when PasswordChanged is received',
      build: () => viewModel,
      act: (vm) => vm.doEvent(PasswordChanged('Password123')),
      expect: () => [
        const ApplyState(password: 'Password123'),
      ],
    );

    blocTest<ApplyViewModel, ApplyState>(
      'updates confirmPassword when ConfirmPasswordChanged is received',
      build: () => viewModel,
      act: (vm) => vm.doEvent(ConfirmPasswordChanged('Password123')),
      expect: () => [
        const ApplyState(confirmPassword: 'Password123'),
      ],
    );

    blocTest<ApplyViewModel, ApplyState>(
      'updates gender when GenderChanged is received',
      build: () => viewModel,
      act: (vm) => vm.doEvent(GenderChanged(Gender.male)),
      expect: () => [
        const ApplyState(gender: Gender.male),
      ],
    );
  });

  group('ApplyViewModel - Image Picking', () {
    blocTest<ApplyViewModel, ApplyState>(
      'updates licenseImage when image is successfully picked',
      build: () {
        when(mockImagePickerService.pickImage()).thenAnswer(
          (_) async => XFile('dummy_license.png'),
        );
        return viewModel;
      },
      act: (vm) => vm.doEvent(PickLicenseImageRequested()),
      expect: () => [
        const ApplyState(licenseImage: 'dummy_license.png'),
      ],
      verify: (_) {
        verify(mockImagePickerService.pickImage()).called(1);
      },
    );

    blocTest<ApplyViewModel, ApplyState>(
      'does not update licenseImage when picker returns null',
      build: () {
        when(mockImagePickerService.pickImage()).thenAnswer(
          (_) async => null,
        );
        return viewModel;
      },
      act: (vm) => vm.doEvent(PickLicenseImageRequested()),
      expect: () => [],
      verify: (_) {
        verify(mockImagePickerService.pickImage()).called(1);
      },
    );

    blocTest<ApplyViewModel, ApplyState>(
      'updates idImage when image is successfully picked',
      build: () {
        when(mockImagePickerService.pickImage()).thenAnswer(
          (_) async => XFile('dummy_id.png'),
        );
        return viewModel;
      },
      act: (vm) => vm.doEvent(PickIdImageRequested()),
      expect: () => [
        const ApplyState(idImage: 'dummy_id.png'),
      ],
      verify: (_) {
        verify(mockImagePickerService.pickImage()).called(1);
      },
    );

    blocTest<ApplyViewModel, ApplyState>(
      'does not update idImage when picker returns null',
      build: () {
        when(mockImagePickerService.pickImage()).thenAnswer(
          (_) async => null,
        );
        return viewModel;
      },
      act: (vm) => vm.doEvent(PickIdImageRequested()),
      expect: () => [],
      verify: (_) {
        verify(mockImagePickerService.pickImage()).called(1);
      },
    );
  });

  group('ApplyViewModel - Vehicle Types Action', () {
    blocTest<ApplyViewModel, ApplyState>(
      'emits loading then success with list of vehicle types',
      build: () {
        when(mockGetVehicleTypesUseCase()).thenAnswer(
          (_) async => const SuccessResponse([tVehicleType]),
        );
        return viewModel;
      },
      act: (vm) => vm.doEvent(VehicleTypesRequested()),
      expect: () => [
        isA<ApplyState>().having(
          (s) => s.vehicleTypesState,
          'vehicleTypesState',
          const BaseState<List<VehicleTypeEntity>>(isLoading: true),
        ),
        isA<ApplyState>().having(
          (s) => s.vehicleTypesState,
          'vehicleTypesState',
          const BaseState<List<VehicleTypeEntity>>(
            isLoading: false,
            data: [tVehicleType],
            errorMessage: '',
          ),
        ),
      ],
      verify: (_) {
        verify(mockGetVehicleTypesUseCase()).called(1);
      },
    );

    blocTest<ApplyViewModel, ApplyState>(
      'emits loading then success with empty list when no types returned',
      build: () {
        when(mockGetVehicleTypesUseCase()).thenAnswer(
          (_) async => const SuccessResponse([]),
        );
        return viewModel;
      },
      act: (vm) => vm.doEvent(VehicleTypesRequested()),
      expect: () => [
        isA<ApplyState>().having(
          (s) => s.vehicleTypesState,
          'vehicleTypesState',
          const BaseState<List<VehicleTypeEntity>>(isLoading: true),
        ),
        isA<ApplyState>().having(
          (s) => s.vehicleTypesState,
          'vehicleTypesState',
          const BaseState<List<VehicleTypeEntity>>(
            isLoading: false,
            data: [],
            errorMessage: '',
          ),
        ),
      ],
      verify: (_) {
        verify(mockGetVehicleTypesUseCase()).called(1);
      },
    );

    blocTest<ApplyViewModel, ApplyState>(
      'emits loading then error with message when fetching vehicle types fails',
      build: () {
        when(mockGetVehicleTypesUseCase()).thenAnswer(
          (_) async => ErrorResponse(
            appError: BadResponseError('Failed to fetch vehicle types'),
          ),
        );
        return viewModel;
      },
      act: (vm) => vm.doEvent(VehicleTypesRequested()),
      expect: () => [
        isA<ApplyState>().having(
          (s) => s.vehicleTypesState,
          'vehicleTypesState',
          const BaseState<List<VehicleTypeEntity>>(isLoading: true),
        ),
        isA<ApplyState>().having(
          (s) => s.vehicleTypesState,
          'vehicleTypesState',
          const BaseState<List<VehicleTypeEntity>>(
            isLoading: false,
            errorMessage: 'Failed to fetch vehicle types',
          ),
        ),
      ],
      verify: (_) {
        verify(mockGetVehicleTypesUseCase()).called(1);
      },
    );
  });

  group('ApplyViewModel - ApplyRequested flow', () {
    const validSeedState = ApplyState(
      firstName: 'John',
      lastName: 'Doe',
      email: 'john@example.com',
      phone: '01012345678',
      nid: '12345678901234',
      plateNumber: '123 ABC',
      password: 'Password123',
      confirmPassword: 'Password123',
      selectedVehicleType: tVehicleType,
      gender: Gender.male,
      licenseImage: 'dummy_license.png',
      idImage: 'dummy_id.png',
    );

    blocTest<ApplyViewModel, ApplyState>(
      'does not call ApplyUseCase and emits validation error when required fields are missing',
      build: () => viewModel,
      seed: () => validSeedState.copyWith(selectedVehicleType: null),
      act: (vm) => vm.doEvent(ApplyRequested()),
      expect: () => [
        isA<ApplyState>().having(
          (s) => s.applyState.errorMessage,
          'errorMessage',
          LocaleKeys.applyCompleteRequiredFields.tr(),
        ),
      ],
      verify: (_) {
        verifyZeroInteractions(mockApplyUseCase);
      },
    );

    blocTest<ApplyViewModel, ApplyState>(
      'does not call ApplyUseCase when licenseImage is missing',
      build: () => viewModel,
      seed: () => validSeedState.copyWith(licenseImage: null),
      act: (vm) => vm.doEvent(ApplyRequested()),
      expect: () => [
        isA<ApplyState>().having(
          (s) => s.applyState.errorMessage,
          'errorMessage',
          LocaleKeys.applyCompleteRequiredFields.tr(),
        ),
      ],
      verify: (_) {
        verifyZeroInteractions(mockApplyUseCase);
      },
    );

    blocTest<ApplyViewModel, ApplyState>(
      'does not call ApplyUseCase when idImage is missing',
      build: () => viewModel,
      seed: () => validSeedState.copyWith(idImage: null),
      act: (vm) => vm.doEvent(ApplyRequested()),
      expect: () => [
        isA<ApplyState>().having(
          (s) => s.applyState.errorMessage,
          'errorMessage',
          LocaleKeys.applyCompleteRequiredFields.tr(),
        ),
      ],
      verify: (_) {
        verifyZeroInteractions(mockApplyUseCase);
      },
    );

    blocTest<ApplyViewModel, ApplyState>(
      'does not call ApplyUseCase when gender is missing',
      build: () => viewModel,
      seed: () => validSeedState.copyWith(gender: null),
      act: (vm) => vm.doEvent(ApplyRequested()),
      expect: () => [
        isA<ApplyState>().having(
          (s) => s.applyState.errorMessage,
          'errorMessage',
          LocaleKeys.applyCompleteRequiredFields.tr(),
        ),
      ],
      verify: (_) {
        verifyZeroInteractions(mockApplyUseCase);
      },
    );

    blocTest<ApplyViewModel, ApplyState>(
      'emits loading then success state and passes correct parameters to use case',
      build: () {
        when(mockApplyUseCase(any)).thenAnswer(
          (_) async => const SuccessResponse(tApplyResult),
        );
        return viewModel;
      },
      seed: () => validSeedState,
      act: (vm) => vm.doEvent(ApplyRequested()),
      expect: () => [
        isA<ApplyState>().having(
          (s) => s.applyState.isLoading,
          'isLoading',
          true,
        ),
        isA<ApplyState>()
            .having((s) => s.applyState.isLoading, 'isLoading', false)
            .having((s) => s.applyState.data, 'data', tApplyResult)
            .having((s) => s.applyState.errorMessage, 'errorMessage', ''),
      ],
      verify: (_) {
        final captured =
            verify(mockApplyUseCase(captureAny)).captured.single as ApplyParams;
        expect(captured.firstName, 'John');
        expect(captured.lastName, 'Doe');
        expect(captured.email, 'john@example.com');
        expect(captured.phone, '01012345678');
        expect(captured.nid, '12345678901234');
        expect(captured.nidImage, 'dummy_id.png');
        expect(captured.vehicleTypeId, tVehicleType.id);
        expect(captured.vehiclePlateNumber, '123 ABC');
        expect(captured.vehicleCapacity, 1);
        expect(captured.licenceImage, 'dummy_license.png');
        expect(captured.gender, Gender.male);
        expect(captured.password, 'Password123');
        expect(captured.confirmPassword, 'Password123');
        expect(captured.fcmToken, '');
      },
    );

    blocTest<ApplyViewModel, ApplyState>(
      'emits loading then error state with message when apply fails',
      build: () {
        when(mockApplyUseCase(any)).thenAnswer(
          (_) async => ErrorResponse(
            appError: BadResponseError('Application failed'),
          ),
        );
        return viewModel;
      },
      seed: () => validSeedState,
      act: (vm) => vm.doEvent(ApplyRequested()),
      expect: () => [
        isA<ApplyState>().having(
          (s) => s.applyState.isLoading,
          'isLoading',
          true,
        ),
        isA<ApplyState>()
            .having((s) => s.applyState.isLoading, 'isLoading', false)
            .having(
              (s) => s.applyState.errorMessage,
              'errorMessage',
              'Application failed',
            ),
      ],
      verify: (_) {
        verify(mockApplyUseCase(any)).called(1);
      },
    );
  });
}
