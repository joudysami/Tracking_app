import 'dart:convert';

Map<String, dynamic>? jwtPayload(String token) {
  try {
    final parts = token.split('.');
    if (parts.length < 2) return null;
    final normalized = base64Url.normalize(parts[1]);
    final json = jsonDecode(utf8.decode(base64Url.decode(normalized)));
    if (json is Map<String, dynamic>) return json;
    if (json is Map) return Map<String, dynamic>.from(json);
    return null;
  } catch (_) {
    return null;
  }
}

DateTime? jwtExpiry(String? token) {
  if (token == null || token.isEmpty) return null;
  final exp = jwtPayload(token)?['exp'];
  if (exp is! num) return null;
  return DateTime.fromMillisecondsSinceEpoch(exp.toInt() * 1000, isUtc: true);
}

String? jwtRole(String? token) {
  if (token == null || token.isEmpty) return null;
  final claims = jwtPayload(token);
  return _role(claims?[_roleClaim]) ?? _role(claims?['role']);
}

const _roleClaim =
    'http://schemas.microsoft.com/ws/2008/06/identity/claims/role';

String? _role(dynamic value) {
  if (value is String && value.trim().isNotEmpty) return value;
  if (value is! List || value.isEmpty || value.first is! String) return null;
  final first = value.first as String;
  if (first.trim().isEmpty) return null;
  return first;
}
