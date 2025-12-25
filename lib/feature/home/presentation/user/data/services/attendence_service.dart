import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile_app/feature/home/presentation/user/domain/entities/attendence_reponse.dart';

class AttendanceService {
  // Send attendance request to discovered session
  Future<AttendanceResponse> sendAttendanceRequest({
    required String baseUrl,
    required String userId,
    required String userName,
    required String deviceIdHash,
    String? location,
  }) async {
    try {
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
          success: data['status'] == 'success',
          message: data['message'] ?? 'Attendance recorded',
          sessionId: data['sessionId'],
          timestamp: DateTime.parse(data['time']),
        );
      } else {
        final data = jsonDecode(response.body);
        return AttendanceResponse(
          success: false,
          message: data['message'] ?? 'Failed to record attendance',
        );
      }
    } catch (e) {
      return AttendanceResponse(
        success: false,
        message: 'Network error: $e',
      );
    }
  }
}