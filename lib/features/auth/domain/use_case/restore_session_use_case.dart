import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/app/router/app_routes.dart';
import 'package:tracking_app/features/auth/domain/entity/auth_session.dart';
import 'package:tracking_app/features/auth/domain/post_auth_route.dart';
import 'package:tracking_app/features/auth/domain/repo/auth_repo.dart';
import 'package:tracking_app/features/auth/domain/session_invalid_exception.dart';

@injectable
class RestoreSessionUseCase {
  RestoreSessionUseCase(this._repository);

  final AuthRepo _repository;

  Future<String> call() async {
    final session = await _repository.currentSession();
    if (session == null) return AppRoutes.login;
    if (!await _repository.accessTokenExpired()) {
      return resolveAuthenticatedRoute(session);
    }
    return _refresh(session);
  }

  Future<String> _refresh(AuthSession session) async {
    try {
      final refreshed = await _repository.refreshSession();
      return resolveAuthenticatedRoute(refreshed);
    } on SessionInvalidException {
      return AppRoutes.login;
    } on DioException {
      return resolveAuthenticatedRoute(session);
    }
  }
}
