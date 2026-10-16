import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracking_app/core/theme/app_color.dart';

class FloweryStoreLogo extends StatelessWidget {
  const FloweryStoreLogo({
    super.key,
    this.size = 42,
    this.backgroundColor,
  });

  final double size;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final double widgetSize = size.w;

    return Container(
      width: widgetSize,
      height: widgetSize,
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.pink,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.filter_vintage,
              color: colors.white,
              size: (widgetSize * 0.42),
            ),
            SizedBox(height: 1.h),
            Text(
              'Flowery',
              style: TextStyle(
                color: colors.white,
                fontSize: (widgetSize * 0.17).sp,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
