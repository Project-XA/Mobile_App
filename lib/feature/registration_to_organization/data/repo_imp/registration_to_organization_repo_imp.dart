import 'package:dio/dio.dart';
import 'package:mobile_app/core/networking/api_result.dart';
import 'package:mobile_app/core/networking/network_service.dart';
import 'package:mobile_app/feature/registration_to_organization/domain/repo/registration_to_organization_repo.dart';

class RegistrationToOrganizationRepoImp implements RegistrationToOrganizationRepo {
  final NetworkService _networkService;

  RegistrationToOrganizationRepoImp(this._networkService);

  @override
  Future<ApiResult<String>> getUserRole(
    String organizationCode,
    String email,
    String password,
  ) async {
    try {
      // Build query parameters
      final queryParams = {
        'OrgainzatinCode': organizationCode, // Note: API uses this spelling
        'Email': email,
        'Password': password,
      };

      // Build URL with query parameters
      final uri = Uri.parse('/api/User/get-user-role');
      final url = uri.replace(queryParameters: queryParams).toString();

      // Make API call
      final response = await _networkService.get(url);

      // Handle response based on status code
      if (response.statusCode == 200) {
        // Success - extract role from response
        // Handle both string and JSON object responses
        String role;
        if (response.data is String) {
          role = response.data as String;
        } else if (response.data is Map) {
          // If response is a JSON object, try to extract role field
          role = (response.data as Map)['role']?.toString() ??
              (response.data as Map)['userRole']?.toString() ??
              response.data.toString();
        } else {
          role = response.data?.toString() ?? '';
        }
        return ApiResult.success(role);
      } else if (response.statusCode == 400) {
        // Bad Request - Invalid credentials or user not a member
        return ApiResult.error(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
            error: 'Invalid credentials or user not a member',
          ),
        );
      } else if (response.statusCode == 404) {
        // Not Found - Organization not found
        return ApiResult.error(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
            error: 'Organization not found',
          ),
        );
      } else {
        // Other error
        return ApiResult.error(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
            error: 'An unexpected error occurred',
          ),
        );
      }
    } catch (e) {
      // Handle network errors and exceptions
      if (e is DioException) {
        return ApiResult.error(e);
      }
      return ApiResult.error(Exception(e.toString()));
    }
  }
}

