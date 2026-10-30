import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracking_app/core/helpers/app_validation.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/widgets/app_text_field.dart';
import 'package:tracking_app/features/profile/presentation/change_password/can_change_password.dart';
import 'package:tracking_app/features/profile/presentation/change_password/view_model/change_password_event.dart';
import 'package:tracking_app/features/profile/presentation/change_password/view_model/change_password_view_model.dart';
import 'package:tracking_app/features/profile/presentation/widgets/profile_feedback.dart';

class ChangePasswordFields extends StatelessWidget {
  const ChangePasswordFields({
    required this.formKey,
    required this.current,
    required this.next,
    required this.confirm,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController current;
  final TextEditingController next;
  final TextEditingController confirm;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
        children: [
          CurrentPasswordField(controller: current),
          const ProfileSectionGap(),
          NewPasswordField(controller: next),
          const ProfileSectionGap(),
          ConfirmPasswordField(controller: confirm, original: next),
          const ProfileSectionGap(height: 32),
          const ChangePasswordUpdateButton(),
        ],
      ),
    );
  }
}

class CurrentPasswordField extends StatelessWidget {
  const CurrentPasswordField({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label: LocaleKeys.profileCurrentPassword.tr(),
      hint: LocaleKeys.profileCurrentPassword.tr(),
      isPassword: true,
      textInputAction: TextInputAction.next,
      onChanged: (value) => _current(context, value),
      validator: (value) => _currentError(context, value),
    );
  }
}

class NewPasswordField extends StatelessWidget {
  const NewPasswordField({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label: LocaleKeys.profileNewPassword.tr(),
      hint: LocaleKeys.profileNewPassword.tr(),
      isPassword: true,
      textInputAction: TextInputAction.next,
      onChanged: (value) => _next(context, value),
      validator: AppValidators.passwordValidator,
    );
  }
}

class ConfirmPasswordField extends StatelessWidget {
  const ConfirmPasswordField({
    required this.controller,
    required this.original,
    super.key,
  });

  final TextEditingController controller;
  final TextEditingController original;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label: LocaleKeys.profileConfirmPassword.tr(),
      hint: LocaleKeys.profileConfirmPassword.tr(),
      isPassword: true,
      textInputAction: TextInputAction.done,
      onChanged: (value) => _confirm(context, value),
      validator: (value) => _match(value, original.text),
    );
  }
}

class ChangePasswordUpdateButton extends StatelessWidget {
  const ChangePasswordUpdateButton({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.select((ChangePasswordViewModel vm) => vm.state);
    return UpdateActionButton(
      enabled: canChangePassword(state),
      isLoading: state.isLoading,
      onPressed: () => _submit(context),
    );
  }
}

void _current(BuildContext context, String value) {
  context.read<ChangePasswordViewModel>().doEvent(
    CurrentPasswordChanged(value),
  );
}

void _next(BuildContext context, String value) {
  context.read<ChangePasswordViewModel>().doEvent(NewPasswordChanged(value));
}

void _confirm(BuildContext context, String value) {
  context.read<ChangePasswordViewModel>().doEvent(
    ConfirmPasswordChanged(value),
  );
}

String? _currentError(BuildContext context, String? value) {
  final invalid = context
      .read<ChangePasswordViewModel>()
      .state
      .invalidCurrentPassword;
  if (invalid) return LocaleKeys.profileInvalidPassword.tr();
  return AppValidators.requiredField(
    value,
    field: LocaleKeys.profileCurrentPassword.tr(),
  );
}

String? _match(String? value, String password) {
  return AppValidators.confirmPasswordValidator(value, password);
}

void _submit(BuildContext context) {
  context.read<ChangePasswordViewModel>().doEvent(
    const ChangePasswordSubmitted(),
  );
}
