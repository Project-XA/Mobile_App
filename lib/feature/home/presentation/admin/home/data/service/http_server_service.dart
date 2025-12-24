import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:mobile_app/feature/home/presentation/admin/home/data/models/attendence_request.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/data/models/server_info.dart';
import 'package:nsd/nsd.dart';

class HttpServerService {
  HttpServer? _server;
  Registration? _mdnsRegistration;
  final StreamController<AttendanceRequest> _attendanceController = 
      StreamController<AttendanceRequest>.broadcast();
  
  Stream<AttendanceRequest> get attendanceStream => _attendanceController.stream;
  
  String? _currentSessionId;
  bool get isServerRunning => _server != null;

  Future<ServerInfo> startServer(String sessionId) async {
    try {
      _server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
      _currentSessionId = sessionId;

      print('✅ HTTP Server started on port 8080');

      // 2. Handle incoming requests
      _server!.listen((HttpRequest request) {
        _handleRequest(request);
      });

      // 3. Register mDNS service
      await _registerMdnsService();

      // 4. Get local IP
      final localIp = await _getLocalIpAddress();

      return ServerInfo(
        ipAddress: localIp,
        port: 8080,
        sessionId: sessionId,
      );
    } catch (e) {
      print('❌ Error starting server: $e');
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
      // Read request body
      final body = await utf8.decoder.bind(request).join();
      final data = jsonDecode(body) as Map<String, dynamic>;

      // Parse attendance request
      final attendanceRequest = AttendanceRequest.fromJson(data);

      // Validate session
      if (_currentSessionId == null) {
        request.response
          ..statusCode = HttpStatus.badRequest
          ..write(jsonEncode({
            'status': 'error',
            'message': 'No active session'
          }));
        return;
      }

      // Emit to stream (Cubit will listen)
      _attendanceController.add(attendanceRequest);

      // Response
      request.response
        ..statusCode = HttpStatus.ok
        ..write(jsonEncode({
          'status': 'success',
          'time': DateTime.now().toString(),
          'sessionId': _currentSessionId,
        }));

      print('✅ Attendance recorded: ${attendanceRequest.userId}');
    } catch (e) {
      print('❌ Error handling attendance: $e');
      request.response
        ..statusCode = HttpStatus.badRequest
        ..write(jsonEncode({
          'status': 'error',
          'message': 'Invalid request format'
        }));
    }
  }

  // Health Check Endpoint
  void _handleHealthCheck(HttpRequest request) {
    request.response
      ..statusCode = HttpStatus.ok
      ..write(jsonEncode({
        'status': 'active',
        'sessionId': _currentSessionId,
        'timestamp': DateTime.now().toIso8601String(),
      }));
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
      print('✅ mDNS service registered: attendance.local');
    } catch (e) {
      print('⚠️ mDNS registration failed: $e');
      // Continue without mDNS (can still use direct IP)
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
      print('❌ Error getting IP: $e');
      return '0.0.0.0';
    }
  }

  // Stop Server
  Future<void> stopServer() async {
    try {
      // 1. Unregister mDNS
      if (_mdnsRegistration != null) {
        await unregister(_mdnsRegistration!);
        _mdnsRegistration = null;
        print('✅ mDNS service unregistered');
      }

      // 2. Close HTTP Server
      await _server?.close(force: true);
      _server = null;
      _currentSessionId = null;

      print('✅ HTTP Server stopped');
    } catch (e) {
      print('❌ Error stopping server: $e');
    }
  }

  // Cleanup
  void dispose() {
    _attendanceController.close();
    stopServer();
  }
}