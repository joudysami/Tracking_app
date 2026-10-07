import 'dart:convert';

String testJwt({required String role, required int exp}) {
  final header = _part({'alg': 'none', 'typ': 'JWT'});
  final payload = _part({
    'exp': exp,
    'http://schemas.microsoft.com/ws/2008/06/identity/claims/role': role,
  });
  return '$header.$payload.sig';
}

String _part(Map<String, Object> json) {
  return base64Url.encode(utf8.encode(jsonEncode(json))).replaceAll('=', '');
}
