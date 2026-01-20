// core/di/core_injection.dart
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:dio/dio.dart';
import 'package:mobile_app/core/Data/local_data_soruce/user_local_data_source.dart';
import 'package:mobile_app/core/Data/remote_data_source/user_remote_data_source.dart';
import 'package:mobile_app/core/networking/dio_factory.dart';
import 'package:mobile_app/core/networking/network_service.dart';
import 'package:mobile_app/core/services/auth_state_service.dart';
import 'package:mobile_app/core/services/onboarding_service.dart';
import 'package:mobile_app/feature/home/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> initCore() async {
  // Hive
  final userBox = await Hive.openBox<UserModel>('users');
  getIt.registerLazySingleton<Box<UserModel>>(() => userBox);

  // SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => prefs);

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
