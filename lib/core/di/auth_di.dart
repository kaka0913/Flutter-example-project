import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../shared/auth/data/datasources/local/user_local_datasource.dart';
import '../../shared/auth/data/repositories/user_repository_impl.dart';
import '../../shared/auth/domain/repositories/user_repository.dart';
import '../../shared/auth/domain/usecases/get_available_users_usecase.dart';
import '../../shared/auth/domain/usecases/get_current_user_usecase.dart';
import '../../shared/auth/domain/usecases/switch_user_usecase.dart';
import '../../shared/auth/domain/entities/user.dart';

part 'auth_di.g.dart';

/// ========================================
/// Auth (Shared) - Dependency Injection
/// ========================================
/// 
/// 依存関係:
/// UserLocalDataSource → UserRepository → UseCases

// DataSource層
@riverpod
UserLocalDataSource userLocalDataSource(Ref ref) {
  return UserLocalDataSource();
}

// Repository層
@riverpod
UserRepository userRepository(Ref ref) {
  final dataSource = ref.watch(userLocalDataSourceProvider);
  return UserRepositoryImpl(dataSource);
}

// UseCase層
@riverpod
GetCurrentUserUseCase getCurrentUserUseCase(Ref ref) {
  final repository = ref.watch(userRepositoryProvider);
  return GetCurrentUserUseCase(repository);
}

@riverpod
GetAvailableUsersUseCase getAvailableUsersUseCase(Ref ref) {
  final repository = ref.watch(userRepositoryProvider);
  return GetAvailableUsersUseCase(repository);
}

@riverpod
SwitchUserUseCase switchUserUseCase(Ref ref) {
  final repository = ref.watch(userRepositoryProvider);
  return SwitchUserUseCase(repository);
}

// Presentation層プロバイダー
/// 現在のユーザーを監視するプロバイダー
@riverpod
class CurrentUser extends _$CurrentUser {
  @override
  User? build() {
    final useCase = ref.watch(getCurrentUserUseCaseProvider);
    return useCase();
  }

  /// ユーザーを切り替え
  Future<void> switchUser(String userId) async {
    final useCase = ref.read(switchUserUseCaseProvider);
    await useCase(userId);
    // 状態を更新
    ref.invalidateSelf();
  }
}

/// 利用可能なユーザー一覧のプロバイダー
@riverpod
List<User> availableUsers(Ref ref) {
  final useCase = ref.watch(getAvailableUsersUseCaseProvider);
  return useCase();
}
