import 'package:mobile_app/core/networking/api_result.dart';
import 'package:mobile_app/core/curren_user/Data/models/user_model.dart';
import 'package:mobile_app/features/auth/domain/repos/register_repo.dart';

class RegisterUseCase {
  final RegisterRepo repo;

  RegisterUseCase(this.repo);

  Future<ApiResult<UserModel>> call({
    required String orgId,
    required String email,
    required String password,
    required UserModel localUserData,
  }) {
 

    final result = repo.registerUser(
      orgId: orgId,
      email: email,
      password: password,
      localUserData: localUserData,
    );


    return result;
  }
}
