import 'package:mobile_app/core/curren_user/domain/repo/current_user_repo.dart';
import 'package:mobile_app/feature/home/domain/entities/user.dart';

class GetCurrentUserUseCase {
  final CurrentUserRepository _repository;
  GetCurrentUserUseCase(this._repository);
  Future<User> call() async => await _repository.getCurrentUser();
}