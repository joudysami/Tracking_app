import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class OrderHistoryShimmer extends StatelessWidget {
  const OrderHistoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: _buildSummaryCardShimmer(context)),
                SizedBox(width: 16.w),
                Expanded(child: _buildSummaryCardShimmer(context)),
              ],
            ),
            SizedBox(height: 24.h),
            _buildShimmerLine(width: 120.w, height: 20.h),
            SizedBox(height: 16.h),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (context, index) => SizedBox(height: 16.h),
              itemBuilder: (context, index) => _buildOrderCardShimmer(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCardShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  Widget _buildOrderCardShimmer(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10.r,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildShimmerLine(width: 100.w, height: 16.h),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildShimmerLine(width: 80.w, height: 20.h),
              _buildShimmerLine(width: 60.w, height: 20.h),
            ],
          ),
          SizedBox(height: 16.h),
          _buildShimmerLine(width: 90.w, height: 14.h),
          SizedBox(height: 8.h),
          _buildAddressCardShimmer(),
          SizedBox(height: 16.h),
          _buildShimmerLine(width: 90.w, height: 14.h),
          SizedBox(height: 8.h),
          _buildAddressCardShimmer(),
        ],
      ),
    );
  }

  Widget _buildAddressCardShimmer() {
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.withAlpha(20)),
      ),
      child: Row(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 40.r,
              height: 40.r,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildShimmerLine(width: 100.w, height: 12.h),
                SizedBox(height: 6.h),
                _buildShimmerLine(width: 150.w, height: 12.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLine({required double width, required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.r),
        ),
      ),
    );
  }
}
