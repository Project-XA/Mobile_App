import 'package:mobile_app/feature/scan_OCR/domain/repo/camera_repo.dart';
import 'package:mobile_app/feature/scan_OCR/domain/usecases/captured_photo.dart';

class ValidateCardUseCase {
  final CameraRepository _repository;

  ValidateCardUseCase(this._repository);

  Future<bool> execute(CapturedPhoto photo) async {
    return await _repository.isCard(photo);
  }
}