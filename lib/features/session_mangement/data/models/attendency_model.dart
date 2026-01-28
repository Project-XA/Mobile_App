import 'package:mobile_app/features/session_mangement/data/models/attendency_record.dart';

class AttendanceRecordModel {
  final String userId;
  final String userName;
  final DateTime checkInTime;
  final String deviceIdHash;
  final String? location;

  AttendanceRecordModel({
    required this.userId,
    required this.userName,
    required this.checkInTime,
    required this.deviceIdHash,
    this.location,
  });

  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) {
    return AttendanceRecordModel(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      checkInTime: DateTime.parse(json['checkInTime'] as String),
      deviceIdHash: json['deviceIdHash'] as String,
      location: json['location'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'checkInTime': checkInTime.toIso8601String(),
      'deviceIdHash': deviceIdHash,
      'location': location,
    };
  }
  AttendanceRecord toEntity() {
    return AttendanceRecord(
      userId: userId,
      userName: userName,
      checkInTime: checkInTime,
      deviceIdHash: deviceIdHash,
      location: location,
    );
  }
}
