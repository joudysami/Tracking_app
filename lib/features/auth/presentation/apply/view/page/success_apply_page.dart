import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tracking_app/app/router/app_routes.dart';
import 'package:tracking_app/core/constant/app_assets.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/theme/app_color.dart';
import 'package:tracking_app/core/widgets/app_button.dart';

class SuccessApplyPage extends StatelessWidget {
  final String titleKey;
  final String bodyKey;
  final String buttonKey;
  final VoidCallback? onButtonPressed;

  /// One success layout, two uses: the driver application (defaults) and the
  /// order flow, which only changes the wording and the button action.
  const SuccessApplyPage({
    super.key,
    this.titleKey = LocaleKeys.applySuccessTitle,
    this.bodyKey = LocaleKeys.applySuccessBody,
    this.buttonKey = LocaleKeys.authLogin,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 250.h,
            child: Image.asset(
              AppAssets.bgWave,
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  Image.asset(
                    AppAssets.check,
                    width: 120.w,
                    height: 120.w,
                    fit: BoxFit.contain,
                  ),

                  SizedBox(height: 32.h),

                  Text(
                    titleKey.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.black,
                    ),
                  ),

                  SizedBox(height: 12.h),

                  Text(
                    bodyKey.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),

                  const Spacer(flex: 3),

                  Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom + 24.h,
                    ),
                    child: AppButton(
                      text: buttonKey.tr(),
                      onPressed:
                          onButtonPressed ?? () => context.go(AppRoutes.login),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
