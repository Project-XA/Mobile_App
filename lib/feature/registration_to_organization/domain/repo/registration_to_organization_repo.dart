import 'package:mobile_app/core/networking/api_result.dart';

abstract class RegistrationToOrganizationRepo {
  Future<ApiResult<String>> getUserRole(String organizationCode, String email, String password);
}