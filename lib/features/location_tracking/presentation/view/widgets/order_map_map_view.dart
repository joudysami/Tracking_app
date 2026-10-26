import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:tracking_app/core/constant/app_constants.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/theme/app_color.dart';
import 'package:tracking_app/features/location_tracking/data/models/map_party_model.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/location_entity.dart';
import 'package:tracking_app/features/location_tracking/domain/entities/route_entity.dart';
import 'package:tracking_app/features/location_tracking/presentation/view/location_tracking_view_model/location_tracking_state.dart';
import 'package:tracking_app/features/location_tracking/presentation/view/location_tracking_view_model/location_tracking_view_model.dart';
import 'package:tracking_app/features/location_tracking/presentation/view/widgets/map_pill.dart';

class OrderMapMapView extends StatelessWidget {
  final LatLng initialDriverPoint;
  final MapPartyModel target;
  final bool isPickup;

  const OrderMapMapView({
    super.key,
    required this.initialDriverPoint,
    required this.target,
    required this.isPickup,
  });

  @override
  Widget build(BuildContext context) {
    final cameraPoints = [initialDriverPoint, target.location];

    return FlutterMap(
      options: MapOptions(
        initialCameraFit: CameraFit.bounds(
          bounds: LatLngBounds.fromPoints(cameraPoints),
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

        // Rebuild the route layer only when route points change.
        BlocSelector<
          LocationTrackingViewModel,
          LocationTrackingState,
          List<RoutePointEntity>
        >(
          selector: (state) => state.routePoints,
          builder: (context, routePoints) {
            if (routePoints.length < 2) {
              return const SizedBox.shrink();
            }

            final points = routePoints
                .map((point) => LatLng(point.latitude, point.longitude))
                .toList();

            return PolylineLayer(
              polylines: [
                Polyline(
                  points: points,
                  strokeWidth: 3,
                  color: context.colors.pink,
                ),
              ],
            );
          },
        ),

        // Rebuild the markers only when the driver's location changes.
        BlocSelector<
          LocationTrackingViewModel,
          LocationTrackingState,
          LocationEntity?
        >(
          selector: (state) => state.currentLocation,
          builder: (context, currentLocation) {
            final driverPoint = currentLocation == null
                ? initialDriverPoint
                : LatLng(currentLocation.lat, currentLocation.lng);

            return MarkerLayer(
              markers: [
                Marker(
                  point: driverPoint,
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
                      label: isPickup
                          ? target.name
                          : LocaleKeys.orderMapUser.tr(),
                      icon: isPickup ? Icons.local_florist : Icons.home,
                    ),
                  ),
                ),
              ],
            );
          },
        ),

        // Rebuild the loading indicator only when its value changes.
        BlocSelector<LocationTrackingViewModel, LocationTrackingState, bool>(
          selector: (state) => state.isRouteLoading,
          builder: (context, isRouteLoading) {
            if (!isRouteLoading) {
              return const SizedBox.shrink();
            }

            return Positioned(
              top: 60.h,
              right: 16.w,
              child: const CircularProgressIndicator(),
            );
          },
        ),
      ],
    );
  }
}
