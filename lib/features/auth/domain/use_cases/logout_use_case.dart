import 'package:injectable/injectable.dart';
import 'package:tracking_app/features/auth/domain/repos/auth_repo.dart';

@injectable
class LogoutUseCase {
  LogoutUseCase(this._repo);

  final AuthRepo _repo;

  Future<void> call() {
    return _repo.signOut();
  }
}