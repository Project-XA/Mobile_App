import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile_app/feature/home/presentation/user/data/models/discover_session_model.dart';
import 'package:mobile_app/feature/home/presentation/user/data/models/nearby_session_model.dart';
import 'package:mobile_app/feature/home/presentation/user/data/services/session_discovery_service.dart';
import 'package:mobile_app/feature/home/presentation/user/domain/entities/nearby_session.dart';
import 'package:mobile_app/feature/home/presentation/user/domain/repos/session_discovery_repo.dart';

class SessionDiscoveryRepositoryImpl implements SessionDiscoveryRepository {
  final SessionDiscoveryService _discoveryService;

  SessionDiscoveryRepositoryImpl({
    required SessionDiscoveryService discoveryService,
  }) : _discoveryService = discoveryService;

  @override
  Stream<NearbySession> discoverSessions() {
    return _discoveryService.sessionStream.asyncMap((discovered) async {
      // Fetch full session details
      final details = await getSessionDetails(discovered.baseUrl);
      return details ?? _createBasicSession(discovered);
    });
  }

  @override
  Future<void> startDiscovery() async {
    await _discoveryService.startDiscovery();
  }

  @override
  Future<void> stopDiscovery() async {
    await _discoveryService.stopDiscovery();
  }

  @override
  Future<NearbySession?> getSessionDetails(String baseUrl) async {
    try {
      // Try to get session info endpoint
      final response = await http
          .get(Uri.parse('$baseUrl/session-info'))
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final uri = Uri.parse(baseUrl);
        
        final model = NearbySessionModel.fromJson(
          data,
          uri.host,
          uri.port,
        );
        
        return model.toEntity();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  NearbySession _createBasicSession(DiscoveredSession discovered) {
    return NearbySession(
      sessionId: discovered.sessionId,
      name: discovered.name ?? 'Active Session',
      location: discovered.location ?? 'Unknown',
      connectionMethod: 'WiFi',
      startTime: discovered.timestamp,
      durationMinutes: 120,
      ipAddress: discovered.ipAddress,
      port: discovered.port,
    );
  }
}