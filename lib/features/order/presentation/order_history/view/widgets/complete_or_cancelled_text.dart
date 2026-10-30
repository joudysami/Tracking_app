import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/localization/local_key.dart';
import '../../../../../../core/theme/app_color.dart';

enum CardStatus { complete, cancelled }

class CompleteOrCancelledText extends StatelessWidget {
  const CompleteOrCancelledText({super.key, required this.status});

  final CardStatus status;

  @override
  Widget build(BuildContext context) {
    final bool isComplete = status == CardStatus.complete;

    final Color color = isComplete
        ? context.colors.green
        : context.colors.error;

    final IconData icon = isComplete
        ? Icons.check_circle_outline_rounded
        : Icons.cancel_outlined;

    final String text = isComplete
        ? LocaleKeys.statusDelivered.tr()
        : LocaleKeys.statusCancelled.tr();

    return Row(
      children: [
        Icon(icon, color: color, size: 24.r),
        SizedBox(width: 4.w),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
