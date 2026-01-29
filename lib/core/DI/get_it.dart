// core/di/core_injection.dart
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:dio/dio.dart';
import 'package:mobile_app/core/current_user/data/local_data_soruce/user_local_data_source.dart';
import 'package:mobile_app/core/current_user/data/remote_data_source/user_remote_data_source.dart';
import 'package:mobile_app/core/networking/dio_factory.dart';
import 'package:mobile_app/core/networking/network_service.dart';
import 'package:mobile_app/core/services/auth/auth_state_service.dart';
import 'package:mobile_app/core/services/auth/onboarding_service.dart';
import 'package:mobile_app/core/current_user/data/models/user_model.dart';

final getIt = GetIt.instance;

Future<void> initCore() async {
  // Hive
  final userBox = await Hive.openBox<UserModel>('users');
  getIt.registerLazySingleton<Box<UserModel>>(() => userBox);



  // Network
  getIt.registerLazySingleton<Dio>(() => DioFactory.getDio());
  getIt.registerLazySingleton<NetworkService>(() => NetworkServiceImp());

  // Data Sources
  getIt.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImp(userBox: getIt()),
  );

  getIt.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImp(getIt()),
  );

  // Services
  final authStateService = AuthStateService();
  await authStateService.init();
  getIt.registerLazySingleton<AuthStateService>(() => authStateService);
  getIt.registerLazySingleton<OnboardingService>(
    () => OnboardingService(
      getIt<AuthStateService>(),
      getIt<UserLocalDataSource>(),
    ),
  );
}
