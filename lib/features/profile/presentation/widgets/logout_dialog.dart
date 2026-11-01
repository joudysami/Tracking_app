import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/theme/app_color.dart';
import 'package:tracking_app/core/widgets/app_button.dart';
import 'package:tracking_app/features/profile/presentation/widgets/profile_feedback.dart';

Future<bool> showLogoutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (_) => const LogoutDialog(),
  ).then((value) => value ?? false);
}

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: context.colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      content: const LogoutDialogBody(),
    );
  }
}

class LogoutDialogBody extends StatelessWidget {
  const LogoutDialogBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LogoutDialogTitle(),
        ProfileSectionGap(),
        LogoutDialogMessage(),
        ProfileSectionGap(height: 24),
        LogoutDialogActions(),
      ],
    );
  }
}

class LogoutDialogTitle extends StatelessWidget {
  const LogoutDialogTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      LocaleKeys.profileLogoutTitle.tr(),
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
    );
  }
}

class LogoutDialogMessage extends StatelessWidget {
  const LogoutDialogMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      LocaleKeys.profileLogoutMessage.tr(),
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16.sp),
    );
  }
}

class LogoutDialogActions extends StatelessWidget {
  const LogoutDialogActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: CancelLogoutButton()),
        SizedBox(width: 12.w),
        const Expanded(child: ConfirmLogoutButton()),
      ],
    );
  }
}

class CancelLogoutButton extends StatelessWidget {
  const CancelLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: LocaleKeys.commonCancel.tr(),
      variant: AppButtonVariant.outlined,
      onPressed: () => Navigator.of(context).pop(false),
    );
  }
}

class ConfirmLogoutButton extends StatelessWidget {
  const ConfirmLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: LocaleKeys.profileLogoutAction.tr(),
      onPressed: () => Navigator.of(context).pop(true),
    );
  }
}
