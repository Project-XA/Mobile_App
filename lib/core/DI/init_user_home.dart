import 'package:device_info_plus/device_info_plus.dart';
import 'package:mobile_app/core/DI/get_it.dart';
import 'package:mobile_app/features/attendance/data/repos_imp/session_discovery_repo_impl.dart';
import 'package:mobile_app/features/attendance/data/repos_imp/user_attendence_repo_impl.dart';
import 'package:mobile_app/features/attendance/data/services/attendence_service.dart';
import 'package:mobile_app/features/attendance/data/services/session_discovery_service.dart';
import 'package:mobile_app/features/attendance/domain/repos/session_discovery_repo.dart';
import 'package:mobile_app/features/attendance/domain/repos/user_attendence_repo.dart';
import 'package:mobile_app/features/attendance/domain/use_cases/check_in_use_case.dart';
import 'package:mobile_app/features/attendance/domain/use_cases/discover_session_use_case.dart';
import 'package:mobile_app/features/attendance/domain/use_cases/get_attendence_history_use_case.dart';
import 'package:mobile_app/features/attendance/domain/use_cases/get_attendence_status_use_case.dart';
import 'package:mobile_app/features/attendance/domain/use_cases/start_discovery_use_case.dart';
import 'package:mobile_app/features/attendance/domain/use_cases/stop_discover_use_case.dart';
import 'package:mobile_app/features/attendance/presentation/logic/user_cubit.dart';

void initUserAttendace() {
  
  if (!getIt.isRegistered<SessionDiscoveryService>()) {
    getIt.registerLazySingleton<SessionDiscoveryService>(
      () => SessionDiscoveryService(),
    );
  }

  if (!getIt.isRegistered<AttendanceService>()) {
    getIt.registerLazySingleton<AttendanceService>(
      () => AttendanceService(),
    );
  }

  if (!getIt.isRegistered<DeviceInfoPlugin>()) {
    getIt.registerLazySingleton<DeviceInfoPlugin>(
      () => DeviceInfoPlugin(),
    );
  }

  // ==================== REPOSITORIES ====================
  
  if (!getIt.isRegistered<SessionDiscoveryRepository>()) {
    getIt.registerLazySingleton<SessionDiscoveryRepository>(
      () => SessionDiscoveryRepositoryImpl(
        discoveryService: getIt<SessionDiscoveryService>(),
      ),
    );
  }

  if (!getIt.isRegistered<UserAttendanceRepository>()) {
    getIt.registerLazySingleton<UserAttendanceRepository>(
      () => UserAttendanceRepositoryImpl(
        attendanceService: getIt<AttendanceService>(),
        deviceInfo: getIt<DeviceInfoPlugin>(),
      ),
    );
  }


  if (!getIt.isRegistered<StartDiscoveryUseCase>()) {
    getIt.registerLazySingleton<StartDiscoveryUseCase>(
      () => StartDiscoveryUseCase(getIt<SessionDiscoveryRepository>()),
    );
  }

  if (!getIt.isRegistered<StopDiscoveryUseCase>()) {
    getIt.registerLazySingleton<StopDiscoveryUseCase>(
      () => StopDiscoveryUseCase(getIt<SessionDiscoveryRepository>()),
    );
  }

  if (!getIt.isRegistered<DiscoverSessionsUseCase>()) {
    getIt.registerLazySingleton<DiscoverSessionsUseCase>(
      () => DiscoverSessionsUseCase(getIt<SessionDiscoveryRepository>()),
    );
  }

  if (!getIt.isRegistered<CheckInUseCase>()) {
    getIt.registerLazySingleton<CheckInUseCase>(
      () => CheckInUseCase(getIt<UserAttendanceRepository>()),
    );
  }

  if (!getIt.isRegistered<GetAttendanceHistoryUseCase>()) {
    getIt.registerLazySingleton<GetAttendanceHistoryUseCase>(
      () => GetAttendanceHistoryUseCase(getIt<UserAttendanceRepository>()),
    );
  }

  if (!getIt.isRegistered<GetAttendanceStatsUseCase>()) {
    getIt.registerLazySingleton<GetAttendanceStatsUseCase>(
      () => GetAttendanceStatsUseCase(getIt<UserAttendanceRepository>()),
    );
  }

  // ==================== CUBIT ====================
  
  if (!getIt.isRegistered<UserCubit>()) {
    getIt.registerFactory<UserCubit>(
      () => UserCubit(
        startDiscoveryUseCase: getIt<StartDiscoveryUseCase>(),
        stopDiscoveryUseCase: getIt<StopDiscoveryUseCase>(),
        discoverSessionsUseCase: getIt<DiscoverSessionsUseCase>(),
        checkInUseCase: getIt<CheckInUseCase>(),
        getAttendanceHistoryUseCase: getIt<GetAttendanceHistoryUseCase>(),
        getAttendanceStatsUseCase: getIt<GetAttendanceStatsUseCase>(),
      ),
    );
  }
}