import 'package:device_info_plus/device_info_plus.dart';
import 'package:mobile_app/core/DI/get_it.dart';
import 'package:mobile_app/core/current_user/data/local_data_soruce/user_local_data_source.dart';
import 'package:mobile_app/feature/home/presentation/user/data/repos_imp/session_discovery_repo_impl.dart';
import 'package:mobile_app/feature/home/presentation/user/data/repos_imp/user_attendence_repo_impl.dart';
import 'package:mobile_app/feature/home/presentation/user/data/repos_imp/user_repo_impl.dart';
import 'package:mobile_app/feature/home/presentation/user/data/services/attendence_service.dart';
import 'package:mobile_app/feature/home/presentation/user/data/services/session_discovery_service.dart';
import 'package:mobile_app/feature/home/presentation/user/domain/repos/session_discovery_repo.dart';
import 'package:mobile_app/feature/home/presentation/user/domain/repos/user_attendence_repo.dart';
import 'package:mobile_app/feature/home/presentation/user/domain/repos/user_repo.dart';
import 'package:mobile_app/feature/home/presentation/user/domain/use_cases/check_in_use_case.dart';
import 'package:mobile_app/feature/home/presentation/user/domain/use_cases/discover_session_use_case.dart';
import 'package:mobile_app/feature/home/presentation/user/domain/use_cases/get_attendence_history_use_case.dart';
import 'package:mobile_app/feature/home/presentation/user/domain/use_cases/get_attendence_status_use_case.dart';
import 'package:mobile_app/feature/home/presentation/user/domain/use_cases/get_current_user_use_case.dart';
import 'package:mobile_app/feature/home/presentation/user/domain/use_cases/start_discovery_use_case.dart';
import 'package:mobile_app/feature/home/presentation/user/domain/use_cases/stop_discover_use_case.dart';
import 'package:mobile_app/feature/home/presentation/user/presentation/logic/user_cubit.dart';

void initUserHome() {
  
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

  if (!getIt.isRegistered<UserRepo>()) {
    getIt.registerLazySingleton<UserRepo>(
      () => UserRepoImpl(
        localDataSource: getIt<UserLocalDataSource>(),
      ),
    );
  }

  // ==================== USE CASES ====================
  
  if (!getIt.isRegistered<GetCurrentUserUseCase>()) {
    getIt.registerLazySingleton<GetCurrentUserUseCase>(
      () => GetCurrentUserUseCase(getIt<UserRepo>()),
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
        getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
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