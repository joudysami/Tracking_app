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
            final types = state.vehicleTypesState.data ?? [];

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
              onChanged: state.vehicleTypesState.isLoading
                  ? null
                  : (value) {
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
              key: ValueKey(file?.path),
              label: LocaleKeys.applyVehicleLicense.tr(),
              hint: LocaleKeys.applyVehicleLicenseHint.tr(),
              initialValue: file?.path.split(RegExp(r'[/\\]')).last,
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
