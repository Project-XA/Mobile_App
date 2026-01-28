import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/core/services/location/location_helper.dart';
import 'package:mobile_app/features/attendance/domain/entities/attendence_reponse.dart';

class AttendanceService {
  Future<AttendanceResponse> sendAttendanceRequest({
    required String baseUrl,
    required String userId,
    required String userName,
    required String deviceIdHash,
  }) async {
    try {
      final locationStatus = await LocationHelper.check();
      
      if (locationStatus == LocationStatus.serviceDisabled) {
        return AttendanceResponse(
          success: false,
          message: 'LOCATION_SERVICE_DISABLED',
        );
      }
      
      if (locationStatus == LocationStatus.deniedForever) {
        return AttendanceResponse(
          success: false,
          message: 'LOCATION_PERMISSION_DENIED_FOREVER',
        );
      }

      final position = await _getCurrentLocation();
      final location = '${position.latitude},${position.longitude}';


      final body = {
        'userId': userId,
        'userName': userName,
        'timestamp': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'deviceIdHash': deviceIdHash,
        'location': location,
      };


      final response = await http
          .post(
            Uri.parse('$baseUrl/attend'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 5));


      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AttendanceResponse(
          success: true,
          message: data['message'] ?? 'Attendance recorded',
          sessionId: data['sessionId'],
          timestamp: DateTime.parse(data['time']),
        );
      } else if (response.statusCode == 409) {
        return AttendanceResponse(
          success: false,
          message: 'You have already checked in to this session',
        );
      } else if (response.statusCode == 403) {
        return AttendanceResponse(
          success: false,
          message: 'You are outside the allowed zone. Please move closer.',
        );
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        return AttendanceResponse(
          success: false,
          message: data['message'] ?? 'Invalid request',
        );
      } else {
        return AttendanceResponse(
          success: false,
          message: 'Failed to record attendance (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      return AttendanceResponse(
        success: false,
        message: 'Network error: $e',
      );
    }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}