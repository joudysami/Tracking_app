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
import 'package:tracking_app/features/location_tracking/presentation/view/location_tracking_view_model/location_tracking_error.dart';
import 'package:tracking_app/features/location_tracking/presentation/view/location_tracking_view_model/location_tracking_event.dart';
import 'package:tracking_app/features/location_tracking/presentation/view/location_tracking_view_model/location_tracking_state.dart';
import 'package:tracking_app/features/location_tracking/presentation/view/location_tracking_view_model/location_tracking_view_model.dart';
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

    return BlocConsumer<LocationTrackingViewModel, LocationTrackingState>(
      listenWhen: (previous, current) {
        return previous.shouldShowPermissionDialog !=
                current.shouldShowPermissionDialog ||
            previous.shouldShowLocationSettingsDialog !=
                current.shouldShowLocationSettingsDialog ||
            previous.error != current.error;
      },
      listener: (context, state) {
        final viewModel = context.read<LocationTrackingViewModel>();

        if (state.shouldShowPermissionDialog) {
          showDialog<void>(
            context: context,
            builder: (dialogContext) => AlertDialog(
              title: Text(LocaleKeys.locationPermissionDialogTitle.tr()),
              content: Text(LocaleKeys.locationPermissionDialogMessage.tr()),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    viewModel.doEvent(LocationPermissionDialogDismissed());
                  },
                  child: Text(LocaleKeys.cancel.tr()),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    viewModel.doEvent(OpenAppSettingsRequested());
                  },
                  child: Text(LocaleKeys.locationOpenSettings.tr()),
                ),
              ],
            ),
          );
        }

        if (state.shouldShowLocationSettingsDialog) {
          showDialog<void>(
            context: context,
            builder: (dialogContext) => AlertDialog(
              title: Text(LocaleKeys.locationServiceDisabledTitle.tr()),
              content: Text(LocaleKeys.locationServiceDisabledMessage.tr()),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    viewModel.doEvent(LocationSettingsDialogDismissed());
                  },
                  child: Text(LocaleKeys.cancel.tr()),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    viewModel.doEvent(OpenLocationSettingsRequested());
                  },
                  child: Text(LocaleKeys.locationOpenSettings.tr()),
                ),
              ],
            ),
          );
        }

        if (state.error != null) {
          final message = _errorMessage(state.error!);

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(message)));
        }
      },
      builder: (context, state) {
        // Use the real location after the first GPS update.
        // Keep the mock location as the initial fallback.
        final currentLocation = state.currentLocation;

        final driverPoint = currentLocation == null
            ? order.driverLocation
            : LatLng(currentLocation.lat, currentLocation.lng);

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
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: AppConstants.packageName,
                  ),
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: route,
                        strokeWidth: 3,
                        color: colors.pink,
                      ),
                    ],
                  ),
                  MarkerLayer(
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
      },
    );
  }

  String _errorMessage(LocationTrackingError error) {
    switch (error) {
      case LocationTrackingError.serviceCheckFailed:
        return LocaleKeys.locationServiceCheckFailed.tr();
      case LocationTrackingError.permissionCheckFailed:
        return LocaleKeys.locationPermissionCheckFailed.tr();
      case LocationTrackingError.permissionDenied:
        return LocaleKeys.locationPermissionDenied.tr();
      case LocationTrackingError.locationStreamFailed:
        return LocaleKeys.locationStreamFailed.tr();
      case LocationTrackingError.reportFailed:
        return LocaleKeys.locationReportFailed.tr();
      case LocationTrackingError.openSettingsFailed:
        return LocaleKeys.locationOpenSettingsFailed.tr();
    }
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
