import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/ocr/domain/repo/camera_repo.dart';
import 'package:mobile_app/features/ocr/domain/usecases/process_card_use_case.dart';
import 'package:mobile_app/features/ocr/domain/usecases/save_scanned_card_use_case.dart';
import 'package:mobile_app/features/ocr/domain/usecases/validate_card_use_case.dart';
import 'package:mobile_app/features/ocr/domain/usecases/validate_required_field_use_case.dart';
import 'package:mobile_app/features/ocr/presentation/logic/camera_state.dart';
import 'package:mobile_app/features/ocr/domain/usecases/captured_photo.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraCubit extends Cubit<CameraState> {
  final CameraRepository _repository;
  final CapturePhotoUseCase _captureUseCase;
  final ValidateCardUseCase _validateUseCase;
  final ValidateRequiredFieldsUseCase _validateFieldsUseCase;
  final ProcessCardUseCase _processUseCase;
  final SaveScannedCardUseCase _saveCardUseCase;

  CameraCubit(
    this._repository,
    this._captureUseCase,
    this._validateUseCase,
    this._validateFieldsUseCase,
    this._processUseCase,
    this._saveCardUseCase,
  ) : super(const CameraState());

  CameraController? get controller => state.controller;
  bool get isInitialized => state.isOpened;
  bool get isBusy => state.isBusy;

  Future<void> openCamera() async {
    if (state.isOpened) return;

    emit(
      state.copyWith(
        isInitializing: true,
        hasError: false,
        hasPermissionDenied: false,
        showInvalidCardMessage: false,
      ),
    );

    try {
      final status = await Permission.camera.status;

      if (status.isDenied || status.isPermanentlyDenied) {
        final result = await Permission.camera.request();

        if (result.isDenied || result.isPermanentlyDenied) {
          emit(
            state.copyWith(
              isInitializing: false,
              isOpened: false,
              hasError: false,
              hasPermissionDenied: true,
            ),
          );
          return;
        }
      }

      await _repository.openCamera();
      emit(
        state.copyWith(
          isOpened: true,
          isInitializing: false,
          controller: _repository.controller,
          hasError: false,
          hasPermissionDenied: false,
          showInvalidCardMessage: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isInitializing: false,
          isOpened: false,
          hasError: true,
          hasPermissionDenied: false,
        ),
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

    emit(
      state.copyWith(
        isProcessing: true,
        hasError: false,
        showInvalidCardMessage: false,
      ),
    );

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

      final isCard = await _validateUseCase.execute(photo);

      if (!isCard) {
        emit(
          state.copyWith(
            isProcessing: false,
            showResult: false,
            hasError: false,
            hasCaptured: false,
            showInvalidCardMessage: true,
            errorMessage: 'Please use a valid ID card',
          ),
        );

        await Future.delayed(const Duration(seconds: 2));

        emit(state.copyWith(showInvalidCardMessage: false, errorMessage: null));

        await openCamera();
        return;
      }

      final detections = await _repository.detectFields(photo);

      final validationResult = await _validateFieldsUseCase.execute(detections);

      if (!validationResult.isValid) {
        emit(
          state.copyWith(
            isProcessing: false,
            showResult: false,
            hasError: false,
            hasCaptured: false,
            showInvalidCardMessage: true,
            errorMessage: 'Required fields missing. Please try again',
          ),
        );

        await Future.delayed(const Duration(seconds: 2));

        emit(state.copyWith(showInvalidCardMessage: false, errorMessage: null));

        await openCamera();
        return;
      }

      final result = await _processUseCase.execute(photo);

      final hasFirstName =
          result.finalData['firstName'] != null &&
          result.finalData['firstName']!.isNotEmpty;
      final hasLastName =
          result.finalData['lastName'] != null &&
          result.finalData['lastName']!.isNotEmpty;

      if (!hasFirstName || !hasLastName) {
        emit(
          state.copyWith(
            isProcessing: false,
            showResult: false,
            hasError: false,
            hasCaptured: false,
            showInvalidCardMessage: true,
            errorMessage: 'Could not extract name. Please try again',
          ),
        );

        await Future.delayed(const Duration(seconds: 2));

        emit(state.copyWith(showInvalidCardMessage: false, errorMessage: null));

        await openCamera();
        return;
      }

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
          showInvalidCardMessage: true,
          errorMessage: 'An error occurred. Please try again',
        ),
      );

      await Future.delayed(const Duration(seconds: 2));

      emit(
        state.copyWith(
          showInvalidCardMessage: false,
          errorMessage: null,
          hasError: false,
        ),
      );

      await openCamera();
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
        showInvalidCardMessage: false,
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
