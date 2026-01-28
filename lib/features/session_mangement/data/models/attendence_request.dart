import 'package:mobile_app/features/session_mangement/data/models/attendency_record.dart';

class AttendanceRequest {
  final String userId;
  final String userName;
  final int timestamp;
  final String deviceIdHash;
  final String? location;
  final String? signature;

  AttendanceRequest({
    required this.userId,
    required this.userName,
    required this.timestamp,
    required this.deviceIdHash,
    this.location,
    this.signature,
  });

  factory AttendanceRequest.fromJson(Map<String, dynamic> json) {
    return AttendanceRequest(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      timestamp: json['timestamp'] as int,
      deviceIdHash: json['deviceIdHash'] as String,
      location: json['location'] as String?,
      signature: json['signature'] as String?,
    );
  }

  AttendanceRecord toAttendanceRecord() {
    return AttendanceRecord(
      userId: userId,
      userName: userName,
      checkInTime: DateTime.fromMillisecondsSinceEpoch(timestamp * 1000),
      deviceIdHash: deviceIdHash,
      location: location,
    );
  }
}