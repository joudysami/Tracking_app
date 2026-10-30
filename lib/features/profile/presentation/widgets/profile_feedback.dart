import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/theme/app_color.dart';
import 'package:tracking_app/core/widgets/app_button.dart';

class ProfileSectionGap extends StatelessWidget {
  const ProfileSectionGap({this.height = 16, super.key});

  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(height: height.h);
}

class ProfileLoading extends StatelessWidget {
  const ProfileLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator(color: context.colors.pink));
  }
}

class ProfileErrorView extends StatelessWidget {
  const ProfileErrorView({
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ProfileErrorContent(message: message, onRetry: onRetry),
    );
  }
}

class ProfileErrorContent extends StatelessWidget {
  const ProfileErrorContent({
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          const ProfileSectionGap(),
          ProfileRetryButton(onRetry: onRetry),
        ],
      ),
    );
  }
}

class ProfileRetryButton extends StatelessWidget {
  const ProfileRetryButton({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return AppButton(text: LocaleKeys.commonRetry.tr(), onPressed: onRetry);
  }
}

class UpdateActionButton extends StatelessWidget {
  const UpdateActionButton({
    required this.enabled,
    required this.isLoading,
    required this.onPressed,
    super.key,
  });

  final bool enabled;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: LocaleKeys.profileUpdate.tr(),
      isLoading: isLoading,
      onPressed: enabled ? onPressed : null,
    );
  }
}
