// data/repositories/admin_repository_impl.dart
import 'package:mobile_app/core/current_user/data/local_data_soruce/user_local_data_source.dart';
import 'package:mobile_app/feature/home/domain/entities/user.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/repos/admin_repo.dart';

class AdminRepositoryImpl implements AdminRepository {
  final UserLocalDataSource localDataSource;

  AdminRepositoryImpl({required this.localDataSource});

  @override
  Future<User> getCurrentUser() async {
    final userModel = await localDataSource.getCurrentUser();
    return userModel.toEntity();
  }
}
