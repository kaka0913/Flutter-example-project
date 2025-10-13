import '../entities/user.dart';
import '../repositories/user_repository.dart';

/// 利用可能なユーザー一覧を取得するUseCase
class GetAvailableUsersUseCase {
  final UserRepository _repository;

  GetAvailableUsersUseCase(this._repository);

  List<User> call() {
    return _repository.getAvailableUsers();
  }
}
