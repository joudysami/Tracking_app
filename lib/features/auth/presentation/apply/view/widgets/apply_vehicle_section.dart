import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracking_app/core/helpers/app_validation.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/widgets/app_text_field.dart';
import 'package:tracking_app/features/auth/domain/entities/vehicle_type_entity.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/apply_view_model/apply_event.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/apply_view_model/apply_state.dart';
import 'package:tracking_app/features/auth/presentation/apply/view/apply_view_model/apply_view_model.dart';

class ApplyVehicleSection extends StatelessWidget {
  const ApplyVehicleSection({super.key, required this.viewModel});

  final ApplyViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<ApplyViewModel, ApplyState>(
          buildWhen: (previous, current) =>
              previous.vehicleTypesState != current.vehicleTypesState ||
              previous.selectedVehicleType != current.selectedVehicleType,
          builder: (context, state) {
            final vehicleTypesState = state.vehicleTypesState;
            final types = vehicleTypesState.data ?? [];

            if (vehicleTypesState.isLoading) {
              return InputDecorator(
                decoration: InputDecoration(
                  labelText: LocaleKeys.applyVehicleType.tr(),
                  border: const OutlineInputBorder(),
                ),
                child: SizedBox(
                  height: 24.h,
                  child: const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
              );
            }

            if (vehicleTypesState.errorMessage.isNotEmpty) {
              return InputDecorator(
                decoration: InputDecoration(
                  labelText: LocaleKeys.applyVehicleType.tr(),
                  border: const OutlineInputBorder(),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        vehicleTypesState.errorMessage,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Retry',
                      onPressed: () {
                        viewModel.doEvent(VehicleTypesRequested());
                      },
                      icon: const Icon(Icons.refresh),
                    ),
                  ],
                ),
              );
            }

            if (types.isEmpty) {
              return InputDecorator(
                decoration: InputDecoration(
                  labelText: LocaleKeys.applyVehicleType.tr(),
                  border: const OutlineInputBorder(),
                ),
                child: Text(
                  LocaleKeys.applyNoVehicleTypesAvailable.tr(),
                  style: TextStyle(fontSize: 14.sp),
                ),
              );
            }

            return DropdownButtonFormField<VehicleTypeEntity>(
              isExpanded: true,
              value: state.selectedVehicleType,
              decoration: InputDecoration(
                labelText: LocaleKeys.applyVehicleType.tr(),
              ),
              hint: Text(LocaleKeys.applyVehicleTypeHint.tr()),
              items: types
                  .map(
                    (type) => DropdownMenuItem<VehicleTypeEntity>(
                      value: type,
                      child: Text(type.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                viewModel.doEvent(VehicleTypeChanged(value));
              },
            );
          },
        ),
        SizedBox(height: 16.h),
        AppTextField(
          label: LocaleKeys.applyVehicleNumber.tr(),
          hint: LocaleKeys.applyVehicleNumberHint.tr(),
          textInputAction: TextInputAction.next,
          onChanged: (value) {
            viewModel.doEvent(PlateNumberChanged(value));
          },
          validator: AppValidators.validateVehicleNumber,
        ),
        SizedBox(height: 16.h),
        BlocBuilder<ApplyViewModel, ApplyState>(
          buildWhen: (previous, current) =>
              previous.licenseImage != current.licenseImage,
          builder: (context, state) {
            final file = state.licenseImage;

            return AppTextField(
              key: ValueKey(file),
              label: LocaleKeys.applyVehicleLicense.tr(),
              hint: LocaleKeys.applyVehicleLicenseHint.tr(),
              initialValue: file?.split(RegExp(r'[/\\]')).last,
              readOnly: true,
              onTap: () {
                viewModel.doEvent(PickLicenseImageRequested());
              },
              suffixIcon: const Icon(Icons.upload_outlined),
              validator: (value) => AppValidators.requiredField(
                value,
                field: LocaleKeys.applyVehicleLicense.tr(),
              ),
            );
          },
        ),
      ],
    );
  }
}