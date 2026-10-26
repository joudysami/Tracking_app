import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracking_app/core/theme/app_color.dart';

class MapPill extends StatelessWidget {
  final String label;
  final IconData icon;

  const MapPill({super.key, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: context.colors.pink,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: context.colors.white),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(color: context.colors.white, fontSize: 10.sp),
          ),
        ],
      ),
    );
  }
}
