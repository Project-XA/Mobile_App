import 'package:mobile_app/core/current_user/data/local_data_soruce/user_local_data_source.dart';
import 'package:mobile_app/feature/home/domain/entities/user.dart';

class UserRoleResult {
  final User user;
  final String role;

  UserRoleResult({
    required this.user,
    required this.role,
  });

  bool get isAdmin => role.toLowerCase() == 'admin';
}

class GetUserRoleUseCase {
  final UserLocalDataSource localDataSource;

  GetUserRoleUseCase({required this.localDataSource});

  Future<UserRoleResult> call() async {
    final userModel = await localDataSource.getCurrentUser();
    final user = userModel.toEntity();

    if (!user.isRegistered || 
        user.organizations == null || 
        user.organizations!.isEmpty) {
      throw Exception('User is not registered in any organization');
    }

    final role = user.organizations!.first.role;

    return UserRoleResult(
      user: user,
      role: role,
    );
  }
}