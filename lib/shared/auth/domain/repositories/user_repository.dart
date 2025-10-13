import '../entities/user.dart';

/// ユーザーリポジトリのインターフェース（Domain層）
abstract class UserRepository {
  /// 現在のユーザーを取得
  User? getCurrentUser();
  
  /// 利用可能なユーザー一覧を取得
  List<User> getAvailableUsers();
  
  /// ユーザーを切り替え
  Future<void> switchUser(String userId);
  
  /// ログアウト
  Future<void> logout();
  
  /// ログイン状態を確認
  bool isLoggedIn();
}
