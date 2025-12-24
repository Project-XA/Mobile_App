import 'package:mobile_app/feature/home/presentation/admin/home/domain/entities/session.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/repos/session_repository.dart';

class CreateSessionUseCase {
  final SessionRepository _repository;

  CreateSessionUseCase(this._repository);

  Future<Session> call({
    required String name,
    required String location,
    required String connectionMethod,
    required DateTime startTime,
    required int durationMinutes,
  }) async {
    if (name.trim().isEmpty) {
      throw Exception('Session name is required');
    }
    if (location.trim().isEmpty) {
      throw Exception('Location is required');
    }
    if (durationMinutes <= 0) {
      throw Exception('Duration must be positive');
    }

    return await _repository.createSession(
      name: name,
      location: location,
      connectionMethod: connectionMethod,
      startTime: startTime,
      durationMinutes: durationMinutes,
    );
  }
}