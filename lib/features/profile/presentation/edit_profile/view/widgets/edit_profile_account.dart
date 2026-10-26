import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/router/app_routes.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/theme/app_color.dart';
import 'package:tracking_app/core/widgets/app_text_field.dart';
import 'package:tracking_app/features/auth/domain/entities/gender.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile/edit_profile_rules.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile/view_model/edit_profile_event.dart';
import 'package:tracking_app/features/profile/presentation/edit_profile/view_model/edit_profile_view_model.dart';
import 'package:tracking_app/features/profile/presentation/widgets/profile_feedback.dart';

class ProfilePasswordField extends StatelessWidget {
  const ProfilePasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: LocaleKeys.authPassword.tr(),
      initialValue: '••••••',
      readOnly: true,
      suffixIcon: const ProfileChangeButton(),
    );
  }
}

class ProfileChangeButton extends StatelessWidget {
  const ProfileChangeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.push(AppRoutes.resetPassword),
      child: Text(
        LocaleKeys.profileChange.tr(),
        style: TextStyle(color: context.colors.black, fontSize: 14.sp),
      ),
    );
  }
}

class ProfileGenderField extends StatelessWidget {
  const ProfileGenderField({super.key});

  @override
  Widget build(BuildContext context) {
    final gender = context.select((EditProfileViewModel vm) => vm.state.gender);
    return ProfileGenderChoices(gender: gender);
  }
}

class ProfileGenderChoices extends StatelessWidget {
  const ProfileGenderChoices({required this.gender, super.key});

  final Gender? gender;

  @override
  Widget build(BuildContext context) {
    return RadioGroup<Gender>(
      groupValue: gender,
      onChanged: (value) => _selectGender(context, value),
      child: const ProfileGenderRow(),
    );
  }
}

class ProfileGenderRow extends StatelessWidget {
  const ProfileGenderRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(LocaleKeys.applyGender.tr(), style: TextStyle(fontSize: 16.sp)),
        const Spacer(),
        const ProfileGenderOption(Gender.female),
        const ProfileGenderOption(Gender.male),
      ],
    );
  }
}

class ProfileGenderOption extends StatelessWidget {
  const ProfileGenderOption(this.value, {super.key});

  final Gender value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<Gender>(value: value, activeColor: context.colors.pink),
        Text(_genderLabel(value)),
      ],
    );
  }
}

class EditProfileUpdateButton extends StatelessWidget {
  const EditProfileUpdateButton({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.select((EditProfileViewModel vm) => vm.state);
    return UpdateActionButton(
      enabled: canUpdateProfile(state),
      isLoading: state.submit.isLoading,
      onPressed: () => _update(context),
    );
  }
}

String _genderLabel(Gender gender) {
  if (gender == Gender.female) return LocaleKeys.applyFemale.tr();
  return LocaleKeys.applyMale.tr();
}

void _selectGender(BuildContext context, Gender? gender) {
  if (gender == null) return;
  context.read<EditProfileViewModel>().doEvent(GenderChanged(gender));
}

void _update(BuildContext context) {
  context.read<EditProfileViewModel>().doEvent(const UpdateProfileRequested());
}
