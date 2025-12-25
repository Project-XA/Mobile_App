import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:mobile_app/feature/home/presentation/user/data/models/attendence_history_model.dart';
import 'package:mobile_app/feature/home/presentation/user/data/services/attendence_service.dart';
import 'package:mobile_app/feature/home/presentation/user/domain/entities/attendance_history.dart';
import 'package:mobile_app/feature/home/presentation/user/domain/entities/attendency_state.dart';
import 'package:mobile_app/feature/home/presentation/user/domain/repos/user_attendence_repo.dart';

class UserAttendanceRepositoryImpl implements UserAttendanceRepository {
  final AttendanceService _attendanceService;
  final DeviceInfoPlugin _deviceInfo;
  
  // In-memory cache for demo (replace with actual storage)
  final List<AttendanceHistoryModel> _historyCache = [];

  UserAttendanceRepositoryImpl({
    required AttendanceService attendanceService,
    required DeviceInfoPlugin deviceInfo,
  })  : _attendanceService = attendanceService,
        _deviceInfo = deviceInfo;

  @override
  Future<bool> checkIn({
    required String sessionId,
    required String baseUrl,
    required String userId,
    required String userName,
    String? location,
  }) async {
    try {
      // Get device hash
      final deviceHash = await _getDeviceHash();

      // Send attendance request
      final response = await _attendanceService.sendAttendanceRequest(
        baseUrl: baseUrl,
        userId: userId,
        userName: userName,
        deviceIdHash: deviceHash,
        location: location,
      );

      if (response.success) {
        // Cache attendance record
        _historyCache.add(AttendanceHistoryModel(
          id: '${sessionId}_${DateTime.now().millisecondsSinceEpoch}',
          sessionId: sessionId,
          sessionName: 'Session', // TODO: Get from session details
          location: location ?? 'Unknown',
          checkInTime: DateTime.now(),
          status: 'present',
        ));
      }

      return response.success;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<AttendanceHistory>> getAttendanceHistory() async {
    // TODO: Fetch from actual backend/storage
    // For now, return cached records
    return _historyCache.map((m) => m.toEntity()).toList();
  }

  @override
  Future<AttendanceStats> getAttendanceStats() async {
    // TODO: Fetch from actual backend
    // For demo purposes
    const totalSessions = 24;
    final attendedSessions = _historyCache.length;
    const lateCount = 0;
    final percentage = totalSessions > 0
        ? (attendedSessions / totalSessions) * 100
        : 0.0;

    return AttendanceStats(
      totalSessions: totalSessions,
      attendedSessions: attendedSessions,
      lateCount: lateCount,
      attendancePercentage: percentage,
    );
  }

  Future<String> _getDeviceHash() async {
    try {
      String deviceId = '';
      
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? '';
      }

      // Hash the device ID for privacy
      final bytes = utf8.encode(deviceId);
      final hash = sha256.convert(bytes);
      return hash.toString();
    } catch (e) {
      return 'unknown_device';
    }
  }
}