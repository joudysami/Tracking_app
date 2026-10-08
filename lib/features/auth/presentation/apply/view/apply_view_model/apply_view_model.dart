import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/services/image_picker_service.dart';
import 'package:tracking_app/features/auth/data/models/apply_request_model.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_result_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/gender.dart';
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

  String _firstName = '';
  String _lastName = '';
  String _plateNumber = '';
  String _email = '';
  String _phone = '';
  String _nid = '';
  String _password = '';
  String _confirmPassword = '';

  Future<void> doEvent(ApplyEvent event) async {
    switch (event) {
      case VehicleTypesRequested():
        await _getVehicleTypes();

      case FirstNameChanged():
        _firstName = event.value;

      case LastNameChanged():
        _lastName = event.value;

      case VehicleTypeChanged():
        emit(state.copyWith(selectedVehicleType: event.value));

      case PlateNumberChanged():
        _plateNumber = event.value;

      case EmailChanged():
        _email = event.value;

      case PhoneChanged():
        _phone = event.value;

      case NidChanged():
        _nid = event.value;

      case PasswordChanged():
        _password = event.value;

      case ConfirmPasswordChanged():
        _confirmPassword = event.value;

      case GenderChanged():
        emit(state.copyWith(gender: event.value));

      case PickLicenseImageRequested():
        final image = await _imagePickerService.pickImage();
        if (image != null) {
          emit(state.copyWith(licenseImage: File(image.path)));
        }

      case PickIdImageRequested():
        final image = await _imagePickerService.pickImage();
        if (image != null) {
          emit(state.copyWith(idImage: File(image.path)));
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
    final vehicleType = state.selectedVehicleType;
    final licenseImage = state.licenseImage;
    final idImage = state.idImage;
    final gender = state.gender;

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

    final request = ApplyRequestModel(
      firstName: _firstName,
      lastName: _lastName,
      email: _email,
      phone: _phone,
      nid: _nid,
      nidImagePath: idImage.path,
      vehicleTypeId: vehicleType.id,
      vehiclePlateNumber: _plateNumber,
      vehicleCapacity: _defaultVehicleCapacity,
      licenceImagePath: licenseImage.path,
      gender: gender.apiValue,
      password: _password,
      confirmPassword: _confirmPassword,
      fcmToken: '',
    );

    final response = await _applyUseCase(request);

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
