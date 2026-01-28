import 'package:mobile_app/core/curren_user/Data/local_data_soruce/user_local_data_source.dart';
import 'package:mobile_app/core/curren_user/Data/remote_data_source/user_remote_data_source.dart';
import 'package:mobile_app/features/session_mangement/data/models/remote_models/create_session_request_model.dart';
import 'package:mobile_app/features/session_mangement/data/models/server_info.dart';
import 'package:mobile_app/features/session_mangement/data/service/http_server_service.dart';
import 'package:mobile_app/features/session_mangement/domain/entities/attendency_record.dart';
import 'package:mobile_app/features/session_mangement/domain/entities/session.dart';
import 'package:mobile_app/features/session_mangement/domain/repos/session_repository.dart';
import 'package:uuid/uuid.dart';

class SessionRepositoryImpl implements SessionRepository {
  final HttpServerService _serverService;
  final UserRemoteDataSource _remoteDataSource;
  final UserLocalDataSource _localDataSource;
  Session? _currentSession;
  
  double? _sessionLatitude;
  double? _sessionLongitude;
  double? _allowedRadius;

  SessionRepositoryImpl({
    required HttpServerService serverService,
    required UserRemoteDataSource remoteDataSource,
    required UserLocalDataSource localDataSource,
  })  : _serverService = serverService,
        _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
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
  }) async {
    try {
      final sessionId = const Uuid().v4();
      final userData = await _localDataSource.getCurrentUser();

      final organizationId = userData.organizations!.isNotEmpty
          ? userData.organizations!.first.organizationId
          : null;

      if (organizationId == null) {
        throw Exception('Invalid organization ID');
      }

      final requestModel = CreateSessionRequestModel(
        organizationId: organizationId,
        sessionName: name,
        createdBy: userData.id!,
        hallName: location,
        connectionType: connectionMethod,
        longitude: longitude,
        latitude: latitude,
        allowedRadius: allowedRadius,
        networkSSID: networkSSID,
        networkBSSID: networkBSSID,
        startAt: startAt.toIso8601String(),
        endAt: endAt.toIso8601String(),
        hallId: 1,
      );

      await _remoteDataSource.createSession(requestModel);

      _sessionLatitude = latitude;
      _sessionLongitude = longitude;
      _allowedRadius = allowedRadius;

      _currentSession = Session(
        id: sessionId,
        name: name,
        location: location,
        connectionMethod: connectionMethod,
        startTime: startAt,
        durationMinutes: endAt.difference(startAt).inMinutes,
        status: SessionStatus.inactive,
        connectedClients: 0,
        attendanceList: [],
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

      final serverInfo = await _serverService.startServer(
        sessionId,
        _currentSession!,
        latitude: _sessionLatitude,
        longitude: _sessionLongitude,
        allowedRadius: _allowedRadius,
      );

      _currentSession = _currentSession!.copyWith(status: SessionStatus.active);

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
      _currentSession = _currentSession!.copyWith(status: SessionStatus.ended);
      _currentSession = null;
      
      _sessionLatitude = null;
      _sessionLongitude = null;
      _allowedRadius = null;
    } catch (e) {
      throw Exception('Failed to end session: $e');
    }
  }

  @override
  Stream<AttendanceRecord> getAttendanceStream() {
    return _serverService.attendanceStream.map((request) {
      final record = request.toAttendanceRecord();

      if (_currentSession != null) {
        final updatedAttendance = List<AttendanceRecord>.from(
          _currentSession!.attendanceList,
        )..add(record);

        _currentSession = _currentSession!.copyWith(
          attendanceList: updatedAttendance,
          connectedClients: updatedAttendance.length,
        );

        _serverService.updateSessionData(_currentSession!);
      }

      return record;
    });
  }

  @override
  Future<Session?> getCurrentActiveSession() async {
    return _currentSession;
  }
}