import 'package:mobile_app/core/current_user/data/local_data_soruce/user_local_data_source.dart';
import 'package:mobile_app/feature/home/domain/entities/user.dart';
import 'package:mobile_app/feature/home/presentation/user/domain/repos/user_repo.dart';

class UserRepoImpl implements UserRepo {
  final UserLocalDataSource localDataSource;

  UserRepoImpl({required this.localDataSource});

  @override
  Future<User> getCurrentUser() async {
    final usermModel = await localDataSource.getCurrentUser();
    return usermModel.toEntity();
  }
}
