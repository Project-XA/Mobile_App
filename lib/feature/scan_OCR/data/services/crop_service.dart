import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:mobile_app/feature/scan_OCR/data/model/bounding_box.dart';
import 'package:mobile_app/feature/scan_OCR/data/model/cropped_field.dart';
import 'package:mobile_app/feature/scan_OCR/data/model/detection_model.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class CropService {
  static Future<List<CroppedField>> cropFields({
    required String originalImagePath,
    required List<DetectionModel> detections,
  }) async {
    try {
      // Load original image
      final imageBytes = await File(originalImagePath).readAsBytes();
      final originalImage = img.decodeImage(imageBytes);
      
      if (originalImage == null) {
        throw Exception("Failed to decode image");
      }

      final originalWidth = originalImage.width;
      final originalHeight = originalImage.height;

      List<CroppedField> croppedFields = [];

      for (var detection in detections) {
        // Convert normalized coordinates (0-1) to pixel coordinates
        final x1 = ((detection.x - detection.width / 2) * originalWidth).toInt().clamp(0, originalWidth);
        final y1 = ((detection.y - detection.height / 2) * originalHeight).toInt().clamp(0, originalHeight);
        final x2 = ((detection.x + detection.width / 2) * originalWidth).toInt().clamp(0, originalWidth);
        final y2 = ((detection.y + detection.height / 2) * originalHeight).toInt().clamp(0, originalHeight);

        final cropWidth = x2 - x1;
        final cropHeight = y2 - y1;

        if (cropWidth <= 0 || cropHeight <= 0) continue;

        // Crop the field
        final croppedImage = img.copyCrop(
          originalImage,
          x: x1,
          y: y1,
          width: cropWidth,
          height: cropHeight,
        );

        // Save cropped image
        final croppedPath = await _saveCroppedImage(
          croppedImage,
          detection.className,
        );

        croppedFields.add(CroppedField(
          fieldName: detection.className,
          confidence: detection.confidence,
          imagePath: croppedPath,
          bbox: BoundingBox(x1: x1, y1: y1, x2: x2, y2: y2),
        ));

        print("✂️ Cropped: ${detection.className} → $croppedPath");
      }

      return croppedFields;
    } catch (e) {
      print("❌ Error cropping fields: $e");
      return [];
    }
  }

  static Future<String> _saveCroppedImage(
    img.Image image,
    String fieldName,
  ) async {
    final directory = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = '${fieldName}_$timestamp.jpg';
    final filePath = path.join(directory.path, fileName);

    final imageBytes = img.encodeJpg(image);
    await File(filePath).writeAsBytes(imageBytes);

    return filePath;
  }
}


