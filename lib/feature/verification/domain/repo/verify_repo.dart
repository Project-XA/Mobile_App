import 'package:camera/camera.dart';

abstract class VerifyRepo {
  Future<bool> verifyIdentity({
    required String idCardImagePath,
    required String selfieImagePath,
  });
  Future<void> openCamera();
  Future<void> closeCamera();
  CameraController? get controller;
  Future<String> capturePhoto();
  Future<String> getIdCardImagePath();
  bool get isCameraInitialized;
}
