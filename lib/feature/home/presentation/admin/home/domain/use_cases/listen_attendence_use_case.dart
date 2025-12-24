import 'package:mobile_app/feature/home/presentation/admin/home/domain/entities/attendency_record.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/repos/session_repository.dart';

class ListenAttendanceUseCase {
  final SessionRepository _repository;

  ListenAttendanceUseCase(this._repository);

  Stream<AttendanceRecord> call() {
    return _repository.getAttendanceStream();
  }
}