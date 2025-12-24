import 'package:mobile_app/feature/home/presentation/admin/home/data/models/attendency_model.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/entities/session.dart';

class SessionModel {
  final String id;
  final String name;
  final String location;
  final String connectionMethod;
  final DateTime startTime;
  final int durationMinutes;
  final String status;
  final int connectedClients;
  final List<AttendanceRecordModel> attendanceList;

  SessionModel({
    required this.id,
    required this.name,
    required this.location,
    required this.connectionMethod,
    required this.startTime,
    required this.durationMinutes,
    required this.status,
    this.connectedClients = 0,
    this.attendanceList = const [],
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      connectionMethod: json['connectionMethod'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      durationMinutes: json['durationMinutes'] as int,
      status: json['status'] as String,
      connectedClients: json['connectedClients'] as int? ?? 0,
      attendanceList: (json['attendanceList'] as List<dynamic>?)
              ?.map((e) => AttendanceRecordModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'connectionMethod': connectionMethod,
      'startTime': startTime.toIso8601String(),
      'durationMinutes': durationMinutes,
      'status': status,
      'connectedClients': connectedClients,
      'attendanceList': attendanceList.map((e) => e.toJson()).toList(),
    };
  }

  Session toEntity() {
    return Session(
      id: id,
      name: name,
      location: location,
      connectionMethod: connectionMethod,
      startTime: startTime,
      durationMinutes: durationMinutes,
      status: _statusFromString(status),
      connectedClients: connectedClients,
      attendanceList: attendanceList.map((e) => e.toEntity()).toList(),
    );
  }

  static SessionStatus _statusFromString(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return SessionStatus.active;
      case 'ended':
        return SessionStatus.ended;
      default:
        return SessionStatus.inactive;
    }
  }
}