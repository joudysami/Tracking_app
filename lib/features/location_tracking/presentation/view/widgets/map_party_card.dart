import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracking_app/core/theme/app_color.dart';
import 'package:tracking_app/features/location_tracking/data/models/map_party_model.dart';

class MapPartyCard extends StatelessWidget {
  final MapPartyModel party;
  final VoidCallback? onCall;
  final VoidCallback? onChat;

  const MapPartyCard({
    super.key,
    required this.party,
    this.onCall,
    this.onChat,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.grey.shade600),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22.r,
            backgroundColor: colors.pink,
            backgroundImage: party.imageUrl == null
                ? null
                : CachedNetworkImageProvider(party.imageUrl!),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  party.name,
                  style: TextStyle(
                    color: colors.grey.shade800,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16.sp,
                      color: colors.black,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        party.address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: colors.black, fontSize: 12.sp),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onCall,
            icon: Icon(Icons.phone_outlined, color: colors.pink, size: 20.sp),
          ),
          IconButton(
            onPressed: onChat,
            icon: Icon(Icons.chat_outlined, color: colors.pink, size: 20.sp),
          ),
        ],
      ),
    );
  }
}
