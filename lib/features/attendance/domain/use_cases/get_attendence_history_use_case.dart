import 'package:mobile_app/features/attendance/domain/entities/attendance_history.dart';
import 'package:mobile_app/features/attendance/domain/repos/user_attendence_repo.dart';

class GetAttendanceHistoryUseCase {
  final UserAttendanceRepository _repository;

  GetAttendanceHistoryUseCase(this._repository);

  Future<List<AttendanceHistory>> call() async {
    return await _repository.getAttendanceHistory();
  }
}