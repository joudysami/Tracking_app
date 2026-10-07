import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/auth/data/api/auth_api_client.dart';
import 'package:tracking_app/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:tracking_app/features/auth/data/models/login_request.dart';
import 'package:tracking_app/features/auth/data/models/login_response.dart';

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._client);

  final AuthApiClient _client;

  @override
  Future<LoginResponse> login(LoginRequest request) => _client.login(request);
}
