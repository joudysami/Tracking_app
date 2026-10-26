import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/theme/app_color.dart';
import 'package:tracking_app/features/location_tracking/data/models/map_party_model.dart';
import 'package:tracking_app/features/location_tracking/presentation/view/widgets/map_party_card.dart';

class OrderMapBottomSheet extends StatelessWidget {
  final MapPartyModel target;
  final MapPartyModel other;
  final bool isPickup;

  const OrderMapBottomSheet({
    super.key,
    required this.target,
    required this.other,
    required this.isPickup,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return DraggableScrollableSheet(
      initialChildSize: 0.35,
      minChildSize: 0.25,
      maxChildSize: 0.5,
      builder: (context, controller) {
        return Container(
          decoration: BoxDecoration(
            color: colors.grey,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: ListView(
            controller: controller,
            padding: EdgeInsets.all(16.w),
            children: [
              Center(
                child: Container(
                  width: 60.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: colors.pink,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              _SectionLabel(
                isPickup
                    ? LocaleKeys.orderMapPickupAddress.tr()
                    : LocaleKeys.orderMapUserAddress.tr(),
              ),
              MapPartyCard(party: target),
              SizedBox(height: 16.h),
              _SectionLabel(
                isPickup
                    ? LocaleKeys.orderMapUserAddress.tr()
                    : LocaleKeys.orderMapPickupAddress.tr(),
              ),
              MapPartyCard(party: other),
            ],
          ),
        );
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(text, style: Theme.of(context).textTheme.titleSmall),
    );
  }
}
