import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:work/shared/auth/data/datasources/local/user_local_datasource.dart';
import 'package:work/shared/auth/data/repositories/user_repository_impl.dart';
import 'package:work/shared/auth/domain/entities/user.dart';
import 'package:work/shared/auth/domain/repositories/user_repository.dart';
import 'package:work/shared/auth/domain/usecases/get_available_users_usecase.dart';
import 'package:work/shared/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:work/shared/auth/domain/usecases/switch_user_usecase.dart';

part 'auth_providers.g.dart';

/// UserLocalDataSourceのプロバイダー
@riverpod
UserLocalDataSource userLocalDataSource(Ref ref) {
  return UserLocalDataSource();
}

/// UserRepositoryのプロバイダー
@riverpod
UserRepository userRepository(Ref ref) {
  final localDataSource = ref.watch(userLocalDataSourceProvider);
  return UserRepositoryImpl(localDataSource);
}

/// GetCurrentUserUseCaseのプロバイダー
@riverpod
GetCurrentUserUseCase getCurrentUserUseCase(Ref ref) {
  final repository = ref.watch(userRepositoryProvider);
  return GetCurrentUserUseCase(repository);
}

/// GetAvailableUsersUseCaseのプロバイダー
@riverpod
GetAvailableUsersUseCase getAvailableUsersUseCase(Ref ref) {
  final repository = ref.watch(userRepositoryProvider);
  return GetAvailableUsersUseCase(repository);
}

/// SwitchUserUseCaseのプロバイダー
@riverpod
SwitchUserUseCase switchUserUseCase(Ref ref) {
  final repository = ref.watch(userRepositoryProvider);
  return SwitchUserUseCase(repository);
}

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
