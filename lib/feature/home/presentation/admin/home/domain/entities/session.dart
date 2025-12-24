import 'package:mobile_app/feature/home/presentation/admin/home/domain/entities/attendency_record.dart';

class Session {
  final String id;
  final String name;
  final String location;
  final String connectionMethod; 
  final DateTime startTime;
  final int durationMinutes;
  final SessionStatus status;
  final int connectedClients;
  final List<AttendanceRecord> attendanceList;

  Session({
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

  Session copyWith({
    String? id,
    String? name,
    String? location,
    String? connectionMethod,
    DateTime? startTime,
    int? durationMinutes,
    SessionStatus? status,
    int? connectedClients,
    List<AttendanceRecord>? attendanceList,
  }) {
    return Session(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      connectionMethod: connectionMethod ?? this.connectionMethod,
      startTime: startTime ?? this.startTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      status: status ?? this.status,
      connectedClients: connectedClients ?? this.connectedClients,
      attendanceList: attendanceList ?? this.attendanceList,
    );
  }
}

enum SessionStatus {
  inactive,
  active,
  ended,
}