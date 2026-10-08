class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://192.168.1.5:5000/',
  );

  static const String forgetPassword = 'api/identity/auth/forget-password';
  static const String verifyOtp = 'api/identity/auth/otp-verification';
  static const String resetPassword = 'api/identity/auth/reset-password';
}