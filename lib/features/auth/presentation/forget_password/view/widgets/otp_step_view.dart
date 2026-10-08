import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracking_app/core/widgets/app_otp_field.dart';
import 'package:tracking_app/features/auth/presentation/forget_password/view_model/forget_password_view_model.dart';
import '../../../../../../core/helpers/app_validation.dart';
import '../../../../../../core/localization/local_key.dart';
import '../../view_model/forget_password_event.dart';
import 'resend_code_button.dart';
import 'step_layout.dart';

class OtpStepView extends StatefulWidget {
  const OtpStepView({super.key});

  @override
  State<OtpStepView> createState() => _OtpStepViewState();
}

class _OtpStepViewState extends State<OtpStepView> {
  String? _errorText;

  void _onChanged(String value) {
    if (_errorText != null) {
      setState(() => _errorText = null);
    }
  }

  void _onCompleted(String value) {
    final otp = value.trim();
    final error = AppValidators.otpValidator(otp);

    if (error != null) {
      setState(() => _errorText = error);
      return;
    }

    FocusScope.of(context).unfocus();

    context.read<ForgetPasswordViewModel>().onEvent(VerifyOtpEvent(otp));
  }

  void _resend() {
    context.read<ForgetPasswordViewModel>().onEvent(const ResendOtpEvent());
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select(
      (ForgetPasswordViewModel v) => v.state.isLoading,
    );

    return StepLayout(
      title: LocaleKeys.authOtpTitle.tr(),
      description: Text(
        LocaleKeys.authOtpSubtitle.tr(),
        textAlign: TextAlign.center,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppOtpField(
            autoFocus: true,
            enabled: !isLoading,
            errorText: _errorText,
            onChanged: _onChanged,
            onCompleted: _onCompleted,
          ),
          SizedBox(height: 16.h),

          // Keep the resend button in the tree so its cooldown
          // state is preserved while verification is loading.
          Stack(
            alignment: Alignment.center,
            children: [
              IgnorePointer(
                ignoring: isLoading,
                child: Opacity(
                  opacity: isLoading ? 0 : 1,
                  child: Row(
                    children: [
                      Text(LocaleKeys.authDidntReceiveCode.tr()),
                      SizedBox(width: 4.w),
                      ResendCodeButton(onResend: _resend, enabled: !isLoading),
                    ],
                  ),
                ),
              ),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isLoading
                    ? Container(
                        key: const ValueKey('verifying'),
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 18.w,
                              height: 18.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              LocaleKeys.commonLoading.tr(),
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(key: ValueKey('empty')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
