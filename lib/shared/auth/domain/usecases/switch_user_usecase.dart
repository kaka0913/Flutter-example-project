import '../repositories/user_repository.dart';

/// ユーザーを切り替えるUseCase
class SwitchUserUseCase {
  final UserRepository _repository;

  SwitchUserUseCase(this._repository);

  Future<void> call(String userId) async {
    await _repository.switchUser(userId);
  }
}
