import '../entities/user.dart';
import '../repositories/user_repository.dart';

/// 現在のユーザーを取得するUseCase
class GetCurrentUserUseCase {
  final UserRepository _repository;

  GetCurrentUserUseCase(this._repository);

  User? call() {
    return _repository.getCurrentUser();
  }
}
