import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracking_app/core/widgets/app_button.dart';
import 'package:tracking_app/core/widgets/app_text_field.dart';
import '../../../../../../core/helpers/app_validation.dart';
import '../../../../../../core/localization/local_key.dart';
import '../../view_model/forget_password_event.dart';
import '../../view_model/forget_password_view_model.dart';
import 'step_layout.dart';

class ResetPasswordStepView extends StatefulWidget {
  const ResetPasswordStepView({super.key});

  @override
  State<ResetPasswordStepView> createState() => _ResetPasswordStepViewState();
}

class _ResetPasswordStepViewState extends State<ResetPasswordStepView> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    context.read<ForgetPasswordViewModel>().onEvent(
      ResetPasswordEvent(
        password: _passwordController.text,
        confirmPassword: _confirmController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
    context.select((ForgetPasswordViewModel v) => v.state.isLoading);

    return StepLayout(
      title: LocaleKeys.authResetPassword.tr(),
      description: Text(LocaleKeys.validationResetPasswordRequirement.tr() ,textAlign: TextAlign.center,),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AppTextField(
              label: LocaleKeys.authNewPassword.tr(),
              hint: LocaleKeys.authEnterPassword.tr(),
              controller: _passwordController,
              validator: AppValidators.passwordValidator,
              isPassword: true,
              textInputAction: TextInputAction.next,
              readOnly: isLoading,
            ),
            SizedBox(height: 24.h),
            AppTextField(
              label: LocaleKeys.authConfirmPassword.tr(),
              hint: LocaleKeys.authConfirmPassword.tr(),
              controller: _confirmController,
              validator: (value) => AppValidators.confirmPasswordValidator(
                value,
                _passwordController.text,
              ),
              isPassword: true,
              textInputAction: TextInputAction.done,
              readOnly: isLoading,
            ),
            SizedBox(height: 48.h),
            AppButton(
              text: LocaleKeys.commonConfirm.tr(),
              isLoading: isLoading,
              onPressed: isLoading ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}