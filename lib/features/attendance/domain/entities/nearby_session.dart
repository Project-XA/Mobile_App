class NearbySession {
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

  NearbySession({
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

  String get baseUrl => 'http://$ipAddress:$port';
  
  DateTime get endTime => startTime.add(Duration(minutes: durationMinutes));
  
  bool get isOngoing {
    final now = DateTime.now();
    return now.isAfter(startTime) && now.isBefore(endTime);
  }
}