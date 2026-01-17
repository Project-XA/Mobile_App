import 'package:camera/camera.dart';

class VerificationState {
  final CameraController? controller;
  final bool isCameraInitialized;
  final bool hasError;
  final bool hascaptured;
  final bool isprocessing;
  final bool isOpened;
  final bool hasPermissionDenied;
  final bool isInitializing;
  final bool isVerificationComplete;
  final String? capturePhotoPath;
  final bool isnotVerified;
  final String? errorMessage;

  const VerificationState({
    this.controller,
    this.isCameraInitialized = false,
    this.hasError = false,
    this.errorMessage,
    this.hascaptured = false,
    this.isprocessing = false,
    this.isOpened = false,
    this.hasPermissionDenied = false,
    this.isInitializing = false,
    this.isVerificationComplete = false,
    this.capturePhotoPath,
    this.isnotVerified = false,
  });

  bool get isCameraReady =>
      controller != null && isCameraInitialized && !hasError;

  VerificationState copyWith({
    CameraController? controller,
    bool? isCameraInitialized,
    bool? hasError,
    String? errorMessage,
    bool? hascaptured,
    bool? isprocessing,
    bool? isOpened,
    bool? hasPermissionDenied,
    bool? isInitializing,
    bool? isVerificationComplete, // ✅ إضافة
    bool clearController = false,
    bool clearError = false,
    String? capturePhotoPath,
    bool? isnotVerified,
  }) {
    return VerificationState(
      controller: clearController ? null : (controller ?? this.controller),
      isCameraInitialized: isCameraInitialized ?? this.isCameraInitialized,
      hasError: clearError ? false : (hasError ?? this.hasError),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      hascaptured: hascaptured ?? this.hascaptured,
      isprocessing: isprocessing ?? this.isprocessing,
      isOpened: isOpened ?? this.isOpened,
      hasPermissionDenied: hasPermissionDenied ?? this.hasPermissionDenied,
      isInitializing: isInitializing ?? this.isInitializing,
      isVerificationComplete:
          isVerificationComplete ?? this.isVerificationComplete,
      capturePhotoPath: capturePhotoPath ?? this.capturePhotoPath,
      isnotVerified: isnotVerified ?? this.isnotVerified,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VerificationState &&
        other.controller == controller &&
        other.isCameraInitialized == isCameraInitialized &&
        other.hasError == hasError &&
        other.errorMessage == errorMessage &&
        other.hascaptured == hascaptured &&
        other.isprocessing == isprocessing &&
        other.isOpened == isOpened &&
        other.hasPermissionDenied == hasPermissionDenied &&
        other.isInitializing == isInitializing &&
        other.isVerificationComplete == isVerificationComplete &&
        other.capturePhotoPath == capturePhotoPath &&
        other.isnotVerified == isnotVerified;
  }

  @override
  int get hashCode {
    return controller.hashCode ^
        isCameraInitialized.hashCode ^
        hasError.hashCode ^
        errorMessage.hashCode ^
        hascaptured.hashCode ^
        isprocessing.hashCode ^
        isOpened.hashCode ^
        hasPermissionDenied.hashCode ^
        isInitializing.hashCode ^
        isVerificationComplete.hashCode ^
        capturePhotoPath.hashCode ^
        isnotVerified.hashCode;
  }

  @override
  String toString() {
    return 'VerificationState('
        'isCameraInitialized: $isCameraInitialized, '
        'hasError: $hasError, '
        'errorMessage: $errorMessage, '
        'hascaptured: $hascaptured, '
        'isprocessing: $isprocessing, '
        'isOpened: $isOpened, '
        'hasPermissionDenied: $hasPermissionDenied, '
        'isInitializing: $isInitializing, '
        'isVerificationComplete: $isVerificationComplete'
        ')';
  }
}
