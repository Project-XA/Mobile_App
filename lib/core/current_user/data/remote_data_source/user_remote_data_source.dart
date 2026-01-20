import 'package:mobile_app/core/networking/api_const.dart';
import 'package:mobile_app/core/networking/network_service.dart';
import 'package:mobile_app/feature/register/data/models/register_request_body.dart';
import 'package:mobile_app/feature/register/data/models/register_response_body.dart';

abstract class UserRemoteDataSource {
  Future<RegisterResponseBody> registerUser(RegisterRequestBody request);
}

class UserRemoteDataSourceImp implements UserRemoteDataSource {
  final NetworkService networkService;

  UserRemoteDataSourceImp(this.networkService);

  @override
  Future<RegisterResponseBody> registerUser(RegisterRequestBody request) async {

    try {
      
      final response = await networkService.post(
        ApiConst.register,
        request.toJson(),
      );

    

      if (response.statusCode == 200) {
        
        final data = response.data['data'] as Map<String, dynamic>;

        final apiResponse = RegisterResponseBody.fromJson(data);
        
        return apiResponse;
      }
      
      throw Exception('Registration failed: ${response.statusCode}');
      
    } catch (e) {
     
      rethrow;
    }
  }
}