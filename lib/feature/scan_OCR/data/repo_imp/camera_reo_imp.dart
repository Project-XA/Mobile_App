import 'package:camera/camera.dart';
import 'package:mobile_app/feature/scan_OCR/domain/repo/camera_repo.dart';
import 'package:mobile_app/feature/scan_OCR/domain/usecases/captured_photo.dart';

class CameraRepImp implements CameraRepository {
  CameraController? _controller;
  bool _isCameraInitialized = false;

  @override
  Future<void> openCamera() async {
    final cameras = await availableCameras();
    final backCamera = cameras.first;
    _controller = CameraController(backCamera, ResolutionPreset.medium, enableAudio: false);
    await _controller!.initialize();
    _isCameraInitialized = true;
  }

  @override
  Future<CapturedPhoto> capturePhoto() async {
    if (_controller == null || !_isCameraInitialized) {
      throw Exception("Camera not initialized");
    }
    final file = await _controller!.takePicture();
    return CapturedPhoto(path: file.path);
  }

  CameraController? get controller => _controller;
}
