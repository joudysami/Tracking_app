import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/services/image_picker_service.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_result_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/vehicle_type_entity.dart';
import 'package:tracking_app/features/auth/domain/use_cases/apply_use_case.dart';
import 'package:tracking_app/features/auth/domain/use_cases/get_vehicle_types_usecase.dart';

import 'apply_event.dart';
import 'apply_state.dart';

@injectable
class ApplyViewModel extends Cubit<ApplyState> {
  static const _defaultVehicleCapacity = 1;

  ApplyViewModel(
    this._applyUseCase,
    this._getVehicleTypesUseCase,
    this._imagePickerService,
  ) : super(const ApplyState());

  final ApplyUseCase _applyUseCase;
  final GetVehicleTypesUseCase _getVehicleTypesUseCase;
  final ImagePickerService _imagePickerService;

  Future<void> doEvent(ApplyEvent event) async {
    switch (event) {
      case VehicleTypesRequested():
        await _getVehicleTypes();

      case FirstNameChanged():
        emit(state.copyWith(firstName: event.value));

      case LastNameChanged():
        emit(state.copyWith(lastName: event.value));

      case VehicleTypeChanged():
        emit(state.copyWith(selectedVehicleType: event.value));

      case PlateNumberChanged():
        emit(state.copyWith(plateNumber: event.value));

      case EmailChanged():
        emit(state.copyWith(email: event.value));

      case PhoneChanged():
        emit(state.copyWith(phone: event.value));

      case NidChanged():
        emit(state.copyWith(nid: event.value));

      case PasswordChanged():
        emit(state.copyWith(password: event.value));

      case ConfirmPasswordChanged():
        emit(state.copyWith(confirmPassword: event.value));

      case GenderChanged():
        emit(state.copyWith(gender: event.value));

      case PickLicenseImageRequested():
        final image = await _imagePickerService.pickImage();
        if (image != null) {
          emit(state.copyWith(licenseImage: image.path));
        }

      case PickIdImageRequested():
        final image = await _imagePickerService.pickImage();
        if (image != null) {
          emit(state.copyWith(idImage:image.path));
        }

      case ApplyRequested():
        await _apply();
    }
  }

  Future<void> _getVehicleTypes() async {
    emit(
      state.copyWith(
        vehicleTypesState: state.vehicleTypesState.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
      ),
    );

    final response = await _getVehicleTypesUseCase();

    switch (response) {
      case SuccessResponse<List<VehicleTypeEntity>>():
        emit(
          state.copyWith(
            vehicleTypesState: state.vehicleTypesState.copyWith(
              isLoading: false,
              data: response.data,
              errorMessage: '',
            ),
          ),
        );

      case ErrorResponse<List<VehicleTypeEntity>>():
        emit(
          state.copyWith(
            vehicleTypesState: state.vehicleTypesState.copyWith(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
    }
  }

  Future<void> _apply() async {
    final currentState = state;

    final vehicleType = currentState.selectedVehicleType;
    final licenseImage = currentState.licenseImage;
    final idImage = currentState.idImage;
    final gender = currentState.gender;

    if (vehicleType == null ||
        licenseImage == null ||
        idImage == null ||
        gender == null) {
      emit(
        state.copyWith(
          applyState: state.applyState.copyWith(
            errorMessage: LocaleKeys.applyCompleteRequiredFields.tr(),
          ),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        applyState: state.applyState.copyWith(
          isLoading: true,
          errorMessage: '',
        ),
      ),
    );

    final entity = ApplyParams(
      firstName: currentState.firstName,
      lastName: currentState.lastName,
      email: currentState.email,
      phone: currentState.phone,
      nid: currentState.nid,
      nidImage: idImage,
      vehicleTypeId: vehicleType.id,
      vehiclePlateNumber: currentState.plateNumber,
      vehicleCapacity: _defaultVehicleCapacity,
      licenceImage: licenseImage,
      gender: gender,
      password: currentState.password,
      confirmPassword: currentState.confirmPassword,
      fcmToken: '',
    );

    final response = await _applyUseCase(entity);

    switch (response) {
      case SuccessResponse<ApplyResultEntity>():
        emit(
          state.copyWith(
            applyState: state.applyState.copyWith(
              isLoading: false,
              data: response.data,
              errorMessage: '',
            ),
          ),
        );

      case ErrorResponse<ApplyResultEntity>():
        emit(
          state.copyWith(
            applyState: state.applyState.copyWith(
              isLoading: false,
              errorMessage: response.errorMessage,
            ),
          ),
        );
    }
  }
}
