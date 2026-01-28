class AttendanceStats {
  final int totalSessions;
  final int attendedSessions;
  final int lateCount;
  final double attendancePercentage;

  AttendanceStats({
    required this.totalSessions,
    required this.attendedSessions,
    required this.lateCount,
    required this.attendancePercentage,
  });
}