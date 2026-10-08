import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/error/app_error.dart';
import 'package:tracking_app/core/services/image_picker_service.dart';
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
  final tLicenseFile = File('dummy_license.png');
  final tIdFile = File('dummy_id.png');
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

  group('ApplyViewModel - ApplyRequested flow', () {
    blocTest<ApplyViewModel, ApplyState>(
      'emits success state when apply succeeds (leading to success screen navigation)',
      build: () {
        when(mockApplyUseCase(any)).thenAnswer(
          (_) async => const SuccessResponse(tApplyResult),
        );
        return viewModel;
      },
      act: (viewModel) async {
        viewModel.doEvent(FirstNameChanged('John'));
        viewModel.doEvent(LastNameChanged('Doe'));
        viewModel.doEvent(EmailChanged('john@example.com'));
        viewModel.doEvent(PhoneChanged('01012345678'));
        viewModel.doEvent(NidChanged('12345678901234'));
        viewModel.doEvent(PasswordChanged('Password123'));
        viewModel.doEvent(ConfirmPasswordChanged('Password123'));
        viewModel.doEvent(VehicleTypeChanged(tVehicleType));
        viewModel.doEvent(GenderChanged(Gender.male));

        when(mockImagePickerService.pickImage()).thenAnswer(
          (_) async => XFile(tLicenseFile.path),
        );
        await viewModel.doEvent(PickLicenseImageRequested());

        when(mockImagePickerService.pickImage()).thenAnswer(
          (_) async => XFile(tIdFile.path),
        );
        await viewModel.doEvent(PickIdImageRequested());

        await viewModel.doEvent(ApplyRequested());
      },
      verify: (_) {
        verify(mockApplyUseCase(any)).called(1);
      },
      expect: () => [
        isA<ApplyState>().having((s) => s.selectedVehicleType, 'vehicleType', tVehicleType),
        isA<ApplyState>().having((s) => s.gender, 'gender', Gender.male),
        isA<ApplyState>().having((s) => s.licenseImage?.path, 'licenseImage', tLicenseFile.path),
        isA<ApplyState>().having((s) => s.idImage?.path, 'idImage', tIdFile.path),
        isA<ApplyState>().having((s) => s.applyState.isLoading, 'isLoading', true),
        isA<ApplyState>()
            .having((s) => s.applyState.isLoading, 'isLoading', false)
            .having((s) => s.applyState.data, 'data', tApplyResult)
            .having((s) => s.applyState.errorMessage, 'errorMessage', ''),
      ],
    );

    blocTest<ApplyViewModel, ApplyState>(
      'emits error state when apply fails (staying on page and showing error)',
      build: () {
        when(mockApplyUseCase(any)).thenAnswer(
          (_) async => ErrorResponse(appError: BadResponseError('Application failed')),
        );
        return viewModel;
      },
      act: (viewModel) async {
        viewModel.doEvent(FirstNameChanged('John'));
        viewModel.doEvent(LastNameChanged('Doe'));
        viewModel.doEvent(EmailChanged('john@example.com'));
        viewModel.doEvent(PhoneChanged('01012345678'));
        viewModel.doEvent(NidChanged('12345678901234'));
        viewModel.doEvent(PasswordChanged('Password123'));
        viewModel.doEvent(ConfirmPasswordChanged('Password123'));
        viewModel.doEvent(VehicleTypeChanged(tVehicleType));
        viewModel.doEvent(GenderChanged(Gender.male));

        when(mockImagePickerService.pickImage()).thenAnswer(
          (_) async => XFile(tLicenseFile.path),
        );
        await viewModel.doEvent(PickLicenseImageRequested());

        when(mockImagePickerService.pickImage()).thenAnswer(
          (_) async => XFile(tIdFile.path),
        );
        await viewModel.doEvent(PickIdImageRequested());

        await viewModel.doEvent(ApplyRequested());
      },
      verify: (_) {
        verify(mockApplyUseCase(any)).called(1);
      },
      expect: () => [
        isA<ApplyState>().having((s) => s.selectedVehicleType, 'vehicleType', tVehicleType),
        isA<ApplyState>().having((s) => s.gender, 'gender', Gender.male),
        isA<ApplyState>().having((s) => s.licenseImage?.path, 'licenseImage', tLicenseFile.path),
        isA<ApplyState>().having((s) => s.idImage?.path, 'idImage', tIdFile.path),
        isA<ApplyState>().having((s) => s.applyState.isLoading, 'isLoading', true),
        isA<ApplyState>()
            .having((s) => s.applyState.isLoading, 'isLoading', false)
            .having((s) => s.applyState.errorMessage, 'errorMessage', 'Application failed'),
      ],
    );
  });
}
