import 'package:mobile_app/core/current_user/domain/repo/current_user_repo.dart';
import 'package:mobile_app/feature/home/domain/entities/user.dart';

class UpdateUserUseCase {
  final CurrentUserRepository _repository;
  UpdateUserUseCase(this._repository);
  Future<void> call(User user) async {
    return await _repository.updateUser(user);
  }
}