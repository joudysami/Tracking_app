class LoginRequest {
  const LoginRequest({
    required this.email,
    required this.password,
    this.deviceId = '',
    this.fcmToken = '',
  });

  final String email;
  final String password;
  final String deviceId;
  final String fcmToken;

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'deviceId': deviceId,
      'fcmToken': fcmToken,
    };
  }
}
