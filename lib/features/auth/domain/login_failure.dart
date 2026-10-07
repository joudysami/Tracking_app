import 'package:tracking_app/core/error/app_error.dart';

bool isCredentialLoginFailure(AppError error) {
  if (error is UnauthorizedError) return true;
  final message = error.message.toLowerCase();
  return message.contains('invalid email or password') ||
      message.contains('email or password is incorrect');
}
