import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:mobile_app/feature/verification/data/ml_model/face_recognation_model.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class FaceRecognitionService {
  final FaceRecognationModel _model = FaceRecognationModel();
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableLandmarks: true,
      enableClassification: true,
      performanceMode: FaceDetectorMode.accurate,
    ),
  );

  bool _isInitialized = false;

  /// Initialize the service
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    await _model.loadModel();
    _isInitialized = true;
  }

  /// Extract face embedding from image
  Future<List<double>> extractFaceEmbedding(String imagePath) async {
    if (!_isInitialized) {
      throw Exception('FaceRecognitionService not initialized');
    }

    // 1. Load image
    final imageFile = File(imagePath);
    final inputImage = InputImage.fromFile(imageFile);

    // 2. Detect face using ML Kit
    final faces = await _faceDetector.processImage(inputImage);
    
    if (faces.isEmpty) {
      throw Exception('No face detected in image');
    }

    final face = faces.first;
    
    final croppedFace = await _cropFace(imagePath, face.boundingBox);
    
    // 5. Preprocess image for model (resize to 112x112)
    final processedImage = _preprocessImage(croppedFace);
    
    // 6. Run inference
    final embedding = _runInference(processedImage);
    
    return embedding;
  }

  /// Crop face from image using bounding box
  Future<img.Image> _cropFace(String imagePath, Rect boundingBox) async {
    final imageFile = File(imagePath);
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);
    
    if (image == null) {
      throw Exception('Failed to decode image');
    }

    // Add padding to bounding box (20%)
    const padding = 0.2;
    final expandedBox = Rect.fromLTRB(
      (boundingBox.left - boundingBox.width * padding).clamp(0.0, image.width.toDouble()),
      (boundingBox.top - boundingBox.height * padding).clamp(0.0, image.height.toDouble()),
      (boundingBox.right + boundingBox.width * padding).clamp(0.0, image.width.toDouble()),
      (boundingBox.bottom + boundingBox.height * padding).clamp(0.0, image.height.toDouble()),
    );

    final cropped = img.copyCrop(
      image,
      x: expandedBox.left.toInt(),
      y: expandedBox.top.toInt(),
      width: expandedBox.width.toInt(),
      height: expandedBox.height.toInt(),
    );

    return cropped;
  }

  /// Preprocess image for FaceNet model
  List<List<List<List<double>>>> _preprocessImage(img.Image image) {
    // Resize to 112x112
    final resized = img.copyResize(
      image,
      width: 112,
      height: 112,
      interpolation: img.Interpolation.linear,
    );

    // Ensure RGB format
    final rgbImage = resized.convert(numChannels: 3);

    // Normalize pixels to [-1, 1] range
    List<List<List<List<double>>>> input = List.generate(
      1,
      (_) => List.generate(
        112,
        (y) => List.generate(
          112,
          (x) {
            final pixel = rgbImage.getPixel(x, y);
            
            // Extract RGB values (0-255 range)
            final r = pixel.r.toDouble();
            final g = pixel.g.toDouble();
            final b = pixel.b.toDouble();
            
            return [
              (r / 127.5) - 1.0, // R normalized to [-1, 1]
              (g / 127.5) - 1.0, // G normalized to [-1, 1]
              (b / 127.5) - 1.0, // B normalized to [-1, 1]
            ];
          },
        ),
      ),
    );

    return input;
  }

  /// Run model inference
  List<double> _runInference(List<List<List<List<double>>>> input) {
    // Output shape: [1, 512]
    var output = List.filled(512, 0.0).reshape([1, 512]);
    
    final interpreter = Interpreter.fromAddress(_model.interpreterAddress);
    interpreter.run(input, output);

    return output[0];
  }

  /// Compare two face embeddings
  double compareFaces(List<double> embedding1, List<double> embedding2) {
    if (embedding1.length != embedding2.length) {
      throw Exception('Embeddings must have same length');
    }

    // Calculate Euclidean distance
    double sum = 0.0;
    for (int i = 0; i < embedding1.length; i++) {
      sum += (embedding1[i] - embedding2[i]) * (embedding1[i] - embedding2[i]);
    }
    
    return sqrt(sum);
  }

  /// Verify if two faces match
  Future<bool> verifyFaces({
    required String imagePath1,
    required String imagePath2,
    double threshold = 1.0, // Adjust based on testing
  }) async {
    final embedding1 = await extractFaceEmbedding(imagePath1);
    final embedding2 = await extractFaceEmbedding(imagePath2);
    
    final distance = compareFaces(embedding1, embedding2);
    
    // Lower distance = more similar
    return distance < threshold;
  }

  /// Dispose resources
  void dispose() {
    _faceDetector.close();
    _model.dispose();
    _isInitialized = false;
  }
}