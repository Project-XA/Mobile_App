import 'package:mobile_app/features/attendance/domain/entities/nearby_session.dart';

class NearbySessionModel {
  final String sessionId;
  final String name;
  final String location;
  final String connectionMethod;
  final DateTime startTime;
  final int durationMinutes;
  final String ipAddress;
  final int port;
  final int attendeeCount;
  final bool isActive;

  NearbySessionModel({
    required this.sessionId,
    required this.name,
    required this.location,
    required this.connectionMethod,
    required this.startTime,
    required this.durationMinutes,
    required this.ipAddress,
    required this.port,
    this.attendeeCount = 0,
    this.isActive = true,
  });

  factory NearbySessionModel.fromJson(
    Map<String, dynamic> json,
    String ipAddress,
    int port,
  ) {
    return NearbySessionModel(
      sessionId: json['sessionId'] as String,
      name: json['name'] as String? ?? 'Unknown Session',
      location: json['location'] as String? ?? 'Unknown Location',
      connectionMethod: json['connectionMethod'] as String? ?? 'WiFi',
      startTime: DateTime.parse(json['startTime'] as String),
      durationMinutes: json['durationMinutes'] as int? ?? 60,
      ipAddress: ipAddress,
      port: port,
      attendeeCount: json['attendeeCount'] as int? ?? 0,
      isActive: json['status'] == 'active',
    );
  }

  NearbySession toEntity() {
    return NearbySession(
      sessionId: sessionId,
      name: name,
      location: location,
      connectionMethod: connectionMethod,
      startTime: startTime,
      durationMinutes: durationMinutes,
      ipAddress: ipAddress,
      port: port,
      attendeeCount: attendeeCount,
      isActive: isActive,
    );
  }
}