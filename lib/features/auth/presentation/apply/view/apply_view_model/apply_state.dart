import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tracking_app/core/base/base_state.dart';
import 'package:tracking_app/features/auth/domain/entities/apply_result_entity.dart';
import 'package:tracking_app/features/auth/domain/entities/gender.dart';
import 'package:tracking_app/features/auth/domain/entities/vehicle_type_entity.dart';

part 'apply_state.freezed.dart';

@freezed
abstract class ApplyState with _$ApplyState {
  const factory ApplyState({
    @Default(BaseState<List<VehicleTypeEntity>>())
    BaseState<List<VehicleTypeEntity>> vehicleTypesState,
    @Default(BaseState<ApplyResultEntity>())
    BaseState<ApplyResultEntity> applyState,

    // Form fields
    @Default('') String firstName,
    @Default('') String lastName,
    @Default('') String plateNumber,
    @Default('') String email,
    @Default('') String phone,
    @Default('') String nid,
    @Default('') String password,
    @Default('') String confirmPassword,

    // Selected values and uploaded images
    VehicleTypeEntity? selectedVehicleType,
    Gender? gender,
    String? licenseImage,
    String? idImage,
  }) = _ApplyState;
}
