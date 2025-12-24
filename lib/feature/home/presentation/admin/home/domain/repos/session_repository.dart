import 'package:mobile_app/feature/home/presentation/admin/home/data/models/server_info.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/entities/attendency_record.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/entities/session.dart';

abstract class SessionRepository {
  Future<Session> createSession({
    required String name,
    required String location,
    required String connectionMethod,
    required DateTime startTime,
    required int durationMinutes,
  });

  Future<ServerInfo> startSessionServer(String sessionId);
  Future<void> endSession(String sessionId);
  Stream<AttendanceRecord> getAttendanceStream();
  Future<Session?> getCurrentActiveSession();
}