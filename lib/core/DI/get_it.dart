// core/di/injection_container.dart
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:mobile_app/core/Data/local_data_soruce/user_local_data_source.dart';
import 'package:mobile_app/core/Data/remote_data_source/user_remote_data_source.dart';
import 'package:mobile_app/core/networking/dio_factory.dart';
import 'package:mobile_app/core/networking/network_service.dart';
import 'package:mobile_app/feature/home/data/models/user_model.dart';
import 'package:mobile_app/feature/home/presentation/admin/profile/data/repo_imp/profile_repo_imp.dart';
import 'package:mobile_app/feature/home/presentation/admin/profile/domain/repos/profile_repo.dart';
import 'package:mobile_app/feature/home/presentation/admin/profile/domain/usecases/get_current_user_use_case.dart';
import 'package:mobile_app/feature/home/presentation/admin/profile/domain/usecases/update_user_profile_image.dart';
import 'package:mobile_app/feature/home/presentation/admin/profile/domain/usecases/update_user_use_case.dart';
import 'package:mobile_app/feature/home/presentation/admin/profile/presentation/logic/user_profile_cubit.dart';
import 'package:mobile_app/feature/register/data/repo_imp/register_repo_imp.dart';
import 'package:mobile_app/feature/register/domain/repos/register_repo.dart';
import 'package:mobile_app/feature/register/domain/use_cases/register_use_case.dart';
import 'package:mobile_app/feature/register/presentation/logic/register_cubit.dart';
import 'package:mobile_app/feature/scan_OCR/data/repo_imp/camera_reo_imp.dart';
import 'package:mobile_app/feature/scan_OCR/domain/repo/camera_repo.dart';
import 'package:mobile_app/feature/scan_OCR/domain/usecases/captured_photo.dart';
import 'package:mobile_app/feature/scan_OCR/domain/usecases/process_card_use_case.dart';
import 'package:mobile_app/feature/scan_OCR/domain/usecases/save_scanned_card_use_case.dart';
import 'package:mobile_app/feature/scan_OCR/domain/usecases/validate_card_use_case.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/logic/camera_cubit.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  //  Hive 
  final userBox = await Hive.openBox<UserModel>('users');
  getIt.registerLazySingleton<Box<UserModel>>(() => userBox);

  //  Core Networking 
  getIt.registerLazySingleton<Dio>(
    () => DioFactory.getDio(),
  );

  getIt.registerLazySingleton<NetworkService>(
    () => NetworkServiceImp(),
  );

  //  Data Sources 
  getIt.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImp(userBox: getIt()),
  );

  getIt.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImp(getIt<NetworkService>()),
  );

  //  Profile Feature 
  getIt.registerLazySingleton<ProfileRepo>(
    () => ProfileRepoImp(localDataSource: getIt()),
  );

  getIt.registerLazySingleton(() => GetCurrentUserUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateUserUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateUserProfileImage(getIt()));

  getIt.registerFactory(
    () => UserProfileCubit(
      getIt<GetCurrentUserUseCase>(),
      getIt<UpdateUserProfileImage>(),
      getIt<UpdateUserUseCase>(),
    ),
  );

// registeration feature
  getIt.registerLazySingleton<RegisterRepo>(
    () => RegisterRepoImp(
      userRemoteDataSource: getIt<UserRemoteDataSource>(),
      localDataSource: getIt<UserLocalDataSource>(),
    ),
  );

  getIt.registerLazySingleton(
    () => RegisterUseCase(getIt<RegisterRepo>()),
  );

  getIt.registerFactory(
    () => RegisterCubit(getIt<RegisterUseCase>()),
  );




  // ========== Camera/OCR Feature ==========
  getIt.registerLazySingleton<CameraRepository>(() => CameraRepImp());
  getIt.registerLazySingleton(() => CapturePhotoUseCase(getIt()));
  getIt.registerLazySingleton(() => ValidateCardUseCase(getIt()));
  getIt.registerLazySingleton(() => ProcessCardUseCase(getIt()));
  getIt.registerLazySingleton(() => SaveScannedCardUseCase(getIt()));

  getIt.registerFactory(
    () => CameraCubit(
      getIt<CameraRepository>(),
      getIt<CapturePhotoUseCase>(),
      getIt<ValidateCardUseCase>(),
      getIt<ProcessCardUseCase>(),
      getIt<SaveScannedCardUseCase>(),
    ),
  );
}