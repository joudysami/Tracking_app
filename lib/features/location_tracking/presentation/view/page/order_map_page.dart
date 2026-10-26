import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/core/theme/app_color.dart';
import 'package:tracking_app/features/location_tracking/data/models/map_party_model.dart';
import 'package:tracking_app/features/location_tracking/presentation/view/location_tracking_view_model/location_tracking_error.dart';
import 'package:tracking_app/features/location_tracking/presentation/view/location_tracking_view_model/location_tracking_event.dart';
import 'package:tracking_app/features/location_tracking/presentation/view/location_tracking_view_model/location_tracking_state.dart';
import 'package:tracking_app/features/location_tracking/presentation/view/location_tracking_view_model/location_tracking_view_model.dart';
import 'package:tracking_app/features/location_tracking/presentation/view/widgets/ocation_tracking_dialogs.dart';
import 'package:tracking_app/features/location_tracking/presentation/view/widgets/order_map_bottom_sheet.dart';
import 'package:tracking_app/features/location_tracking/presentation/view/widgets/order_map_map_view.dart';

enum OrderMapStage { pickup, user }

class OrderMapPage extends StatefulWidget {
  final OrderMapModel order;
  final OrderMapStage stage;

  const OrderMapPage({super.key, required this.order, required this.stage});

  @override
  State<OrderMapPage> createState() => _OrderMapPageState();
}

class _OrderMapPageState extends State<OrderMapPage> {
  bool get _isPickup => widget.stage == OrderMapStage.pickup;

  @override
  void initState() {
    super.initState();

    final driver = widget.order.driverLocation;
    final target = _isPickup
        ? widget.order.store.location
        : widget.order.user.location;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      unawaited(
        context.read<LocationTrackingViewModel>().doEvent(
          RouteRequested(
            startLatitude: driver.latitude,
            startLongitude: driver.longitude,
            endLatitude: target.latitude,
            endLongitude: target.longitude,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final target = _isPickup ? widget.order.store : widget.order.user;
    final other = _isPickup ? widget.order.user : widget.order.store;

    return BlocListener<LocationTrackingViewModel, LocationTrackingState>(
      listenWhen: (previous, current) =>
          previous.shouldShowPermissionDialog !=
              current.shouldShowPermissionDialog ||
          previous.shouldShowLocationSettingsDialog !=
              current.shouldShowLocationSettingsDialog ||
          previous.error != current.error,
      listener: (context, state) {
        final viewModel = context.read<LocationTrackingViewModel>();

        LocationTrackingDialogs.handleState(context, state, viewModel);

        if (state.error != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(_errorMessage(state.error!))),
            );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            OrderMapMapView(
              initialDriverPoint: widget.order.driverLocation,
              target: target,
              isPickup: _isPickup,
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
            OrderMapBottomSheet(
              target: target,
              other: other,
              isPickup: _isPickup,
            ),
          ],
        ),
      ),
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
      case LocationTrackingError.routeLoadFailed:
        return LocaleKeys.locationRouteLoadFailed.tr();
    }
  }
}
