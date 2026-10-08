import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracking_app/core/helpers/app_validation.dart';
import 'package:tracking_app/core/widgets/app_button.dart';
import 'package:tracking_app/core/widgets/app_text_field.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';

import '../../../../../../core/localization/local_key.dart';
import '../../view_model/forget_password_event.dart';
import 'step_layout.dart';

class EmailStepView extends StatefulWidget {
  const EmailStepView({super.key});

  @override
  State<EmailStepView> createState() => _EmailStepViewState();
}

class _EmailStepViewState extends State<EmailStepView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(
      text: context.read<ForgetPasswordViewModel>().state.email,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    context.read<ForgetPasswordViewModel>().onEvent(
      SendEmailEvent(_emailController.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
    context.select((ForgetPasswordViewModel v) => v.state.isLoading);

    return StepLayout(
      title: LocaleKeys.authForgotPassword.tr(),
      description: Text(LocaleKeys.authForgotPasswordDesc.tr(),textAlign: TextAlign.center,),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AppTextField(
              label: LocaleKeys.authEmail.tr(),
              hint: LocaleKeys.authEnterEmail.tr(),
              controller: _emailController,
              validator: AppValidators.emailValidator,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              readOnly: isLoading,
            ),
            SizedBox(height: 48.h),
            AppButton(
              text: LocaleKeys.commonContinue.tr(),
              isLoading: isLoading,
              onPressed: isLoading ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}