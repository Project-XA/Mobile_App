import 'package:camera/camera.dart';
import 'package:mobile_app/feature/scan_OCR/domain/usecases/captured_photo.dart';

class CameraState {
  final CameraController? controller;
  final bool isOpened;
  final bool hasCaptured;
  final CapturedPhoto? photo;
  final bool isInitializing;
  final bool isProcessing; 
  final bool showResult; 

  CameraState({
    this.controller,
    this.isOpened = false,
    this.hasCaptured = false,
    this.photo,
    this.isInitializing = false,
    this.isProcessing = false,
    this.showResult = false,
  });

  CameraState copyWith({
    CameraController? controller,
    bool? isOpened,
    bool? hasCaptured,
    CapturedPhoto? photo,
    bool? isInitializing,
    bool? isProcessing,
    bool? showResult,
  }) {
    return CameraState(
      controller: controller ?? this.controller,
      isOpened: isOpened ?? this.isOpened,
      hasCaptured: hasCaptured ?? this.hasCaptured,
      photo: photo ?? this.photo,
      isInitializing: isInitializing ?? this.isInitializing,
      isProcessing: isProcessing ?? this.isProcessing,
      showResult: showResult ?? this.showResult,
    );
  }
}