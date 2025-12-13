import 'package:mobile_app/feature/scan_OCR/domain/repo/camera_repo.dart';
import 'package:mobile_app/feature/scan_OCR/domain/usecases/captured_photo.dart';
import 'package:mobile_app/feature/scan_OCR/domain/usecases/processing_result_use_case.dart';

class ProcessCardUseCase {
  final CameraRepository _repository;

  ProcessCardUseCase(this._repository);

  Future<CardProcessingResult> execute(CapturedPhoto photo) async {
    final detections = await _repository.detectFields(photo);

    final croppedFields = await _repository.cropDetectedFields(
      photo,
      detections,
    );

    final finalData = await _repository.extractFinalData(croppedFields);

    return CardProcessingResult(
      croppedFields: croppedFields,
      finalData: finalData,
    );
  }
}