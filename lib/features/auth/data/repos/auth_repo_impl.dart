import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/network/safe_call.dart';
import 'package:tracking_app/features/auth/domain/repos/auth_repo.dart';

import '../data_sources/auth_remote_data_source.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource remoteDataSource;
  final SafeCall safeCall;
  AuthRepoImpl({required this.remoteDataSource, required this.safeCall});
}
