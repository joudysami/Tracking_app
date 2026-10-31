import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app/core/localization/local_key.dart';
import 'package:tracking_app/features/location_tracking/presentation/view/location_tracking_view_model/location_tracking_event.dart';
import 'package:tracking_app/features/location_tracking/presentation/view/location_tracking_view_model/location_tracking_state.dart';
import 'package:tracking_app/features/location_tracking/presentation/view/location_tracking_view_model/location_tracking_view_model.dart';

class LocationTrackingDialogs {
  const LocationTrackingDialogs._();

  static void showPermissionDialog(
    BuildContext context,
    LocationTrackingViewModel viewModel,
  ) {
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

  static void showLocationSettingsDialog(
    BuildContext context,
    LocationTrackingViewModel viewModel,
  ) {
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

  static void handleState(
    BuildContext context,
    LocationTrackingState state,
    LocationTrackingViewModel viewModel,
  ) {
    if (state.shouldShowPermissionDialog) {
      showPermissionDialog(context, viewModel);
    }

    if (state.shouldShowLocationSettingsDialog) {
      showLocationSettingsDialog(context, viewModel);
    }
  }
}
