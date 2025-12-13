import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:mobile_app/core/Data/local_data_soruce/user_local_data_source.dart';
import 'package:mobile_app/feature/home/data/models/user_model.dart';
import 'package:mobile_app/feature/scan_OCR/data/repo_imp/camera_reo_imp.dart';
import 'package:mobile_app/feature/scan_OCR/domain/repo/camera_repo.dart';
import 'package:mobile_app/feature/scan_OCR/domain/usecases/captured_photo.dart';
import 'package:mobile_app/feature/scan_OCR/domain/usecases/process_card_use_case.dart';
import 'package:mobile_app/feature/scan_OCR/domain/usecases/save_scanned_card_use_case.dart';
import 'package:mobile_app/feature/scan_OCR/domain/usecases/validate_card_use_case.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/logic/camera_cubit.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  final userBox = await Hive.openBox<UserModel>('users');
  getIt.registerLazySingleton<Box<UserModel>>(() => userBox);
  
  getIt.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImp(userBox: getIt()),
  );
  
  
  getIt.registerLazySingleton<CameraRepository>(
    () => CameraRepImp(),
  );
  
  getIt.registerLazySingleton(() => CapturePhotoUseCase(getIt()));
  getIt.registerLazySingleton(() => ValidateCardUseCase(getIt()));
  getIt.registerLazySingleton(() => ProcessCardUseCase(getIt()));
  
  getIt.registerLazySingleton(
    () => SaveScannedCardUseCase(getIt()),
  );
  
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