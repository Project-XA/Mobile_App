import 'package:mobile_app/core/networking/api_result.dart';
import 'package:mobile_app/feature/home/data/models/user_model.dart';

abstract class RegisterRepo {
  Future<ApiResult<String>> getRole({ 
    required String orgId,
    required String email,
    required String password,
    required UserModel localUserData,
  });
}