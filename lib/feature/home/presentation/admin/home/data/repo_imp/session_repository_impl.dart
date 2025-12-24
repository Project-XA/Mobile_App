import 'package:mobile_app/feature/home/presentation/admin/home/data/models/server_info.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/data/service/http_server_service.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/entities/attendency_record.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/entities/session.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/repos/session_repository.dart';
import 'package:uuid/uuid.dart';

class SessionRepositoryImpl implements SessionRepository {
  final HttpServerService _serverService;
  Session? _currentSession;

  SessionRepositoryImpl({required HttpServerService serverService})
      : _serverService = serverService;

  @override
  Future<Session> createSession({
    required String name,
    required String location,
    required String connectionMethod,
    required DateTime startTime,
    required int durationMinutes,
  }) async {
    try {
      // Generate unique session ID
      final sessionId = const Uuid().v4();

      // Create session entity
      _currentSession = Session(
        id: sessionId,
        name: name,
        location: location,
        connectionMethod: connectionMethod,
        startTime: startTime,
        durationMinutes: durationMinutes,
        status: SessionStatus.inactive,
      );

      return _currentSession!;
    } catch (e) {
      throw Exception('Failed to create session: $e');
    }
  }

  @override
  Future<ServerInfo> startSessionServer(String sessionId) async {
    try {
      if (_currentSession?.id != sessionId) {
        throw Exception('Session not found');
      }

      // Start HTTP Server + mDNS
      final serverInfo = await _serverService.startServer(sessionId);

      // Update session status
      _currentSession = _currentSession!.copyWith(
        status: SessionStatus.active,
      );

      return serverInfo;
    } catch (e) {
      throw Exception('Failed to start server: $e');
    }
  }

  @override
  Future<void> endSession(String sessionId) async {
    try {
      if (_currentSession?.id != sessionId) {
        throw Exception('Session not found');
      }

      await _serverService.stopServer();

      _currentSession = _currentSession!.copyWith(
        status: SessionStatus.ended,
      );

      
      _currentSession = null;
    } catch (e) {
      throw Exception('Failed to end session: $e');
    }
  }

  @override
  Stream<AttendanceRecord> getAttendanceStream() {
    return _serverService.attendanceStream
        .map((request) => request.toAttendanceRecord());
  }

  @override
  Future<Session?> getCurrentActiveSession() async {
    return _currentSession;
  }
}
