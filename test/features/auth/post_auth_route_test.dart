import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/app/router/app_routes.dart';
import 'package:tracking_app/features/auth/domain/entity/auth_session.dart';
import 'package:tracking_app/features/auth/domain/post_auth_route.dart';

void main() {
  test('driver role opens home', () {
    const session = AuthSession(role: 'DRIVER');
    expect(resolveAuthenticatedRoute(session), AppRoutes.home);
  });

  test('customer without an application opens home', () {
    const session = AuthSession(role: 'CUSTOMER');
    expect(resolveAuthenticatedRoute(session), AppRoutes.home);
  });

  test('unapproved application opens apply', () {
    const session = AuthSession(
      role: 'CUSTOMER',
      driverApplicationStatus: 'PendingReview',
    );
    expect(resolveAuthenticatedRoute(session), AppRoutes.apply);
  });

  test('approved application opens home', () {
    const session = AuthSession(
      role: 'CUSTOMER',
      driverApplicationStatus: 'Approved',
    );
    expect(resolveAuthenticatedRoute(session), AppRoutes.home);
  });

  test('explicit access flag overrides status', () {
    const allowed = AuthSession(
      role: 'CUSTOMER',
      driverApplicationStatus: 'PendingReview',
      canAccessDriverHome: true,
    );
    const blocked = AuthSession(role: 'CUSTOMER', canAccessDriverHome: false);

    expect(resolveAuthenticatedRoute(allowed), AppRoutes.home);
    expect(resolveAuthenticatedRoute(blocked), AppRoutes.apply);
  });
}
