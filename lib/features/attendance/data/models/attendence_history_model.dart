import 'package:mobile_app/features/attendance/domain/entities/attendance_history.dart';

class AttendanceHistoryModel {
  final String id;
  final String sessionId;
  final String sessionName;
  final String location;
  final DateTime checkInTime;
  final String status;

  AttendanceHistoryModel({
    required this.id,
    required this.sessionId,
    required this.sessionName,
    required this.location,
    required this.checkInTime,
    required this.status,
  });

  factory AttendanceHistoryModel.fromJson(Map<String, dynamic> json) {
    return AttendanceHistoryModel(
      id: json['id'] as String,
      sessionId: json['sessionId'] as String,
      sessionName: json['sessionName'] as String,
      location: json['location'] as String,
      checkInTime: DateTime.parse(json['checkInTime'] as String),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sessionId': sessionId,
      'sessionName': sessionName,
      'location': location,
      'checkInTime': checkInTime.toIso8601String(),
      'status': status,
    };
  }

  AttendanceHistory toEntity() {
    return AttendanceHistory(
      id: id,
      sessionId: sessionId,
      sessionName: sessionName,
      location: location,
      checkInTime: checkInTime,
      status: _statusFromString(status),
    );
  }

  static AttendanceStatus _statusFromString(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return AttendanceStatus.present;
      case 'late':
        return AttendanceStatus.late;
      case 'absent':
        return AttendanceStatus.absent;
      default:
        return AttendanceStatus.present;
    }
  }
}
