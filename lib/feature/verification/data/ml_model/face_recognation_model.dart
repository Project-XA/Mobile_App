import 'package:mobile_app/feature/scan_OCR/data/model/ml_models/base_model.dart';

class FaceRecognationModel extends BaseModel {
  static final FaceRecognationModel _instance =
      FaceRecognationModel._internal();
  factory FaceRecognationModel() => _instance;
  FaceRecognationModel._internal();
  @override
  String get modelPath => 'assets/models/facenet.tflite';
}
