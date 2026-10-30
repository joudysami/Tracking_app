import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/core/theme/app_color.dart';

import '../../../core/localization/local_key.dart';

class LoadMoreButton extends StatelessWidget {
  const LoadMoreButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        LocaleKeys.commonLoadMore.tr(),
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: context.colors.pink,
        ),
      ),
    );
  }
}
