import 'package:mobile_app/features/session_mangement/data/models/remote_models/save_attendance/save_attendance_request.dart';

class AttendanceRecord {
  final String userId;
  final String userName;
  final DateTime checkInTime;
  final String deviceIdHash;
  final String? location;
  final String? signature;

  AttendanceRecord({
    required this.userId,
    required this.userName,
    required this.checkInTime,
    required this.deviceIdHash,
    this.location,
    this.signature,
  });

  AttendanceRecord copyWith({
    String? userId,
    String? userName,
    DateTime? checkInTime,
    String? deviceIdHash,
    String? location,
    String? signature,
  }) {
    return AttendanceRecord(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      checkInTime: checkInTime ?? this.checkInTime,
      deviceIdHash: deviceIdHash ?? this.deviceIdHash,
      location: location ?? this.location,
      signature: signature ?? this.signature,
    );
  }

  // Convert to JSON (for storage/API)
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'checkInTime': checkInTime.toIso8601String(),
      'deviceIdHash': deviceIdHash,
      'location': location,
      'signature': signature,
    };
  }

  AttendanceLogItem toAttendanceLogItem() {
    return AttendanceLogItem(
      userId: userId,
      timeStamp: checkInTime.toIso8601String(),
      result: AttendanceResult.present, 
      proofSignature: signature,
      verificationId: null, 
    );
  }
  // Create from JSON
  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      checkInTime: DateTime.parse(json['checkInTime'] as String),
      deviceIdHash: json['deviceIdHash'] as String,
      location: json['location'] as String?,
      signature: json['signature'] as String?,
    );
  }

  @override
  String toString() {
    return 'AttendanceRecord(userId: $userId, userName: $userName, time: $checkInTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AttendanceRecord &&
        other.userId == userId &&
        other.checkInTime == checkInTime;
  }

  @override
  int get hashCode => userId.hashCode ^ checkInTime.hashCode;
}