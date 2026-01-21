import 'package:mobile_app/core/DI/get_it.dart';
import 'package:mobile_app/core/services/register_lazy_if_not_registered.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/data/repo_imp/admin_repo_imp.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/data/repo_imp/session_repository_impl.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/data/service/http_server_service.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/repos/admin_repo.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/repos/session_repository.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/use_cases/create_session_use_case.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/use_cases/end_session_use_case.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/use_cases/get_current_user_use_case.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/use_cases/listen_attendence_use_case.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/domain/use_cases/start_session_server_use_case.dart';
import 'package:mobile_app/feature/home/presentation/admin/home/presentation/logic/admin_cubit.dart';



void initAdminHome() {
  if (getIt.isRegistered<AdminCubit>()) return;

  registerLazyIfNotRegistered<HttpServerService>(() => HttpServerService());

  registerLazyIfNotRegistered<SessionRepository>(
    () => SessionRepositoryImpl(serverService: getIt<HttpServerService>()),
  );

  registerLazyIfNotRegistered<AdminRepository>(
    () => AdminRepositoryImpl(localDataSource: getIt()),
  );

  registerLazyIfNotRegistered<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(getIt<AdminRepository>()),
  );

  registerLazyIfNotRegistered<CreateSessionUseCase>(
    () => CreateSessionUseCase(getIt<SessionRepository>()),
  );

  registerLazyIfNotRegistered<StartSessionServerUseCase>(
    () => StartSessionServerUseCase(getIt<SessionRepository>()),
  );

  registerLazyIfNotRegistered<EndSessionUseCase>(
    () => EndSessionUseCase(getIt<SessionRepository>()),
  );

  registerLazyIfNotRegistered<ListenAttendanceUseCase>(
    () => ListenAttendanceUseCase(getIt<SessionRepository>()),
  );

  getIt.registerFactory<AdminCubit>(
    () => AdminCubit(
      getCurrentUserUseCase: getIt(),
      createSessionUseCase: getIt(),
      startSessionServerUseCase: getIt(),
      endSessionUseCase: getIt(),
      listenAttendanceUseCase: getIt(),
    ),
  );
}
