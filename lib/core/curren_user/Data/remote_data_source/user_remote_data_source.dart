import 'package:mobile_app/core/networking/api_const.dart';
import 'package:mobile_app/core/networking/api_error_handler.dart';
import 'package:mobile_app/core/networking/network_service.dart';
import 'package:mobile_app/features/attendance/data/models/get-user-statistics/get_user_statisticts_response_model.dart';
import 'package:mobile_app/features/auth/data/models/register_request_body.dart';
import 'package:mobile_app/features/auth/data/models/register_response_body.dart';
import 'package:mobile_app/features/session_mangement/data/models/remote_models/create_session/create_session_request_model.dart';
import 'package:mobile_app/features/session_mangement/data/models/remote_models/save_attendance/save_attendance_request.dart';
import 'package:mobile_app/features/session_mangement/data/models/remote_models/save_attendance/save_attendance_response.dart';

abstract class UserRemoteDataSource {
  Future<RegisterResponseBody> registerUser(RegisterRequestBody request);

  Future<int> createSession(CreateSessionRequestModel createSessionRequest);
  Future<GetUserStatistictsResponseModel> getUserStatistics();
  Future<SaveAttendanceResponse> saveAttendance(SaveAttendanceRequest request);
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

      final data = response.data['data'] as Map<String, dynamic>;
      return RegisterResponseBody.fromJson(data);
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  @override
  Future<int> createSession(
    CreateSessionRequestModel createSessionRequest,
  ) async {
    try {
      final response = await networkService.post(
        ApiConst.createSession,
        createSessionRequest.toJson(),
      );

      final sessionId = response.data['data']['sessionId'] as int;
      return sessionId;
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  @override
  Future<SaveAttendanceResponse> saveAttendance(
    SaveAttendanceRequest request,
  ) async {
    try {
      final response = await networkService.post(
        ApiConst.saveAttendance,
        request.toJson(),
      );

      final data = response.data as Map<String, dynamic>;
      return SaveAttendanceResponse.fromJson(data);
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  @override
  Future<GetUserStatistictsResponseModel> getUserStatistics() async {
    try {
      final response = await networkService.get(ApiConst.userStatistics);

      final data = response.data['data'] as Map<String, dynamic>;
      return GetUserStatistictsResponseModel.fromJson(data);
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}
