import 'package:mobile_app/features/session_mangement/data/models/attendency_record.dart';
import 'package:mobile_app/features/session_mangement/domain/repos/session_repository.dart';

class ListenAttendanceUseCase {
  final SessionRepository _repository;

  ListenAttendanceUseCase(this._repository);

  Stream<AttendanceRecord> call() {
    return _repository.getAttendanceStream();
  }
}