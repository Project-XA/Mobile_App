import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/feature/scan_OCR/domain/repo/camera_repo.dart';
import 'package:mobile_app/feature/scan_OCR/domain/usecases/process_card_use_case.dart';
import 'package:mobile_app/feature/scan_OCR/domain/usecases/save_scanned_card_use_case.dart';
import 'package:mobile_app/feature/scan_OCR/domain/usecases/validate_card_use_case.dart';
import 'package:mobile_app/feature/scan_OCR/domain/usecases/validate_required_field_use_case.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/logic/camera_state.dart';
import 'package:mobile_app/feature/scan_OCR/domain/usecases/captured_photo.dart';
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

    emit(state.copyWith(isInitializing: true, hasError: false, hasPermissionDenied: false));

    try {
      // التحقق من الـ permission
      final status = await Permission.camera.status;
      
      if (status.isDenied || status.isPermanentlyDenied) {
        // طلب الـ permission
        final result = await Permission.camera.request();
        
        if (result.isDenied || result.isPermanentlyDenied) {
          // الـ permission مرفوض
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

    emit(state.copyWith(isProcessing: true, hasError: false));

    try {
      // 1️⃣ التقاط الصورة
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

      // 2️⃣ التحقق من أنها بطاقة
      final isCard = await _validateUseCase.execute(photo);

      if (!isCard) {
        print('❌ Not a valid ID card');
        emit(
          state.copyWith(
            isProcessing: false,
            showResult: false,
            hasError: false,
          ),
        );
        return;
      }

      print('✅ Valid ID card detected');

      // 3️⃣ كشف الـ fields
      final detections = await _repository.detectFields(photo);
      
      print('📋 Total detections: ${detections.length}');
      print('📋 Detected labels: ${detections.map((d) => d.className).toSet()}');

      // 4️⃣ التحقق من وجود الـ required fields
      final validationResult = await _validateFieldsUseCase.execute(detections);

      if (!validationResult.isValid) {
        print('❌ Required fields validation failed: ${validationResult.reason}');
        
        // إذا الـ fields المطلوبة مش موجودة، نعمل retake تلقائي
        emit(
          state.copyWith(
            isProcessing: false,
            showResult: false,
            hasError: false,
          ),
        );
        return;
      }

      print('✅ All required fields validated successfully');

      // 5️⃣ معالجة البطاقة واستخراج البيانات
      final result = await _processUseCase.execute(photo);

      // 6️⃣ التحقق من أن البيانات المهمة موجودة في النتيجة النهائية
      final hasFirstName = result.finalData['firstName'] != null && 
                           result.finalData['firstName']!.isNotEmpty;
      final hasLastName = result.finalData['lastName'] != null && 
                          result.finalData['lastName']!.isNotEmpty;

      if (!hasFirstName || !hasLastName) {
        print('❌ Missing firstName or lastName in final data');
        print('📋 Final data: ${result.finalData}');
        
        emit(
          state.copyWith(
            isProcessing: false,
            showResult: false,
            hasError: false,
          ),
        );
        return;
      }

      // 7️⃣ كل شيء تمام، نعرض النتائج
      print('✅ Processing completed successfully');
      print('📋 Final data: ${result.finalData}');

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
      print('❌ Error during capture/processing: $e');
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