import 'package:mobile_app/features/attendance/domain/entities/attendency_state.dart';
import 'package:mobile_app/features/attendance/domain/repos/user_attendence_repo.dart';

class GetAttendanceStatsUseCase {
  final UserAttendanceRepository _repository;

  GetAttendanceStatsUseCase(this._repository);

  Future<AttendanceStats> call() async {
    return await _repository.getAttendanceStats();
  }
}