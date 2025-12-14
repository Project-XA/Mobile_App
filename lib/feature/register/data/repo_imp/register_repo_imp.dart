import 'package:mobile_app/core/Data/local_data_soruce/user_local_data_source.dart';
import 'package:mobile_app/core/Data/remote_data_source/user_remote_data_source.dart';
import 'package:mobile_app/core/networking/api_result.dart';
import 'package:mobile_app/feature/home/data/models/user_model.dart';
import 'package:mobile_app/feature/home/data/models/user_org_model.dart';
import 'package:mobile_app/feature/register/data/models/register_request_body.dart';
import 'package:mobile_app/feature/register/domain/repos/register_repo.dart';

class RegisterRepoImp implements RegisterRepo {
  final UserRemoteDataSource userRemoteDataSource;
  final UserLocalDataSource localDataSource;

  RegisterRepoImp({
    required this.userRemoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<ApiResult<String>> getRole({
    required String orgId,
    required String email,
    required String password,
    required UserModel localUserData,
  }) async {
    try {
      final request = RegisterRequestBody(
        organizationCode: orgId,
        email: email,
        password: password,
      );

      final role = await userRemoteDataSource.getRole(request);

      localUserData.organizations = [
        UserOrgModel(
          orgId: orgId,
          role: role,
        ),
      ];
      localUserData.email = email;

      await localDataSource.saveUserLogin(localUserData);

      return ApiResult.success(role);
    } catch (e) {
      return ApiResult.error(e);
    }
  }
}