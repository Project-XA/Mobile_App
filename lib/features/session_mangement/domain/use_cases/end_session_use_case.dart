import 'package:mobile_app/core/networking/api_error_model.dart';
import 'package:mobile_app/features/session_mangement/data/models/remote_models/save_attendance/save_attendance_request.dart';
import 'package:mobile_app/features/session_mangement/domain/entities/session.dart';
import 'package:mobile_app/features/session_mangement/domain/repos/session_repository.dart';

class EndSessionUseCase {
  final SessionRepository _repository;

  EndSessionUseCase(this._repository);

  Future<void> call(int sessionId, Session session) async {
    if (session.attendanceList.isNotEmpty) {
      final attendanceLogs = session.attendanceList
          .map((record) => record.toAttendanceLogItem())
          .toList();
      
      final request = SaveAttendanceRequest(
        sessionId: sessionId,
        attendanceLogs: attendanceLogs,
      );
      
      final response = await _repository.saveAttendance(request);
      
      if (!response.success) {
        throw ApiErrorModel( 
          message: response.errors.isNotEmpty 
              ? response.errors.join(', ')
              : 'Failed to save attendance',
          type: ApiErrorType.badResponse,
          statusCode: 500,
        );
      }
    }
    
    await _repository.endSession(sessionId);
  }
}