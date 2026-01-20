import 'package:camera/camera.dart';
import 'package:mobile_app/core/services/camera_permission_service.dart';
import 'package:mobile_app/feature/scan_OCR/data/model/ml_models/card_service_model.dart';
import 'package:mobile_app/feature/scan_OCR/data/model/ml_models/id_service_model.dart';
import 'package:mobile_app/feature/scan_OCR/data/model/ml_models/field_service_model.dart';
import 'package:mobile_app/feature/scan_OCR/data/model/cropped_field.dart';
import 'package:mobile_app/feature/scan_OCR/data/model/detection_model.dart';
import 'package:mobile_app/feature/scan_OCR/data/services/field_processing_service.dart';
import 'package:mobile_app/feature/scan_OCR/data/services/object_detect_service.dart';
import 'package:mobile_app/feature/scan_OCR/data/services/crop_service.dart';
import 'package:mobile_app/feature/scan_OCR/data/services/ocr_service.dart';
import 'package:mobile_app/feature/scan_OCR/data/services/inference_service.dart';
import 'package:mobile_app/feature/scan_OCR/domain/repo/camera_repo.dart';
import 'package:mobile_app/feature/scan_OCR/domain/usecases/captured_photo.dart';

class CameraRepImp implements CameraRepository {
  CameraController? _controller;
  bool _isCameraInitialized = false;

  late final CardServiceModel _cardModel;
  late final FieldServiceModel _fieldModel;
  late final IdServiceModel _idModel;

  // Helper service for field processing
  late final FieldProcessingService _fieldProcessingService;

  final CameraPermissionService _permissionService;

  CameraRepImp({CameraPermissionService? permissionService})
    : _permissionService = permissionService ?? CameraPermissionService() {
    _cardModel = CardServiceModel();
    _fieldModel = FieldServiceModel();
    _idModel = IdServiceModel();
    _fieldProcessingService = FieldProcessingService(_idModel);
  }

  // ========== Camera Operations ==========
  @override
  Future<void> openCamera() async {
    // Check camera permission first
    final hasPermission = await _permissionService.isCameraPermissionGranted();

    if (!hasPermission) {
      // Request permission
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

    final backCamera = cameras.first;

    _controller = CameraController(
      backCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller!.initialize();
    _isCameraInitialized = true;

    await Future.wait([_cardModel.loadModel(), OcrService.initialize()]);
  }

  @override
  Future<void> closeCamera() async {
    await _controller?.dispose();
    _controller = null;
    _isCameraInitialized = false;
  }

  @override
  Future<CapturedPhoto> capturePhoto() async {
    _ensureCameraInitialized();
    //  await _stopCameraStream();
    final file = await _controller!.takePicture();
    return CapturedPhoto(path: file.path);
  }

  @override
  Future<bool> isCard(CapturedPhoto photo) async {
    await _ensureModelLoaded(_cardModel);

    final result = await InferenceService.detectCard(
      imagePath: photo.path,
      interpreterAddress: _cardModel.interpreterAddress,
      confidenceThreshold: 0.3,
    );

    return result.isCardDetected;
  }

  @override
  Future<List<DetectionModel>> detectFields(CapturedPhoto photo) async {
    await _ensureModelLoaded(_fieldModel);

    return await ObjectDetectionService.detectFields(
      imagePath: photo.path,
      interpreterAddress: _fieldModel.interpreterAddress,
      confidenceThreshold: 0.5,
    );
  }

  @override
  Future<List<CroppedField>> cropDetectedFields(
    CapturedPhoto photo,
    List<DetectionModel> detections,
  ) async {
    return await CropService.cropFields(
      originalImagePath: photo.path,
      detections: detections,
    );
  }

  @override
  Future<Map<String, String>> extractTextFromFields(
    List<CroppedField> croppedFields,
  ) async {
    return await _fieldProcessingService.extractText(croppedFields);
  }

  @override
  Future<Map<String, String>> extractFinalData(
    List<CroppedField> croppedFields,
  ) async {
    await _ensureModelLoaded(_idModel);
    return await _fieldProcessingService.extractFinalData(croppedFields);
  }

  // ========== Private Helpers ==========
  void _ensureCameraInitialized() {
    if (_controller == null || !_isCameraInitialized) {
      throw Exception("Camera not initialized");
    }
  }

  // Future<void> _stopCameraStream() async {
  //   try {
  //     await _controller?.stopImageStream();
  //     await _controller?.pausePreview();
  //   } catch (_) {}
  // }

  Future<void> _ensureModelLoaded(dynamic model) async {
    if (!model.isLoaded) {
      await model.loadModel();
    }
  }

  @override
  CameraController? get controller => _controller;
}

/// Custom exception for camera permission errors
class CameraPermissionException implements Exception {
  final String message;
  CameraPermissionException(this.message);

  @override
  String toString() => message;
}
