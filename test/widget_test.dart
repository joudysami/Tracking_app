import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/app/router/app_routes.dart';

void main() {
  test('signed-out sessions start at login', () {
    expect(AppRoutes.login, '/login');
    expect(AppRoutes.home, '/home');
  });
}
