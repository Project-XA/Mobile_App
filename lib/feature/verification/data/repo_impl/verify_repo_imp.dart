import 'package:camera/camera.dart';
import 'package:mobile_app/core/current_user/data/local_data_soruce/user_local_data_source.dart';
import 'package:mobile_app/core/services/camera_permission_service.dart';
import 'package:mobile_app/feature/scan_OCR/data/repo_imp/camera_reo_imp.dart';
import 'package:mobile_app/feature/verification/data/service/face_recogintion_service.dart';
import 'package:mobile_app/feature/verification/domain/repo/verify_repo.dart';

class VerifyRepoImp extends VerifyRepo {
  final CameraPermissionService _permissionService;
  final UserLocalDataSource userLocalDataSource;
  final FaceRecognitionService faceRecognitionService;
  CameraController? _controller;
  bool _isCameraInitialized = false;

  VerifyRepoImp({
    CameraPermissionService? permissionService,
    required this.userLocalDataSource, required this.faceRecognitionService,
  }) : _permissionService = permissionService ?? CameraPermissionService();

  @override
  CameraController? get controller => _controller;

  @override
  bool get isCameraInitialized => _isCameraInitialized;

  @override
  Future<void> openCamera() async {
    final hasPermission = await _permissionService.isCameraPermissionGranted();
    if (!hasPermission) {
      final granted = await _permissionService.requestCameraPermission();
      if (!granted) {
        throw CameraPermissionException(
          'Camera permission is required to scan ID cards.',
        );
      }
    }

    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      throw Exception('No cameras available on this device');
    }

    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _controller = CameraController(
      frontCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller!.initialize();
    _isCameraInitialized = true;
  }

  @override
  Future<void> closeCamera() async {
    await _controller?.dispose();
    _controller = null;
    _isCameraInitialized = false;
  }

  @override
  Future<String> capturePhoto() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      throw Exception('Camera is not initialized');
    }

    final XFile file = await _controller!.takePicture();
    return file.path;
  }

  @override
  Future<bool> verifyIdentity({
    required String idCardImagePath,
    required String selfieImagePath,
  }) async {
    try {
      // Initialize face recognition service
      await faceRecognitionService.initialize();

      // Verify faces
      final isMatch = await faceRecognitionService.verifyFaces(
        imagePath1: idCardImagePath,
        imagePath2: selfieImagePath,
        threshold: 1.0,
      );

      return isMatch;
    } catch (e) {
      throw Exception('Face verification failed: ${e.toString()}');
    }
  }


  @override
  Future<String> getIdCardImagePath() {
    return userLocalDataSource.getIdCardImagePath();
  }
}
