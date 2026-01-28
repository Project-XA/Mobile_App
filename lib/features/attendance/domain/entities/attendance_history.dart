class AttendanceHistory {
  final String id;
  final String sessionId;
  final String sessionName;
  final String location;
  final DateTime checkInTime;
  final AttendanceStatus status;

  AttendanceHistory({
    required this.id,
    required this.sessionId,
    required this.sessionName,
    required this.location,
    required this.checkInTime,
    required this.status,
  });
}

enum AttendanceStatus {
  present,
  late,
  absent,
}