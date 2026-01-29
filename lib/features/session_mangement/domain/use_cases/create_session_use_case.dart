import 'package:mobile_app/features/session_mangement/data/service/network_info_service.dart';
import 'package:mobile_app/features/session_mangement/domain/entities/session.dart';
import 'package:mobile_app/features/session_mangement/domain/repos/session_repository.dart';

class CreateSessionUseCase {
  final SessionRepository _repository;
  final NetworkInfoService _networkInfoService;

  CreateSessionUseCase(this._repository, this._networkInfoService);

  Future<Session> call({
    required String name,
    required String location,
    required String connectionMethod,
    required DateTime startTime,
    required int durationMinutes,
    required double allowedRadius,
  }) async {
    final networkInfo = await _networkInfoService.getNetworkAndLocationInfo();

    final startAt = startTime.toUtc();
    final endAt = startAt.add(Duration(minutes: durationMinutes));

    return await _repository.createSession(
      name: name,
      location: location,
      connectionMethod: connectionMethod,
      startAt: startAt,
      endAt: endAt,
      allowedRadius: allowedRadius,
      networkSSID: networkInfo.ssid,
      networkBSSID: networkInfo.bssid,
      latitude: networkInfo.latitude,
      longitude: networkInfo.longitude,
    );
  }
}
