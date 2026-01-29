import 'dart:isolate';
import 'dart:typed_data';
import 'package:mobile_app/features/ocr/data/model/digital_detection.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'image_processing_service.dart';

class DigitRecognitionService {
  static Future<String> extractDigits({
    required String imagePath,
    required int interpreterAddress,
    double confidenceThreshold = 0.1,
  }) async {
    final receivePort = ReceivePort();

    await Isolate.spawn(
      _digitRecognitionIsolate,
      _DigitRecognitionData(
        sendPort: receivePort.sendPort,
        imagePath: imagePath,
        interpreterAddress: interpreterAddress,
        confidenceThreshold: confidenceThreshold,
      ),
    );

    final result = await receivePort.first as String;

    return result;
  }

  static void _digitRecognitionIsolate(_DigitRecognitionData data) async {
    try {
      final inputBytes = ImageProcessingService.preprocessImage(
        data.imagePath,
        targetWidth: 640,
        targetHeight: 640,
      );

      final interpreter = Interpreter.fromAddress(data.interpreterAddress);

      final output = _runInference(interpreter, inputBytes);

      final digits = _processOutput(
        output,
        confidenceThreshold: data.confidenceThreshold,
      );

      data.sendPort.send(digits);
    } catch (e) {
      data.sendPort.send('');
    }
  }

  static List _runInference(Interpreter interpreter, Float32List inputBytes) {
    final input = inputBytes.reshape([1, 640, 640, 3]);

    final outputBytes = Float32List(1 * 14 * 8400);
    final output = outputBytes.reshape([1, 14, 8400]);

    interpreter.run(input, output);

    return output;
  }

  static String _processOutput(
    List output, {
    required double confidenceThreshold,
  }) {
    List<DigitDetection> detections = [];
   // int totalAboveThreshold = 0;

    for (int i = 0; i < 8400; i++) {
      final x = output[0][0][i] as double;
      final y = output[0][1][i] as double;
      final w = output[0][2][i] as double;
      final h = output[0][3][i] as double;

      double maxConfidence = 0.0;
      int bestDigit = -1;

      // Check all 10 digit classes (0-9)
      for (int digitIdx = 0; digitIdx < 10; digitIdx++) {
        final confidence = output[0][4 + digitIdx][i] as double;
        if (confidence > maxConfidence) {
          maxConfidence = confidence;
          bestDigit = digitIdx;
        }
      }

      if (maxConfidence > confidenceThreshold && bestDigit != -1) {
      //  totalAboveThreshold++;

        detections.add(
          DigitDetection(
            digit: bestDigit,
            confidence: maxConfidence,
            x: x,
            y: y,
            width: w,
            height: h,
          ),
        );
      }
    }

    detections = _applyNMS(detections, iouThreshold: 0.5);

    detections.sort((a, b) => a.x.compareTo(b.x));

    final result = detections.map((d) => d.digit.toString()).join();

    return result;
  }

  static List<DigitDetection> _applyNMS(
    List<DigitDetection> detections, {
    double iouThreshold = 0.5,
  }) {
    detections.sort((a, b) => b.confidence.compareTo(a.confidence));
    List<DigitDetection> result = [];

    while (detections.isNotEmpty) {
      final best = detections.removeAt(0);
      result.add(best);

      detections.removeWhere((detection) {
        if (detection.digit != best.digit) return false;

        final iou = _calculateIOU(best, detection);
        return iou > iouThreshold;
      });
    }

    return result;
  }

  static double _calculateIOU(DigitDetection a, DigitDetection b) {
    final x1A = a.x - a.width / 2;
    final y1A = a.y - a.height / 2;
    final x2A = a.x + a.width / 2;
    final y2A = a.y + a.height / 2;

    final x1B = b.x - b.width / 2;
    final y1B = b.y - b.height / 2;
    final x2B = b.x + b.width / 2;
    final y2B = b.y + b.height / 2;

    final x1Inter = x1A > x1B ? x1A : x1B;
    final y1Inter = y1A > y1B ? y1A : y1B;
    final x2Inter = x2A < x2B ? x2A : x2B;
    final y2Inter = y2A < y2B ? y2A : y2B;

    if (x2Inter <= x1Inter || y2Inter <= y1Inter) return 0.0;

    final interArea = (x2Inter - x1Inter) * (y2Inter - y1Inter);
    final areaA = a.width * a.height;
    final areaB = b.width * b.height;

    return interArea / (areaA + areaB - interArea);
  }
}

class _DigitRecognitionData {
  final SendPort sendPort;
  final String imagePath;
  final int interpreterAddress;
  final double confidenceThreshold;

  _DigitRecognitionData({
    required this.sendPort,
    required this.imagePath,
    required this.interpreterAddress,
    required this.confidenceThreshold,
  });
}