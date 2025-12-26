import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/feature/scan_OCR/domain/repo/camera_repo.dart';
import 'package:mobile_app/feature/scan_OCR/domain/usecases/process_card_use_case.dart';
import 'package:mobile_app/feature/scan_OCR/domain/usecases/save_scanned_card_use_case.dart';
import 'package:mobile_app/feature/scan_OCR/domain/usecases/validate_card_use_case.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/logic/camera_state.dart';
import 'package:mobile_app/feature/scan_OCR/domain/usecases/captured_photo.dart';

class CameraCubit extends Cubit<CameraState> {
  final CameraRepository _repository;
  final CapturePhotoUseCase _captureUseCase;
  final ValidateCardUseCase _validateUseCase;
  final ProcessCardUseCase _processUseCase;
  final SaveScannedCardUseCase _saveCardUseCase;

  CameraCubit(
    this._repository,
    this._captureUseCase,
    this._validateUseCase,
    this._processUseCase,
    this._saveCardUseCase,
  ) : super(const CameraState());

  CameraController? get controller => state.controller;
  bool get isInitialized => state.isOpened;
  bool get isBusy => state.isBusy;

  Future<void> openCamera() async {
    if (state.isOpened) return;
    emit(state.copyWith(isInitializing: true, hasError: false));

    try {
      await _repository.openCamera();
      emit(
        state.copyWith(
          isOpened: true,
          isInitializing: false,
          controller: _repository.controller,
          hasError: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(isInitializing: false, isOpened: false, hasError: true),
      );
      rethrow;
    }
  }

  Future<void> closeCamera() async {
    if (!state.isOpened) return;
    await _repository.closeCamera();
    emit(state.copyWith(isOpened: false, controller: null));
  }

  Future<void> capturePhoto() async {
    if (!state.canCapture) return;
    emit(state.copyWith(isProcessing: true, hasError: false));

    try {
      final photo = await _captureUseCase.execute();

      await _repository.closeCamera();
      emit(
        state.copyWith(
          isOpened: false,
          controller: null,
          hasCaptured: true,
          photo: photo,
          isProcessing: true,
        ),
      );

      final isValid = await _validateUseCase.execute(photo);

      if (!isValid) {
        emit(
          state.copyWith(
            isProcessing: false,
            showResult: false,
            hasError: false,
          ),
        );
        return;
      }

      final result = await _processUseCase.execute(photo);

      emit(
        state.copyWith(
          isProcessing: false,
          showResult: true,
          croppedFields: result.croppedFields,
          finalData: result.finalData,
          hasError: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isProcessing: false,
          showResult: false,
          hasCaptured: false,
          hasError: true,
        ),
      );
    }
  }

  Future<void> verifyAndSaveData() async {
    if (state.finalData == null) {
      return;
    }

    try {
      await _saveCardUseCase.execute(state.finalData!);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> retakePhoto() async {
    if (!state.canRetake) return;

    emit(
      state.copyWith(
        photo: null,
        hasCaptured: false,
        showResult: false,
        croppedFields: null,
        extractedText: null,
        finalData: null,
        hasError: false,
      ),
    );

    await openCamera();
  }

  void clearResults() {
    emit(const CameraState());
  }

  @override
  Future<void> close() async {
    await _repository.closeCamera();
    return super.close();
  }
}