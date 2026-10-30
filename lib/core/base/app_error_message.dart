import 'package:tracking_app/core/error/app_error.dart';

/// Maps an [AppError] to a message that is safe to show the user.
/// Returns `null` for errors that should be handled silently (no snackbar).
extension AppErrorMessage on AppError {
  String? toUserMessage() {
    if (this is IgnoreError) return null;
    return message;
  }
}
