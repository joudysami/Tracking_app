import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

import 'package:flutter/foundation.dart';
class ApiEndpoints {
  ApiEndpoints._();
static String _resolvedBaseUrl = '';

  static String get resolvedBaseUrl => _resolvedBaseUrl;

  static Future<void> loadBaseUrl() async {
    await _ensureDotEnv();
    _resolvedBaseUrl = normalizeBaseUrl(dotenv.env['BASE_URL'] ?? '');
  }

  static String normalizeBaseUrl(String raw) {
    var url = raw.trim();
    if (url.isEmpty) return url;
    url = rewriteHostForLocalClient(
      url,
      androidEmulator: _isAndroidEmulator(),
      iosSimulator: _isIosSimulator(),
    );
    // Ensure trailing slash so Dio can concatenate relative paths correctly
    if (!url.endsWith('/')) url = '$url/';
    return url;
  }

  static String rewriteHostForLocalClient(
    String url, {
    required bool androidEmulator,
    required bool iosSimulator,
  }) {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) return url;
    if (_isLoopbackHost(uri.host)) {
      if (androidEmulator) return uri.replace(host: '10.0.2.2').toString();
      if (iosSimulator) return uri.replace(host: '127.0.0.1').toString();
    }
    return url;
  }

  static String mediaUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    final absolute = _absoluteMediaUrl(path);
    return rewriteHostForLocalClient(
      absolute,
      androidEmulator: _isAndroidEmulator(),
      iosSimulator: _isIosSimulator(),
    );
  }

  static String _absoluteMediaUrl(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    if (_resolvedBaseUrl.isEmpty) return path;
    final origin = Uri.parse(_resolvedBaseUrl).origin;
    return path.startsWith('/') ? '$origin$path' : '$origin/$path';
  }


  static const String forgetPassword = '/api/identity/auth/forget-password';
  static const String verifyOtp = '/api/identity/auth/otp-verification';
  static const String resetPassword = '/api/identity/auth/reset-password';
  static const String login ="/api/identity/auth/login";
  //// Apply (Driver) ////
  static const String applyDriver = '/api/identity/drivers/apply';
  static const String vehicleTypes = '/api/identity/vehicle-types';
  /// Location Tracking ////
  static const String reportDriverLocation = '/api/orders/drivers/me/location';
}
Future<void> _ensureDotEnv() async {
  if (dotenv.isInitialized) return;
  await dotenv.load(fileName: '.env', isOptional: true);
}

bool _isLoopbackHost(String host) {
  return host == 'localhost' || host == '127.0.0.1' || host == '::1';
}

bool _isIosSimulator() {
  if (kIsWeb || !Platform.isIOS) return false;
  final env = Platform.environment;
  return env.containsKey('SIMULATOR_DEVICE_NAME') ||
      env.containsKey('SIMULATOR_UDID') ||
      env.containsKey('SIMULATOR_HOST_HOME');
}

bool _isAndroidEmulator() {
  if (kIsWeb || !Platform.isAndroid) return false;
  const markers = [
    '/dev/qemu_pipe',
    '/dev/goldfish_pipe',
    '/dev/goldfish_sync',
  ];
  for (final path in markers) {
    if (File(path).existsSync()) return true;
  }
  return false;
}