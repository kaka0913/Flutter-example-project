import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../shared/auth/data/datasources/local/user_local_datasource.dart';
import '../../shared/auth/user_repository.dart';
import '../../shared/auth/entities/user.dart';

part 'auth_di.g.dart';

/// ========================================
/// Auth (Shared) - Dependency Injection
/// ========================================
/// 
/// 依存関係:
/// UserLocalDataSource → UserRepository

// DataSource層
@riverpod
UserLocalDataSource userLocalDataSource(Ref ref) {
  return UserLocalDataSource();
}

// Repository層
@riverpod
UserRepository userRepository(Ref ref) {
  final dataSource = ref.watch(userLocalDataSourceProvider);
  return UserRepository(dataSource);
}

// Presentation層プロバイダー
/// 現在のユーザーを監視するプロバイダー
@riverpod
class CurrentUser extends _$CurrentUser {
  @override
  User? build() {
    final repository = ref.watch(userRepositoryProvider);
    return repository.getCurrentUser();
  }

  /// ユーザーを切り替え
  Future<void> switchUser(String userId) async {
    final repository = ref.read(userRepositoryProvider);
    await repository.switchUser(userId);
    // 状態を更新
    ref.invalidateSelf();
  }
}

/// 利用可能なユーザー一覧のプロバイダー
@riverpod
List<User> availableUsers(Ref ref) {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getAvailableUsers();
}
