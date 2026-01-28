import 'package:mobile_app/features/session_mangement/data/models/remote_models/save_attendance/save_attendance_request.dart';
import 'package:mobile_app/features/session_mangement/data/models/remote_models/save_attendance/save_attendance_response.dart';
import 'package:mobile_app/features/session_mangement/domain/entities/server_info.dart';
import 'package:mobile_app/features/session_mangement/data/models/attendency_record.dart';
import 'package:mobile_app/features/session_mangement/domain/entities/session.dart';

abstract class SessionRepository {
  Future<Session> createSession({
    required String name,
    required String location,
    required String connectionMethod,
    required DateTime startAt,
    required DateTime endAt,

    required double allowedRadius,
    required String networkSSID,
    required String networkBSSID,
    required double latitude,
    required double longitude,
  });

  Future<ServerInfo> startSessionServer(int sessionId);

  Future<void> endSession(int sessionId);

  Stream<AttendanceRecord> getAttendanceStream();

  Future<Session?> getCurrentActiveSession();
  Future<SaveAttendanceResponse> saveAttendance(SaveAttendanceRequest request);
}
