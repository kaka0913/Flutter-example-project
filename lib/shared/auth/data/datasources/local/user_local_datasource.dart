import '../../../domain/entities/user.dart';

/// ユーザーローカルデータソース
class UserLocalDataSource {
  // モックユーザーデータ
  static final List<User> _mockUsers = [
    const User(
      id: 'user_a',
      name: 'ユーザーA',
      email: 'user.a@example.com',
      avatarUrl: 'https://i.pravatar.cc/150?img=1',
    ),
    const User(
      id: 'user_b',
      name: 'ユーザーB',
      email: 'user.b@example.com',
      avatarUrl: 'https://i.pravatar.cc/150?img=2',
    ),
    const User(
      id: 'user_c',
      name: 'ユーザーC',
      email: 'user.c@example.com',
      avatarUrl: 'https://i.pravatar.cc/150?img=3',
    ),
    const User(
      id: 'user_d',
      name: 'ユーザーD',
      email: 'user.d@example.com',
      avatarUrl: 'https://i.pravatar.cc/150?img=4',
    ),
  ];

  // 現在ログイン中のユーザー（デフォルトはユーザーA）
  User? _currentUser = _mockUsers[0];

  /// 現在のユーザーを取得
  User? getCurrentUser() => _currentUser;

  /// 利用可能なユーザー一覧を取得
  List<User> getAvailableUsers() => _mockUsers;

  /// ユーザーを切り替え
  Future<void> switchUser(String userId) async {
    // ログイン処理をシミュレート
    await Future.delayed(const Duration(milliseconds: 300));
    
    _currentUser = _mockUsers.firstWhere(
      (user) => user.id == userId,
      orElse: () => _mockUsers[0],
    );
  }

  /// ログアウト
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
  }

  /// ログイン状態を確認
  bool isLoggedIn() => _currentUser != null;
}
