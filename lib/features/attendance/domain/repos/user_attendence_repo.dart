import 'package:mobile_app/features/attendance/domain/entities/attendance_history.dart';
import 'package:mobile_app/features/attendance/domain/entities/attendence_reponse.dart';
import 'package:mobile_app/features/attendance/domain/entities/attendency_state.dart';

abstract class UserAttendanceRepository {
  Future<AttendanceResponse> checkIn({
    required String sessionId,
    required String baseUrl,
    required String userId,
    required String userName,
    String? location,
  });
  
  Future<List<AttendanceHistory>> getAttendanceHistory();
  Future<AttendanceStats> getAttendanceStats();
}