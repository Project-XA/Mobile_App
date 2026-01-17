import 'package:mobile_app/feature/verification/domain/repo/verify_repo.dart';

class FaceVerifyUseCase {
  final VerifyRepo verifyRepo;

  FaceVerifyUseCase({required this.verifyRepo});

  Future<bool> call({
    required String idCardImagePath,
    required String selfieImagePath,
  }) async {
    return await verifyRepo.verifyIdentity(
      idCardImagePath: idCardImagePath,
      selfieImagePath: selfieImagePath,
    );
  }
}
