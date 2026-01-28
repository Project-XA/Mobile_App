import 'package:mobile_app/features/attendance/domain/repos/session_discovery_repo.dart';

class StartDiscoveryUseCase {
  final SessionDiscoveryRepository _repository;

  StartDiscoveryUseCase(this._repository);

  Future<void> call() async {
    await _repository.startDiscovery();
  }
}