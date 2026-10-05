import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:tracking_app/core/constant/app_constants.dart';
import 'package:tracking_app/core/widgets/app_button.dart';

class OnBordingPage extends StatelessWidget {
  const OnBordingPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Lottie.asset(
                'assets/animations/tracking_delivery.json',
                width: double.infinity,
                height: 280.h,
                fit: BoxFit.contain,
                repeat: true,
              ),
              SizedBox(height: 40.h),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  AppConstants.welcometoFloweryRiderApp,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.3,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              AppButton(
                text: AppConstants.login,
              
                onPressed: () {
                  // TODO: navigate to login
                },
              ),
              SizedBox(height: 16.h),
              AppButton(
                text: AppConstants.applyNow,
                variant: AppButtonVariant.outlined,
                onPressed: () {
                  // TODO: navigate to apply
                },
              ),
              const Spacer(flex: 2),
              
            ],
          ),
        ),
      ),
    );
  }
}
