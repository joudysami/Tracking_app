import 'package:tracking_app/core/error/app_error.dart';

extension AppErrorMessage on AppError {
  String? toUserMessage() {
    if (this is IgnoreError) return null;
    return message;
  }
}
