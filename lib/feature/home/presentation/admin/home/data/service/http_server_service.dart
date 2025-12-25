import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:mobile_app/feature/home/presentation/admin/home/data/models/attendence_request.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/data/models/server_info.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/entities/session.dart';
import 'package:nsd/nsd.dart';

class HttpServerService {
  HttpServer? _server;
  Registration? _mdnsRegistration;
  final StreamController<AttendanceRequest> _attendanceController =
      StreamController<AttendanceRequest>.broadcast();

  Stream<AttendanceRequest> get attendanceStream =>
      _attendanceController.stream;

  String? _currentSessionId;
  Session? _currentSession;
  bool get isServerRunning => _server != null;

  void updateSessionData(Session session) {
    _currentSession = session;
  }

  Future<ServerInfo> startServer(String sessionId, Session session) async {
    try {
      _server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
      _currentSessionId = sessionId;
      _currentSession = session;

      _server!.listen((HttpRequest request) {
        _handleRequest(request);
      });

      await _registerMdnsService();

      final localIp = await _getLocalIpAddress();

      return ServerInfo(ipAddress: localIp, port: 8080, sessionId: sessionId);
    } catch (e) {
      rethrow;
    }
  }

  // Handle HTTP Requests
  Future<void> _handleRequest(HttpRequest request) async {
    // Enable CORS
    request.response.headers.add('Access-Control-Allow-Origin', '*');
    request.response.headers.add('Content-Type', 'application/json');

    try {
      if (request.method == 'POST' && request.uri.path == '/attend') {
        await _handleAttendanceRequest(request);
      } else if (request.method == 'GET' && request.uri.path == '/health') {
        _handleHealthCheck(request);
      } else if (request.method == 'GET' &&
          request.uri.path == '/session-info') {
        _handleSessionInfo(request);
      } else {
        request.response
          ..statusCode = HttpStatus.notFound
          ..write(jsonEncode({'error': 'Not found'}));
      }
    } catch (e) {
      request.response
        ..statusCode = HttpStatus.internalServerError
        ..write(jsonEncode({'error': e.toString()}));
    } finally {
      await request.response.close();
    }
  }

  // Handle Attendance POST Request
  Future<void> _handleAttendanceRequest(HttpRequest request) async {
    try {
      final body = await utf8.decoder.bind(request).join();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final attendanceRequest = AttendanceRequest.fromJson(data);

      if (_currentSessionId == null) {
        request.response
          ..statusCode = HttpStatus.badRequest
          ..write(
            jsonEncode({'status': 'error', 'message': 'No active session'}),
          );
        return;
      }

      _attendanceController.add(attendanceRequest);

      // Response
      request.response
        ..statusCode = HttpStatus.ok
        ..write(
          jsonEncode({
            'status': 'success',
            'time': DateTime.now().toIso8601String(),
            'sessionId': _currentSessionId,
          }),
        );
    } catch (e) {
      request.response
        ..statusCode = HttpStatus.badRequest
        ..write(
          jsonEncode({'status': 'error', 'message': 'Invalid request format'}),
        );
    }
  }

  // Health Check Endpoint
  void _handleHealthCheck(HttpRequest request) {
    request.response
      ..statusCode = HttpStatus.ok
      ..write(
        jsonEncode({
          'status': 'active',
          'sessionId': _currentSessionId,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );
  }

  void _handleSessionInfo(HttpRequest request) {
    if (_currentSession == null) {
      request.response
        ..statusCode = HttpStatus.notFound
        ..write(jsonEncode({'error': 'No active session'}));
      return;
    }

    final sessionData = {
      'sessionId': _currentSession!.id,
      'name': _currentSession!.name,
      'location': _currentSession!.location,
      'connectionMethod': _currentSession!.connectionMethod,
      'startTime': _currentSession!.startTime.toIso8601String(),
      'durationMinutes': _currentSession!.durationMinutes,
      'status': _statusToString(_currentSession!.status),
      'attendeeCount': _currentSession!.attendanceList.length,
      'connectedClients': _currentSession!.connectedClients,
      'timestamp': DateTime.now().toIso8601String(),
    };

    request.response
      ..statusCode = HttpStatus.ok
      ..write(jsonEncode(sessionData));
  }

  String _statusToString(SessionStatus status) {
    switch (status) {
      case SessionStatus.active:
        return 'active';
      case SessionStatus.inactive:
        return 'inactive';
      case SessionStatus.ended:
        return 'ended';
    }
  }

  // Register mDNS Service
  Future<void> _registerMdnsService() async {
    try {
      final discovery = await startDiscovery('_http._tcp');

      const service = Service(
        name: 'attendance',
        type: '_http._tcp',
        port: 8080,
      );

      _mdnsRegistration = await register(service);
    } catch (e) {
      // mDNS registration failed
    }
  }

  // Get Local IP Address
  Future<String> _getLocalIpAddress() async {
    try {
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
      );

      for (var interface in interfaces) {
        for (var addr in interface.addresses) {
          if (!addr.isLoopback && addr.address.startsWith('192.168')) {
            return addr.address;
          }
        }
      }

      return '0.0.0.0';
    } catch (e) {
      return '0.0.0.0';
    }
  }

  // Stop Server
  Future<void> stopServer() async {
    try {
      if (_mdnsRegistration != null) {
        await unregister(_mdnsRegistration!);
        _mdnsRegistration = null;
      }

      await _server?.close(force: true);
      _server = null;
      _currentSessionId = null;
      _currentSession = null;
    } catch (e) {
      // Error stopping server
    }
  }

  // Cleanup
  void dispose() {
    _attendanceController.close();
    stopServer();
  }
}
