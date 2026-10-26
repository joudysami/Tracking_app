import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/core/base/base_state.dart';
import 'package:tracking_app/core/extensions/string_extensions.dart';
import 'package:tracking_app/core/services/image_picker_service.dart';
import 'package:tracking_app/features/auth/domain/entities/vehicle_type_entity.dart';
import 'package:tracking_app/features/auth/domain/use_cases/get_vehicle_types_usecase.dart';
import 'package:tracking_app/features/profile/domain/entities/profile_params.dart';
import 'package:tracking_app/features/profile/domain/entities/vehicle_info_entity.dart';
import 'package:tracking_app/features/profile/domain/use_cases/get_vehicle_info_use_case.dart';
import 'package:tracking_app/features/profile/domain/use_cases/update_vehicle_info_use_case.dart';
import 'package:tracking_app/features/profile/presentation/edit_vehicle/vehicle_type_options.dart';

import 'edit_vehicle_event.dart';
import 'edit_vehicle_state.dart';
import 'edit_vehicle_ui_event.dart';

@injectable
class EditVehicleViewModel extends Cubit<EditVehicleState> {
  EditVehicleViewModel(
    this._getVehicle,
    this._updateVehicle,
    this._getTypes,
    this._images,
  ) : super(const EditVehicleState());

  final GetVehicleInfoUseCase _getVehicle;
  final UpdateVehicleInfoUseCase _updateVehicle;
  final GetVehicleTypesUseCase _getTypes;
  final ImagePickerService _images;
  final _ui = StreamController<EditVehicleUiEvent>.broadcast(sync: true);

  Stream<EditVehicleUiEvent> get uiEvents => _ui.stream;

  Future<void> doEvent(EditVehicleEvent event) async {
    switch (event) {
      case EditVehicleStarted():
        await _load();
      case VehicleTypeSelected(:final value):
        emit(state.copyWith(selectedType: value));
      case VehicleNumberChanged(:final value):
        emit(state.copyWith(vehicleNumber: value));
      case LicensePickRequested():
        await _pickLicense();
      case UpdateVehicleRequested():
        await _update();
    }
  }

  Future<void> _load() async {
    emit(_loading());
    final vehicle = await _getVehicle();
    emit(_loaded(vehicle, await _getTypes()));
  }

  EditVehicleState _loading() {
    return state.copyWith(
      vehicle: const BaseState(isLoading: true),
      types: const BaseState(isLoading: true),
    );
  }

  EditVehicleState _loaded(
    BaseResponse<VehicleInfoEntity> vehicle,
    BaseResponse<List<VehicleTypeEntity>> types,
  ) {
    final vehicleState = _vehicleState(vehicle);
    final options = _typeList(types) ?? const <VehicleTypeEntity>[];
    final info = vehicleState.data;
    return state.copyWith(
      vehicle: vehicleState,
      types: BaseState(data: options, errorMessage: _typeError(types)),
      selectedType: matchVehicleType(options, info),
      vehicleNumber: info?.vehicleNumber ?? '',
      licenseName: info?.licenseFileName,
    );
  }

  Future<void> _pickLicense() async {
    final image = await _images.pickImage();
    if (image == null) return;
    emit(
      state.copyWith(licensePath: image.path, licenseName: image.path.fileName),
    );
  }

  Future<void> _update() async {
    final type = state.selectedType;
    if (type == null || state.isSubmitting) return;
    emit(state.copyWith(isSubmitting: true));
    _emitUpdate(await _updateVehicle(_params(type)));
  }

  UpdateVehicleParams _params(VehicleTypeEntity type) {
    return UpdateVehicleParams(
      vehicleTypeId: type.id,
      vehicleNumber: state.vehicleNumber.trim(),
      licensePath: state.licensePath,
    );
  }

  void _emitUpdate(BaseResponse<VehicleInfoEntity> result) {
    switch (result) {
      case SuccessResponse(:final data):
        emit(
          state.copyWith(isSubmitting: false, vehicle: BaseState(data: data)),
        );
        _ui.add(const VehicleSaved());
      case ErrorResponse(:final errorMessage):
        emit(state.copyWith(isSubmitting: false));
        _ui.add(ShowEditVehicleError(errorMessage));
    }
  }

  @override
  Future<void> close() async {
    await _ui.close();
    return super.close();
  }
}

BaseState<VehicleInfoEntity> _vehicleState(
  BaseResponse<VehicleInfoEntity> result,
) {
  return switch (result) {
    SuccessResponse(:final data) => BaseState(data: data),
    ErrorResponse(:final errorMessage) => BaseState(errorMessage: errorMessage),
  };
}

List<VehicleTypeEntity>? _typeList(
  BaseResponse<List<VehicleTypeEntity>> result,
) {
  return switch (result) {
    SuccessResponse(:final data) => data,
    ErrorResponse() => null,
  };
}

String _typeError(BaseResponse<List<VehicleTypeEntity>> result) {
  return switch (result) {
    SuccessResponse() => '',
    ErrorResponse(:final errorMessage) => errorMessage,
  };
}
