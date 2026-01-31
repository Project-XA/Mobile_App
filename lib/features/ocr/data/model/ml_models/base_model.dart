
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:mobile_app/features/ocr/data/exceptions/ocr_exceptions.dart';

abstract class BaseModel {
  Interpreter? _interpreter;
  bool _isLoaded = false;

  /// Path to the model file
  String get modelPath;

  BaseModel();

  /// Load the TFLite model
  Future<void> loadModel() async {
    if (_isLoaded && _interpreter != null) return;

    try {
      _interpreter = await Interpreter.fromAsset(modelPath);
      _isLoaded = true;
    } catch (e) {
      throw ModelLoadException(modelPath, e);
    }
  }
    Interpreter? get interpreter => _interpreter;

  /// Get input tensor shape
  List<int> getInputShape() {
    _ensureLoaded();
    return _interpreter!.getInputTensor(0).shape;
  }

  /// Get output tensor shape
  List<int> getOutputShape() {
    _ensureLoaded();
    return _interpreter!.getOutputTensor(0).shape;
  }

  /// Get interpreter memory address for isolate use
  int get interpreterAddress {
    _ensureLoaded();
    return _interpreter!.address;
  }

  /// Check if model is loaded
  bool get isLoaded => _isLoaded && _interpreter != null;

  /// Dispose the interpreter
  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _isLoaded = false;
  }

  /// Ensure model is loaded before use
  void _ensureLoaded() {
    if (!_isLoaded || _interpreter == null) {
      throw ModelNotLoadedException('Model not loaded: $modelPath');
    }
  }
}