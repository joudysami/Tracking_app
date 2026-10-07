import 'package:tracking_app/core/base/base_response.dart';
import 'package:tracking_app/features/auth/data/models/login_request.dart';
import 'package:tracking_app/features/auth/domain/entity/auth_session.dart';

abstract interface class AuthRepo {
  Future<BaseResponse<AuthSession>> signIn(LoginRequest request);

  Future<AuthSession?> currentSession();

  Future<bool> accessTokenExpired();

  Future<AuthSession> refreshSession();
}
