import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/local/user_local_datasource.dart';

/// ユーザーリポジトリの実装（Data層）
class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource _localDataSource;

  UserRepositoryImpl(this._localDataSource);

  @override
  User? getCurrentUser() {
    return _localDataSource.getCurrentUser();
  }

  @override
  List<User> getAvailableUsers() {
    return _localDataSource.getAvailableUsers();
  }

  @override
  Future<void> switchUser(String userId) async {
    await _localDataSource.switchUser(userId);
  }

  @override
  Future<void> logout() async {
    await _localDataSource.logout();
  }

  @override
  bool isLoggedIn() {
    return _localDataSource.isLoggedIn();
  }
}
