import 'package:mobile_app/core/current_user/data/local_data_soruce/cache_exception.dart';
import 'package:mobile_app/feature/home/domain/entities/user.dart';
import 'package:mobile_app/feature/home/presentation/admin/profile/domain/repos/profile_repo.dart';

class GetCurrentUserUseCase {
  final ProfileRepo repo;
  
  GetCurrentUserUseCase(this.repo);
  
  Future<User> getCurrentUser() async {
    try {
      return await repo.getCurrentUser();
    } on CacheException catch (e) {
      throw CacheException('Failed in load data:${e.message}');
    } catch (e) {
      throw Exception('unexpected error: $e');
    }
  }
}