import 'package:work/shared/auth/entities/user.dart';
import 'package:work/shared/auth/data/datasources/local/user_local_datasource.dart';

/// ユーザーリポジトリ
class UserRepository {
  final UserLocalDataSource _localDataSource;

  UserRepository(this._localDataSource);

  /// 現在のユーザーを取得
  User? getCurrentUser() {
    return _localDataSource.getCurrentUser();
  }

  /// 利用可能なユーザー一覧を取得
  List<User> getAvailableUsers() {
    return _localDataSource.getAvailableUsers();
  }

  /// ユーザーを切り替え
  Future<void> switchUser(String userId) async {
    await _localDataSource.switchUser(userId);
  }

  /// ログアウト
  Future<void> logout() async {
    await _localDataSource.logout();
  }

  /// ログイン状態を確認
  bool isLoggedIn() {
    return _localDataSource.isLoggedIn();
  }
}

