import 'package:mobile_app/core/networking/api_result.dart';
import 'package:mobile_app/core/curren_user/Data/models/user_model.dart';

abstract class RegisterRepo {
  Future<ApiResult<UserModel>> registerUser({ 
    required String orgId,
    required String email,
    required String password,
    required UserModel localUserData,
  });
}