class AttendanceRecord {
  final String userId;
  final String userName;
  final DateTime checkInTime;
  final String deviceIdHash;
  final String? location;

  AttendanceRecord({
    required this.userId,
    required this.userName,
    required this.checkInTime,
    required this.deviceIdHash,
    this.location,
  });
}