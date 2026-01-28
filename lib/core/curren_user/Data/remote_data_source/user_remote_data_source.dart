import 'package:mobile_app/core/networking/api_const.dart';
import 'package:mobile_app/core/networking/network_service.dart';
import 'package:mobile_app/features/auth/data/models/register_request_body.dart';
import 'package:mobile_app/features/auth/data/models/register_response_body.dart';
import 'package:mobile_app/features/session_mangement/data/models/remote_models/create_session_request_model.dart';

abstract class UserRemoteDataSource {
  Future<RegisterResponseBody> registerUser(RegisterRequestBody request);

  Future<void> createSession(CreateSessionRequestModel createSessionRequest);
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
      } else if (response.statusCode == 400) {
        final message = response.data['message'] ?? 'Invalid credentials';
        throw Exception(message);
      } else if (response.statusCode == 404) {
        throw Exception('Organization not found');
      } else {
        throw Exception('Registration failed: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> createSession(
    CreateSessionRequestModel createSessionRequest,
  ) async {
    final response = await networkService.post(
      ApiConst.createSession,
      createSessionRequest.toJson(),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create session: ${response.statusCode}');
    }
  }
}
