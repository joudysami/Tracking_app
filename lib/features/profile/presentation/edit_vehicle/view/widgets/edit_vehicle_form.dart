import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/widgets/app_text_field.dart';
import 'package:tracking_app/features/auth/domain/entities/vehicle_type_entity.dart';
import 'package:tracking_app/features/profile/presentation/edit_vehicle/edit_vehicle_rules.dart';
import 'package:tracking_app/features/profile/presentation/edit_vehicle/view_model/edit_vehicle_event.dart';
import 'package:tracking_app/features/profile/presentation/edit_vehicle/view_model/edit_vehicle_view_model.dart';
import 'package:tracking_app/features/profile/presentation/profile/view/widgets/profile_summary.dart';
import 'package:tracking_app/features/profile/presentation/widgets/profile_feedback.dart';

class EditVehicleForm extends StatelessWidget {
  const EditVehicleForm({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
      children: const [
        VehicleTypeDropdown(),
        ProfileSectionGap(),
        VehicleNumberField(),
        ProfileSectionGap(),
        VehicleLicenseField(),
        ProfileSectionGap(height: 48),
        VehicleUpdateButton(),
      ],
    );
  }
}

class VehicleTypeDropdown extends StatelessWidget {
  const VehicleTypeDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.select((EditVehicleViewModel vm) => vm.state);
    final types = state.types.data ?? const <VehicleTypeEntity>[];
    if (types.isEmpty && state.types.errorMessage.isNotEmpty) {
      return Text(state.types.errorMessage);
    }
    return DropdownButtonFormField<VehicleTypeEntity>(
      isExpanded: true,
      initialValue: state.selectedType,
      decoration: InputDecoration(labelText: LocaleKeys.applyVehicleType.tr()),
      items: vehicleTypeItems(types),
      onChanged: (value) => _selectType(context, value),
    );
  }
}

class VehicleNumberField extends StatelessWidget {
  const VehicleNumberField({super.key});

  @override
  Widget build(BuildContext context) {
    final number = context.read<EditVehicleViewModel>().state.vehicleNumber;
    return AppTextField(
      label: LocaleKeys.applyVehicleNumber.tr(),
      hint: LocaleKeys.applyVehicleNumberHint.tr(),
      initialValue: number,
      textInputAction: TextInputAction.next,
      onChanged: (value) => _number(context, value),
    );
  }
}

class VehicleLicenseField extends StatelessWidget {
  const VehicleLicenseField({super.key});

  @override
  Widget build(BuildContext context) {
    final name = context.select(
      (EditVehicleViewModel vm) => vm.state.licenseName,
    );
    return AppTextField(
      key: ValueKey(name),
      label: LocaleKeys.applyVehicleLicense.tr(),
      hint: LocaleKeys.applyVehicleLicenseHint.tr(),
      initialValue: name,
      readOnly: true,
      onTap: () => _pick(context),
      suffixIcon: const Icon(Icons.upload_outlined),
    );
  }
}

class VehicleUpdateButton extends StatelessWidget {
  const VehicleUpdateButton({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.select((EditVehicleViewModel vm) => vm.state);
    return UpdateActionButton(
      enabled: canUpdateVehicle(state),
      isLoading: state.isSubmitting,
      onPressed: () => _update(context),
    );
  }
}

List<DropdownMenuItem<VehicleTypeEntity>> vehicleTypeItems(
  List<VehicleTypeEntity> types,
) {
  return [
    for (final type in types)
      DropdownMenuItem(value: type, child: Text(vehicleTypeLabel(type.name))),
  ];
}

void _selectType(BuildContext context, VehicleTypeEntity? value) {
  if (value == null) return;
  context.read<EditVehicleViewModel>().doEvent(VehicleTypeSelected(value));
}

void _number(BuildContext context, String value) {
  context.read<EditVehicleViewModel>().doEvent(VehicleNumberChanged(value));
}

void _pick(BuildContext context) {
  context.read<EditVehicleViewModel>().doEvent(const LicensePickRequested());
}

void _update(BuildContext context) {
  context.read<EditVehicleViewModel>().doEvent(const UpdateVehicleRequested());
}
