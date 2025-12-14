import 'package:mobile_app/core/networking/api_const.dart';
import 'package:mobile_app/core/networking/network_service.dart';
import 'package:mobile_app/feature/register/data/models/register_request_body.dart';

abstract class UserRemoteDataSource {
  Future<String> getRole(RegisterRequestBody request); 
}

class UserRemoteDataSourceImp implements UserRemoteDataSource {
  final NetworkService networkService;

  UserRemoteDataSourceImp(this.networkService);

  @override
  Future<String> getRole(RegisterRequestBody request) async {
    try {
      final response = await networkService.post(
        ApiConst.register,
        request.toJson(),
      );

      if (response.statusCode == 200) {
        if (response.data is String) {
          return response.data.toString().trim();
        } else if (response.data is Map<String, dynamic>) {
          return response.data['role'] ?? 'User';
        } else {
          throw Exception('Invalid response format');
        }
      } else if (response.statusCode == 400) {
        throw Exception('Invalid credentials or user not a member');
      } else if (response.statusCode == 404) {
        throw Exception('Organization not found');
      } else {
        throw Exception('Registration failed: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}