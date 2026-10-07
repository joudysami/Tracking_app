import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/network/jwt_payload.dart';

class StoredSession {
  const StoredSession({
    required this.role,
    this.driverApplicationStatus,
    this.canAccessDriverHome,
  });

  final String role;
  final String? driverApplicationStatus;
  final bool? canAccessDriverHome;
}

/// Persists authentication tokens using the project's secure storage.
abstract interface class TokenStorage {
  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<DateTime?> getAccessTokenExpiry();

  Future<StoredSession?> readSession();

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  });

  Future<void> saveAccessToken(String accessToken);

  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required String role,
    String? driverApplicationStatus,
    bool? canAccessDriverHome,
  });

  Future<void> clearTokens();
}

@LazySingleton(as: TokenStorage)
class SecureTokenStorage implements TokenStorage {
  SecureTokenStorage(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  static const accessTokenKey = 'USER_TOKEN';
  static const refreshTokenKey = 'REFRESH_TOKEN';
  static const accessTokenExpiryKey = 'ACCESS_TOKEN_EXPIRY';
  static const roleKey = 'USER_ROLE';
  static const driverStatusKey = 'DRIVER_APPLICATION_STATUS';
  static const canAccessDriverHomeKey = 'CAN_ACCESS_DRIVER_HOME';

  static const _sessionKeys = <String>[
    accessTokenKey,
    refreshTokenKey,
    accessTokenExpiryKey,
    roleKey,
    driverStatusKey,
    canAccessDriverHomeKey,
  ];

  @override
  Future<String?> getAccessToken() => _secureStorage.read(key: accessTokenKey);

  @override
  Future<String?> getRefreshToken() {
    return _secureStorage.read(key: refreshTokenKey);
  }

  @override
  Future<DateTime?> getAccessTokenExpiry() async {
    final raw = await _secureStorage.read(key: accessTokenExpiryKey);
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }

  @override
  Future<StoredSession?> readSession() async {
    final role = await _secureStorage.read(key: roleKey);
    if (role == null || role.isEmpty) return null;
    final status = await _secureStorage.read(key: driverStatusKey);
    final access = await _secureStorage.read(key: canAccessDriverHomeKey);
    return StoredSession(
      role: role,
      driverApplicationStatus: _emptyToNull(status),
      canAccessDriverHome: _parseBool(access),
    );
  }

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _secureStorage.write(key: accessTokenKey, value: accessToken),
      _secureStorage.write(key: refreshTokenKey, value: refreshToken),
      _writeExpiry(accessToken),
    ]);
  }

  @override
  Future<void> saveAccessToken(String accessToken) async {
    await Future.wait([
      _secureStorage.write(key: accessTokenKey, value: accessToken),
      _writeExpiry(accessToken),
    ]);
  }

  @override
  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required String role,
    String? driverApplicationStatus,
    bool? canAccessDriverHome,
  }) async {
    await saveTokens(accessToken: accessToken, refreshToken: refreshToken);
    await _writeProfile(
      role: role,
      driverApplicationStatus: driverApplicationStatus,
      canAccessDriverHome: canAccessDriverHome,
    );
  }

  Future<void> _writeProfile({
    required String role,
    String? driverApplicationStatus,
    bool? canAccessDriverHome,
  }) {
    return Future.wait([
      _secureStorage.write(key: roleKey, value: role),
      _secureStorage.write(
        key: driverStatusKey,
        value: driverApplicationStatus ?? '',
      ),
      _secureStorage.write(
        key: canAccessDriverHomeKey,
        value: _boolText(canAccessDriverHome),
      ),
    ]);
  }

  Future<void> _writeExpiry(String accessToken) async {
    final expiry = jwtExpiry(accessToken);
    if (expiry == null) {
      await _secureStorage.delete(key: accessTokenExpiryKey);
      return;
    }
    await _secureStorage.write(
      key: accessTokenExpiryKey,
      value: expiry.toIso8601String(),
    );
  }

  @override
  Future<void> clearTokens() {
    return Future.wait(
      _sessionKeys.map((key) => _secureStorage.delete(key: key)),
    );
  }
}

String? _emptyToNull(String? value) {
  if (value == null || value.isEmpty) return null;
  return value;
}

bool? _parseBool(String? value) {
  if (value == 'true') return true;
  if (value == 'false') return false;
  return null;
}

String _boolText(bool? value) {
  if (value == null) return '';
  return value ? 'true' : 'false';
}
