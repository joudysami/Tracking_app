import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracking_app/core/helpers/app_validation.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/widgets/app_text_field.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile/view_model/edit_profile_event.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile/view_model/edit_profile_view_model.dart';

class ProfileNameFields extends StatelessWidget {
  const ProfileNameFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(child: ProfileFirstNameField()),
        SizedBox(width: 12.w),
        const Expanded(child: ProfileLastNameField()),
      ],
    );
  }
}

class ProfileFirstNameField extends StatelessWidget {
  const ProfileFirstNameField({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileBoundField(
      label: LocaleKeys.profileFirstName.tr(),
      value: context.read<EditProfileViewModel>().state.firstName,
      onChanged: (value) => _send(context, FirstNameChanged(value)),
      validator: (value) => AppValidators.requiredField(
        value,
        field: LocaleKeys.profileFirstName.tr(),
      ),
    );
  }
}

class ProfileLastNameField extends StatelessWidget {
  const ProfileLastNameField({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileBoundField(
      label: LocaleKeys.profileLastName.tr(),
      value: context.read<EditProfileViewModel>().state.lastName,
      onChanged: (value) => _send(context, LastNameChanged(value)),
      validator: (value) => AppValidators.requiredField(
        value,
        field: LocaleKeys.profileLastName.tr(),
      ),
    );
  }
}

class ProfileEmailField extends StatelessWidget {
  const ProfileEmailField({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileBoundField(
      label: LocaleKeys.authEmail.tr(),
      value: context.read<EditProfileViewModel>().state.email,
      keyboardType: TextInputType.emailAddress,
      readOnly: true,
      validator: AppValidators.emailValidator,
    );
  }
}

class ProfilePhoneField extends StatelessWidget {
  const ProfilePhoneField({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileBoundField(
      label: LocaleKeys.authPhone.tr(),
      value: context.read<EditProfileViewModel>().state.phone,
      keyboardType: TextInputType.phone,
      onChanged: (value) => _send(context, PhoneChanged(value)),
      validator: AppValidators.phoneValidator,
    );
  }
}

class ProfileBoundField extends StatelessWidget {
  const ProfileBoundField({
    required this.label,
    required this.value,
    this.onChanged,
    this.keyboardType,
    this.readOnly = false,
    this.validator,
    super.key,
  });

  final String label;
  final String value;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final bool readOnly;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: label,
      hint: label,
      initialValue: value,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      readOnly: readOnly,
      onChanged: onChanged,
      validator: validator,
    );
  }
}

void _send(BuildContext context, EditProfileEvent event) {
  context.read<EditProfileViewModel>().doEvent(event);
}
