import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tracking_app/core/constant/app_assets.dart';
import 'package:tracking_app/core/theme/app_color.dart';

import '../../../../../../core/localization/local_key.dart';

class OrderAddressCard extends StatelessWidget {
  const OrderAddressCard({
    super.key,
    this.addressLine,
    this.userName,
    this.isStore = false,
  });

  final String? addressLine;
  final String? userName;
  final bool isStore;
  final String storeAddress = "20th st, Sheikh Zayed, Giza";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isStore
              ? LocaleKeys.homePickupAddress.tr()
              : LocaleKeys.homeUserAddress.tr(),
          style: TextStyle(
            fontSize: 12.sp,
            color: context.colors.grey.shade900,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: context.colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(20),
                blurRadius: 10.r,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(8.r),
            leading: CircleAvatar(
              radius: 25.r,
              backgroundColor: context.colors.pink,
              child: isStore
                  ? SvgPicture.asset(AppAssets.storeImage, fit: BoxFit.fill)
                  : Icon(Icons.person_rounded, color: context.colors.white),
            ),
            title: Text(
              isStore ? LocaleKeys.homeFloweryStore.tr() : userName ?? '_',
              style: TextStyle(
                fontSize: 12.sp,
                color: context.colors.grey.shade900,
              ),
            ),
            subtitle: Row(
              children: [
                SvgPicture.asset(AppAssets.pin, width: 16.r),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    isStore ? storeAddress : addressLine ?? '_',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: context.colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
