import 'package:mobile_app/feature/home/presentation/admin/home/domain/repos/session_repository.dart';

class EndSessionUseCase {
  final SessionRepository _repository;

  EndSessionUseCase(this._repository);

  Future<void> call(String sessionId) async {
    return await _repository.endSession(sessionId);
  }
}