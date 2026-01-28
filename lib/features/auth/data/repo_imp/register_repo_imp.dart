import 'package:mobile_app/core/curren_user/Data/local_data_soruce/user_local_data_source.dart';
import 'package:mobile_app/core/curren_user/Data/models/user_org_model.dart';
import 'package:mobile_app/core/curren_user/Data/remote_data_source/user_remote_data_source.dart';
import 'package:mobile_app/core/networking/api_result.dart';
import 'package:mobile_app/core/networking/dio_factory.dart';
import 'package:mobile_app/core/services/auth/onboarding_service.dart';
import 'package:mobile_app/core/curren_user/Data/models/user_model.dart';
import 'package:mobile_app/features/auth/data/models/register_request_body.dart';
import 'package:mobile_app/features/auth/domain/repos/register_repo.dart';

class RegisterRepoImp implements RegisterRepo {
  final UserRemoteDataSource userRemoteDataSource;
  final UserLocalDataSource localDataSource;
  final OnboardingService onboardingService;

  RegisterRepoImp({
    required this.userRemoteDataSource,
    required this.localDataSource,
    required this.onboardingService,
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
        id: apiResponse.userResponse.id,
        nationalId: localUserData.nationalId,
        firstNameAr: localUserData.firstNameAr,
        lastNameAr: localUserData.lastNameAr,
        address: localUserData.address,
        birthDate: localUserData.birthDate,
        profileImage: localUserData.profileImage,

        email: apiResponse.userResponse.email,
        firstNameEn: firstNameEn,
        lastNameEn: lastNameEn,
        loginToken: apiResponse.loginToken,
        idCardImage: localUserData.idCardImage,
        username: apiResponse.userResponse.username,

        organizations: [
          UserOrgModel(
            organizationId: apiResponse.userResponse.organizationId!,
            role: apiResponse.userResponse.role,
            organizationName: apiResponse.userResponse.organizationName,
          ),
        ],
      );

      await localDataSource.saveUserLogin(completeUserData);
      await DioFactory.setToken(apiResponse.loginToken);
      await onboardingService.markOnboardingComplete(
        apiResponse.userResponse.role,
      );

      await onboardingService.markLoggedIn(apiResponse.userResponse.role);

      return ApiResult.success(completeUserData);
    } catch (e) {
      return ApiResult.error(e);
    }
  }
}
