import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/features/auth/data/models/login_request.dart';
import 'package:tracking_app/features/auth/data/models/login_response.dart';

void main() {
  test('login request matches the identity contract', () {
    final json = const LoginRequest(
      email: 'rider@example.com',
      password: 'secret',
    ).toJson();

    expect(json, {
      'email': 'rider@example.com',
      'password': 'secret',
      'deviceId': '',
      'fcmToken': '',
    });
  });

  test('parses the gateway login envelope', () {
    final response = LoginResponse.fromJson(_envelope());

    expect(response.status, isTrue);
    expect(response.data?.token, 'access-token');
    expect(response.data?.refreshToken, 'refresh-token');
    expect(response.data?.toSession().role, 'CUSTOMER');
    expect(response.data?.toSession().driverApplicationStatus, isNull);
  });

  test('reads driver status when the backend sends it', () {
    final json = _envelope();
    final user = Map<String, dynamic>.from(json['data']['user'] as Map);
    user['driverApplicationStatus'] = 'PendingReview';
    user['canAccessDriverHome'] = false;
    json['data']['user'] = user;

    final session = LoginResponse.fromJson(json).data!.toSession();

    expect(session.role, 'CUSTOMER');
    expect(session.driverApplicationStatus, 'PendingReview');
    expect(session.canAccessDriverHome, isFalse);
  });
}

Map<String, dynamic> _envelope() {
  return {
    'status': true,
    'code': 200,
    'message': 'Logged in',
    'data': {
      'user': {
        'id': 'user-1',
        'email': 'rider@example.com',
        'phone': '01000000000',
        'name': 'Rider',
        'roles': ['CUSTOMER'],
        'createdAt': '2026-10-06T11:35:29.3063426',
        'updatedAt': '2026-10-06T11:35:29.3063426',
        'gender': 'MALE',
        'notificationStatus': 'ON',
      },
      'token': 'access-token',
      'refreshToken': 'refresh-token',
    },
    'pagination': null,
    'errors': null,
  };
}
