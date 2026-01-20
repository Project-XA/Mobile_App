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
  Future<ApiResult<UserModel>> registerUser({
    required String orgId,
    required String email,
    required String password,
    required UserModel localUserData,
  }) async {
    try {
      final orgIdInt = int.tryParse(orgId);
      if (orgIdInt == null) {
        throw Exception('Invalid organization ID: $orgId');
      }

      final request = RegisterRequestBody(
        organizationCode: orgIdInt,
        email: email,
        password: password,
      );

      final apiResponse = await userRemoteDataSource.registerUser(request);

      final nameParts = apiResponse.userResponse.fullName.split(' ');
      final firstNameEn = nameParts.isNotEmpty ? nameParts.first : '';
      final lastNameEn = nameParts.length > 1
          ? nameParts.sublist(1).join(' ')
          : '';

      final completeUserData = UserModel(
        nationalId: localUserData.nationalId,
        firstNameAr: localUserData.firstNameAr,
        lastNameAr: localUserData.lastNameAr,
        address: localUserData.address,
        birthDate: localUserData.birthDate,
        profileImage: localUserData.profileImage,

        email: apiResponse.userResponse.email,
        firstNameEn: firstNameEn,
        lastNameEn: lastNameEn,

        organizations: [
          UserOrgModel(orgId: orgId, role: apiResponse.userResponse.role),
        ],
      );

      await localDataSource.saveUserLogin(completeUserData);

      return ApiResult.success(completeUserData);
    } catch (e) {
      return ApiResult.error(e);
    }
  }
}
