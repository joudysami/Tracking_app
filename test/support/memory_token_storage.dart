import 'package:tracking_app/core/network/token_storage.dart';

class MemoryTokenStorage implements TokenStorage {
  String? access;
  String? refresh;
  DateTime? expiry;
  StoredSession? session;

  @override
  Future<String?> getAccessToken() async => access;

  @override
  Future<String?> getRefreshToken() async => refresh;

  @override
  Future<DateTime?> getAccessTokenExpiry() async => expiry;

  @override
  Future<StoredSession?> readSession() async => session;

  @override
  Future<void> saveAccessToken(String accessToken) async {
    access = accessToken;
  }

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    access = accessToken;
    refresh = refreshToken;
  }

  @override
  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required String role,
    String? driverApplicationStatus,
    bool? canAccessDriverHome,
  }) async {
    access = accessToken;
    refresh = refreshToken;
    session = StoredSession(
      role: role,
      driverApplicationStatus: driverApplicationStatus,
      canAccessDriverHome: canAccessDriverHome,
    );
  }

  @override
  Future<void> clearTokens() async {
    access = null;
    refresh = null;
    expiry = null;
    session = null;
  }
}
