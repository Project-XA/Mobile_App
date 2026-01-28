import 'package:mobile_app/features/attendance/domain/repos/user_attendence_repo.dart';
import 'package:mobile_app/features/attendance/domain/entities/attendence_reponse.dart';

class CheckInUseCase {
  final UserAttendanceRepository _repository;

  CheckInUseCase(this._repository);

  Future<AttendanceResponse> call({ 
    required String sessionId,
    required String baseUrl,
    required String userId,
    required String userName,
    String? location,
  }) async {
    if (sessionId.isEmpty) {
      return AttendanceResponse(
        success: false,
        message: 'Session ID is required',
      );
    }
    if (userId.isEmpty || userName.isEmpty) {
      return AttendanceResponse(
        success: false,
        message: 'User information is required',
      );
    }

    return await _repository.checkIn(
      sessionId: sessionId,
      baseUrl: baseUrl,
      userId: userId,
      userName: userName,
      location: location,
    );
  }
}