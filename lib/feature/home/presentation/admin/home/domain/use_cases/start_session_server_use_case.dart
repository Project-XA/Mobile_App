import 'package:mobile_app/feature/home/presentation/admin/home/data/models/server_info.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/repos/session_repository.dart';

class StartSessionServerUseCase {
  final SessionRepository _repository;

  StartSessionServerUseCase(this._repository);

  Future<ServerInfo> call(String sessionId) async {
    return await _repository.startSessionServer(sessionId);
  }
}
