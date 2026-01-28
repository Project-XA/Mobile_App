import 'package:mobile_app/features/session_mangement/domain/entities/server_info.dart';
import 'package:mobile_app/features/session_mangement/domain/repos/session_repository.dart';

class StartSessionServerUseCase {
  final SessionRepository _repository;

  StartSessionServerUseCase(this._repository);

  Future<ServerInfo> call(int sessionId) async {
    return await _repository.startSessionServer(sessionId);
  }
}
