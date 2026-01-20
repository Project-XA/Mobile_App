// ignore_for_file: avoid_slow_async_io

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:mobile_app/feature/scan_OCR/data/constant/ocr_constants.dart';
import 'package:mobile_app/tesseract_ocr/lib/android_ios.dart';
import 'package:path_provider/path_provider.dart';

class OcrService {
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final appDir = await getApplicationDocumentsDirectory();
      final tessdataDir = Directory('${appDir.path}/tessdata');

      if (!await tessdataDir.exists()) {
        await tessdataDir.create(recursive: true);
      }

      for (final file in OcrConstants.tessdataFiles) {
        final targetFile = File('${tessdataDir.path}/$file');

        if (!await targetFile.exists()) {
          final data = await rootBundle.load('assets/tessdata/$file');
          await targetFile.writeAsBytes(
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
          );
        }
      }

      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to initialize OCR: $e');
    }
  }

  static Future<String> extractText({
    required File imageFile,
    String language = OcrConstants.arabicLanguage,
    bool preprocessImage = true,
  }) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      File processedFile = imageFile;

      if (preprocessImage) {
        processedFile = await _preprocessImage(imageFile);
      }

      final text = await FlutterTesseractOcr.extractText(
        processedFile.path,
        language: language,
        args: {
          'psm': OcrConstants.defaultPsmMode,
          'preserve_interword_spaces': '1',
        },
      );

      if (text.trim().isEmpty) {
        return '';
      }

      if (preprocessImage && processedFile.path != imageFile.path) {
        await processedFile.delete();
      }

      return text.trim();
    } catch (e) {
      throw Exception('Failed to extract text: $e');
    }
  }

  static Future<File> _preprocessImage(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final original = img.decodeImage(bytes);

      if (original == null) {
        throw Exception("Failed to decode image");
      }

      var processed = original;

      processed = img.grayscale(processed);
      processed = img.adjustColor(processed, contrast: 1.5);
      processed = img.gaussianBlur(processed, radius: 1);
      processed = img.normalize(processed, min: 0, max: 255);

      final dir = await getTemporaryDirectory();
      final processedPath =
          '${dir.path}/ocr_processed_${DateTime.now().millisecondsSinceEpoch}.png';

      final processedFile = File(processedPath);
      await processedFile.writeAsBytes(img.encodePng(processed));

      return processedFile;
    } catch (e) {
      throw Exception('Image preprocessing failed: $e');
    }
  }

  static Future<Map<String, String>> extractTextFromMultipleImages({
    required List<File> images,
    String language = OcrConstants.arabicLanguage,
    bool preprocessImage = true,
  }) async {
    const Map<String, String> results = {};

    for (var i = 0; i < images.length; i++) {
      try {
        final text = await extractText(
          imageFile: images[i],
          language: language,
          preprocessImage: preprocessImage,
        );
        results[images[i].path] = text;
      } catch (e) {
        results[images[i].path] = '';
      }
    }

    return results;
  }
}
