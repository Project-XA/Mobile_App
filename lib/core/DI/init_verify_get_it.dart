import 'package:mobile_app/core/DI/get_it.dart';
import 'package:mobile_app/core/DI/init_admin_home.dart';
import 'package:mobile_app/feature/verification/data/repo_impl/verify_repo_imp.dart';
import 'package:mobile_app/feature/verification/data/service/face_recogintion_service.dart';
import 'package:mobile_app/feature/verification/domain/repo/verify_repo.dart';
import 'package:mobile_app/feature/verification/domain/use_case/face_verify_use_case.dart';
import 'package:mobile_app/feature/verification/domain/use_case/load_id_card_for_verification.dart';
import 'package:mobile_app/feature/verification/presentation/logic/verification_cubit.dart';

void initVerifyScreen() {
  if (getIt.isRegistered<VerificationCubit>()) return;

  registerLazyIfNotRegistered<FaceRecognitionService>(
    () => FaceRecognitionService(),
  );
  registerLazyIfNotRegistered<VerifyRepo>(
    () => VerifyRepoImp(
      userLocalDataSource: getIt(),
      faceRecognitionService: getIt<FaceRecognitionService>(),
    ),
  );

  registerLazyIfNotRegistered<LoadIdCardForVerification>(
    () => LoadIdCardForVerification(verifyRepo: getIt<VerifyRepo>()),
  );
  registerLazyIfNotRegistered<FaceVerifyUseCase>(
    () => FaceVerifyUseCase(verifyRepo: getIt<VerifyRepo>()),
  );
  getIt.registerFactory<VerificationCubit>(
    () => VerificationCubit(
      getIt<FaceVerifyUseCase>(),
      getIt<VerifyRepo>(),
      getIt<LoadIdCardForVerification>(),
    ),
  );
}
