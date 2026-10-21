import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:tracking_app/core/constant/app_constants.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/theme/app_color.dart';
import 'package:tracking_app/features/location_tracking/data/models/map_party_model.dart';
import 'package:tracking_app/features/location_tracking/presentation/view/widgets/map_party_card.dart';
import 'package:tracking_app/features/location_tracking/presentation/view/widgets/map_pill.dart';


enum OrderMapStage { pickup, user }

class OrderMapPage extends StatelessWidget {
  final OrderMapModel order;
  final OrderMapStage stage;

  const OrderMapPage({super.key, required this.order, required this.stage});

  bool get _isPickup => stage == OrderMapStage.pickup;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final target = _isPickup ? order.store : order.user;
    final other = _isPickup ? order.user : order.store;
    final route = _isPickup ? order.pickupRoute : order.userRoute;

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCameraFit: CameraFit.bounds(
                bounds: LatLngBounds.fromPoints(route),
                padding: EdgeInsets.fromLTRB(60.w, 100.h, 60.w, 320.h),
              ),
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: AppConstants.packageName,
              ),
              PolylineLayer(
                polylines: [
                  Polyline(points: route, strokeWidth: 3, color: colors.pink),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: order.driverLocation,
                    width: 110.w,
                    height: 30.h,
                    child: Center(
                      child: MapPill(
                        label: LocaleKeys.orderMapYourLocation.tr(),
                        icon: Icons.my_location,
                      ),
                    ),
                  ),
                  Marker(
                    point: target.location,
                    width: 110.w,
                    height: 30.h,
                    child: Center(
                      child: MapPill(
                        label: _isPickup
                            ? target.name
                            : LocaleKeys.orderMapUser.tr(),
                        icon: _isPickup ? Icons.local_florist : Icons.home,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: CircleAvatar(
                  radius: 18.r,
                  backgroundColor: colors.pink,
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 16.sp,
                    color: colors.white,
                  ),
                ),
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.35,
            minChildSize: 0.25,
            maxChildSize: 0.5,
            builder: (context, controller) {
              return Container(
                decoration: BoxDecoration(
                  color: colors.grey,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.r),
                  ),
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
                      _isPickup
                          ? LocaleKeys.orderMapPickupAddress.tr()
                          : LocaleKeys.orderMapUserAddress.tr(),
                    ),
                    MapPartyCard(party: target),
                    SizedBox(height: 16.h),
                    _SectionLabel(
                      _isPickup
                          ? LocaleKeys.orderMapUserAddress.tr()
                          : LocaleKeys.orderMapPickupAddress.tr(),
                    ),
                    MapPartyCard(party: other),
                  ],
                ),
              );
            },
          ),
        ],
      ),
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
      child: Text(
        text,
        style: TextStyle(
          color: context.colors.grey.shade800,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
