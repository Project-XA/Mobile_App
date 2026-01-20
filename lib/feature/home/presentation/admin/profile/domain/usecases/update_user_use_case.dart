import 'package:mobile_app/core/current_user/data/local_data_soruce/cache_exception.dart';
import 'package:mobile_app/feature/home/domain/entities/user.dart';
import 'package:mobile_app/feature/home/presentation/admin/profile/domain/repos/profile_repo.dart';

class UpdateUserUseCase {
  final ProfileRepo repo;

  UpdateUserUseCase(this.repo);

  Future<void> updateUserUseCase(User user) async {
    try {
      await repo.updateUser(user);
    } on CacheException catch (e) {
      throw CacheException('field in update data${e.message}');
    } catch (e) {
      throw Exception(' error occur $e');
    }
  }
}
