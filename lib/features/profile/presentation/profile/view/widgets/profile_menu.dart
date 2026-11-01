import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracking_app/core/constant/app_constants.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/theme/app_color.dart';
import 'package:tracking_app/features/profile/presentation/profile/view/widgets/profile_card.dart';

class ProfileStrongText extends StatelessWidget {
  const ProfileStrongText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
    );
  }
}

class ProfilePlainText extends StatelessWidget {
  const ProfilePlainText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: 14.sp));
  }
}

class ProfileMutedText extends StatelessWidget {
  const ProfileMutedText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 13.sp, color: context.colors.grey.shade800),
    );
  }
}

class ProfileLanguageTile extends StatelessWidget {
  const ProfileLanguageTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileMenuTile(
      icon: Icons.translate,
      label: LocaleKeys.profileLanguage.tr(),
      onTap: () => toggleProfileLanguage(context),
      trailing: const ProfileLanguageValue(),
    );
  }
}

class ProfileLanguageValue extends StatelessWidget {
  const ProfileLanguageValue({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      LocaleKeys.profileLanguageValue.tr(),
      style: TextStyle(color: context.colors.pink, fontSize: 14.sp),
    );
  }
}

class ProfileLogoutTile extends StatelessWidget {
  const ProfileLogoutTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileMenuTile(
      icon: Icons.logout,
      label: LocaleKeys.profileLogoutAction.tr(),
      onTap: () => confirmLogout(context),
      trailing: Icon(Icons.logout, color: context.colors.grey.shade800),
    );
  }
}

class ProfileMenuTile extends StatelessWidget {
  const ProfileMenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.trailing,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        child: ProfileMenuRow(icon: icon, label: label, trailing: trailing),
      ),
    );
  }
}

class ProfileMenuRow extends StatelessWidget {
  const ProfileMenuRow({
    required this.icon,
    required this.label,
    required this.trailing,
    super.key,
  });

  final IconData icon;
  final String label;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: context.colors.black),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(label, style: TextStyle(fontSize: 16.sp)),
        ),
        trailing,
      ],
    );
  }
}

class ProfileVersionLabel extends StatelessWidget {
  const ProfileVersionLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 48.h),
      child: Text(
        _version(),
        textAlign: TextAlign.center,
        style: TextStyle(color: context.colors.grey.shade800, fontSize: 14.sp),
      ),
    );
  }
}

String _version() {
  return LocaleKeys.profileVersion.tr(
    namedArgs: {
      'version': AppConstants.appVersion,
      'build': AppConstants.appBuild,
    },
  );
}

void toggleProfileLanguage(BuildContext context) {
  final code = context.locale.languageCode == 'ar' ? 'en' : 'ar';
  context.setLocale(Locale(code));
}
