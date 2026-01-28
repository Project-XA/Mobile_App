import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:mobile_app/features/session_mangement/data/models/attendence_request.dart';
import 'package:mobile_app/features/session_mangement/domain/entities/server_info.dart';
import 'package:mobile_app/features/session_mangement/domain/entities/session.dart';
import 'package:nsd/nsd.dart';

class HttpServerService {
  HttpServer? _server;
  Registration? _mdnsRegistration;
  final StreamController<AttendanceRequest> _attendanceController =
      StreamController<AttendanceRequest>.broadcast();

  Stream<AttendanceRequest> get attendanceStream =>
      _attendanceController.stream;

  int? _currentSessionId;
  Session? _currentSession;
  bool get isServerRunning => _server != null;

  double? _sessionLatitude;
  double? _sessionLongitude;
  double? _allowedRadius;

  void updateSessionData(Session session) {
    _currentSession = session;
  }

  Future<ServerInfo> startServer(
    int sessionId,
    Session session, {
    double? latitude,
    double? longitude,
    double? allowedRadius,
  }) async {
    try {
      _server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
      _currentSessionId = sessionId;
      _currentSession = session;
      
      _sessionLatitude = latitude;
      _sessionLongitude = longitude;
      _allowedRadius = allowedRadius;

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

  Future<void> _handleRequest(HttpRequest request) async {
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

  Future<void> _handleAttendanceRequest(HttpRequest request) async {
    try {
      final body = await utf8.decoder.bind(request).join();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final attendanceRequest = AttendanceRequest.fromJson(data);

      if (_currentSessionId == null || _currentSession == null) {
        request.response
          ..statusCode = HttpStatus.badRequest
          ..write(
            jsonEncode({'status': 'error', 'message': 'No active session'}),
          );
        return;
      }

      final alreadyCheckedIn = _currentSession!.attendanceList.any(
        (record) => record.deviceIdHash == attendanceRequest.deviceIdHash,
      );

      if (alreadyCheckedIn) {
        request.response
          ..statusCode = HttpStatus.conflict 
          ..write(
            jsonEncode({
              'status': 'error',
              'message': 'Already checked in',
              'code': 'ALREADY_CHECKED_IN',
            }),
          );
        return;
      }

      if (attendanceRequest.location != null) {
        final locationValid = _validateUserLocation(attendanceRequest.location!);
        
        if (!locationValid) {
          request.response
            ..statusCode = HttpStatus.forbidden
            ..write(
              jsonEncode({
                'status': 'error',
                'message': 'Out of zone',
                'code': 'OUT_OF_ZONE',
              }),
            );
          return;
        }
      } else {
        request.response
          ..statusCode = HttpStatus.badRequest
          ..write(
            jsonEncode({
              'status': 'error',
              'message': 'Location is required',
              'code': 'LOCATION_REQUIRED',
            }),
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
            'message': 'Attendance recorded successfully',
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

  bool _validateUserLocation(String locationString) {
    try {
      if (_sessionLatitude == null || 
          _sessionLongitude == null || 
          _allowedRadius == null) {
        return false;
      }

      final coords = locationString.split(',');
      if (coords.length != 2) {
        return false;
      }

      final userLat = double.parse(coords[0].trim());
      final userLng = double.parse(coords[1].trim());

      final distance = _calculateDistance(
        userLat,
        userLng,
        _sessionLatitude!,
        _sessionLongitude!,
      );


      return distance <= _allowedRadius!;
    } catch (e) {
      return false;
    }
  }

  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadius = 6371000;
    
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    
    final a = 
      (sin(dLat / 2) * sin(dLat / 2)) +
      cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
      (sin(dLon / 2) * sin(dLon / 2));
    
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    
    return earthRadius * c; 
  }

  double _toRadians(double degrees) {
    return degrees * pi / 180;
  }

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
      _sessionLatitude = null;
      _sessionLongitude = null;
      _allowedRadius = null;
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