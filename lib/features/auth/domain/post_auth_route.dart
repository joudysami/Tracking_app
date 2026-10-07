import 'package:tracking_app/app/router/app_routes.dart';
import 'package:tracking_app/features/auth/domain/entity/auth_session.dart';

String resolveAuthenticatedRoute(AuthSession session) {
  if (session.canAccessDriverHome == true || _isDriver(session.role)) {
    return AppRoutes.home;
  }
  if (session.canAccessDriverHome == false) return AppRoutes.apply;
  if (_blocksHome(session.driverApplicationStatus)) return AppRoutes.apply;
  return AppRoutes.home;
}

bool _isDriver(String role) => role.trim().toLowerCase() == 'driver';

bool _blocksHome(String? status) {
  final value = (status ?? '').trim().toLowerCase();
  return value.isNotEmpty && value != 'approved';
}
