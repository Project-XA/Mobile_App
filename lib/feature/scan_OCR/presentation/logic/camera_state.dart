import 'package:camera/camera.dart';
import 'package:mobile_app/feature/scan_OCR/data/model/cropped_field.dart';
import 'package:mobile_app/feature/scan_OCR/domain/usecases/captured_photo.dart';
import 'package:mobile_app/feature/scan_OCR/presentation/logic/processing_status.dart';
import 'camera_status.dart';

class CameraState {
  final CameraController? controller;
  final bool isOpened;
  final bool isInitializing;
  final bool hasCaptured;
  final CapturedPhoto? photo;
  final bool isProcessing;
  final bool showResult;
  final List<CroppedField>? croppedFields;
  final Map<String, String>? extractedText;
  final Map<String, String>? finalData;
  final bool hasError;
  final bool hasPermissionDenied; // جديد

  const CameraState({
    this.controller,
    this.isOpened = false,
    this.isInitializing = false,
    this.hasCaptured = false,
    this.photo,
    this.isProcessing = false,
    this.showResult = false,
    this.croppedFields,
    this.extractedText,
    this.finalData,
    this.hasError = false,
    this.hasPermissionDenied = false, // جديد
  });

  
  bool get isBusy => isInitializing || isProcessing;
  bool get canCapture => isOpened && !isBusy && !hasCaptured;
  bool get canRetake => hasCaptured && !isBusy;
  bool get hasResults => showResult && finalData != null && finalData!.isNotEmpty;
  bool get isValidCard => hasCaptured && (showResult || isProcessing);
  bool get isInvalidCard => hasCaptured && !showResult && !isProcessing;

  CameraStatus get cameraStatus {
    if (hasPermissionDenied) return CameraStatus.permissionDenied; // جديد
    if (isInitializing) return CameraStatus.initializing;
    if (isOpened) return CameraStatus.ready;
    if (hasError) return CameraStatus.error;
    return CameraStatus.closed;
  }

  ProcessingStatus get processingStatus {
    if (isProcessing) return ProcessingStatus.processing;
    if (hasResults) return ProcessingStatus.completed;
    if (isInvalidCard) return ProcessingStatus.invalidCard;
    if (hasError) return ProcessingStatus.error;
    return ProcessingStatus.idle;
  }

  
  String getFieldValue(String fieldName, {String defaultValue = 'N/A'}) {
    return finalData?[fieldName] ?? defaultValue;
  }

  bool hasFieldValue(String fieldName) {
    final value = finalData?[fieldName];
    return value != null && value.isNotEmpty;
  }

  Map<String, String> get validFields {
    if (finalData == null) return {};
    return Map.fromEntries(
      finalData!.entries.where((entry) => entry.value.isNotEmpty),
    );
  }

  int get extractedFieldsCount => validFields.length;

  
  CameraState copyWith({
    CameraController? controller,
    bool? isOpened,
    bool? isInitializing,
    bool? hasCaptured,
    CapturedPhoto? photo,
    bool? isProcessing,
    bool? showResult,
    bool? hasError,
    bool? hasPermissionDenied, // جديد
    List<CroppedField>? croppedFields,
    Map<String, String>? extractedText,
    Map<String, String>? finalData,
  }) {
    return CameraState(
      controller: controller ?? this.controller,
      isOpened: isOpened ?? this.isOpened,
      isInitializing: isInitializing ?? this.isInitializing,
      hasCaptured: hasCaptured ?? this.hasCaptured,
      photo: photo ?? this.photo,
      isProcessing: isProcessing ?? this.isProcessing,
      showResult: showResult ?? this.showResult,
      hasError: hasError ?? this.hasError,
      hasPermissionDenied: hasPermissionDenied ?? this.hasPermissionDenied, // جديد
      croppedFields: croppedFields ?? this.croppedFields,
      extractedText: extractedText ?? this.extractedText,
      finalData: finalData ?? this.finalData,
    );
  }


  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CameraState &&
        other.controller == controller &&
        other.isOpened == isOpened &&
        other.isInitializing == isInitializing &&
        other.hasCaptured == hasCaptured &&
        other.photo == photo &&
        other.isProcessing == isProcessing &&
        other.showResult == showResult &&
        other.hasError == hasError &&
        other.hasPermissionDenied == hasPermissionDenied; // جديد
  }

  @override
  int get hashCode {
    return controller.hashCode ^
        isOpened.hashCode ^
        isInitializing.hashCode ^
        hasCaptured.hashCode ^
        photo.hashCode ^
        isProcessing.hashCode ^
        showResult.hashCode ^
        hasError.hashCode ^
        hasPermissionDenied.hashCode; // جديد
  }

  @override
  String toString() {
    return 'CameraState('
        'isOpened: $isOpened, '
        'isInitializing: $isInitializing, '
        'hasCaptured: $hasCaptured, '
        'isProcessing: $isProcessing, '
        'showResult: $showResult, '
        'hasError: $hasError, '
        'hasPermissionDenied: $hasPermissionDenied, ' // جديد
        'extractedFields: $extractedFieldsCount'
        ')';
  }
}