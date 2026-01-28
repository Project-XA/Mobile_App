
class AttendanceResponse {
  final bool success;
  final String message;
  final String? sessionId;
  final DateTime? timestamp;

  AttendanceResponse({
    required this.success,
    required this.message,
    this.sessionId,
    this.timestamp,
  });
}