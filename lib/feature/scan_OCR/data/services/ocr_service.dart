import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:mobile_app/tesseract_ocr/lib/android_ios.dart';
import 'package:path_provider/path_provider.dart';

class OcrService {
  static bool _isInitialized = false;

  /// Initialize Tesseract (call once at app start)
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      print("🔄 [OCR] Initializing Tesseract...");

      final appDir = await getApplicationDocumentsDirectory();
      final tessdataDir = Directory('${appDir.path}/tessdata');

      if (!await tessdataDir.exists()) {
        await tessdataDir.create(recursive: true);
      }

      // Copy all traineddata files
      final files = [
        'ara.traineddata',
        'eng.traineddata',
        'ara_combined.traineddata',
        'ara_number.traineddata',
      ];

      for (final file in files) {
        final targetFile = File('${tessdataDir.path}/$file');
        if (!await targetFile.exists()) {
          print("📥 [OCR] Copying $file...");
          final data = await rootBundle.load('assets/tessdata/$file');
          await targetFile.writeAsBytes(
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
          );
          print("✅ [OCR] $file copied");
        }
      }

      _isInitialized = true;
      print("✅ [OCR] Tesseract initialized successfully");
    } catch (e) {
      print("❌ [OCR] Initialization failed: $e");
      throw Exception('Failed to initialize OCR: $e');
    }
  }

  /// Extract text from image (supports Arabic & English)
  static Future<String> extractText({
    required File imageFile,
    String language = 'ara', // 'ara', 'eng', 'ara_combined', 'ara_number'
    bool preprocessImage = true,
  }) async {
    try {
      // Ensure initialized
      if (!_isInitialized) {
        await initialize();
      }

      print("🔍 [OCR] Extracting text from: ${imageFile.path}");
      print("🌐 [OCR] Language: $language");

      File processedFile = imageFile;

      // Preprocess if needed
      if (preprocessImage) {
        print("🖼️ [OCR] Preprocessing image...");
        processedFile = await _preprocessImage(imageFile);
      }

      // Extract text
      final text = await FlutterTesseractOcr.extractText(
        processedFile.path,
        language: language,
        args: {
          'psm': '6', // Assume uniform block of text (good for ID cards)
          'preserve_interword_spaces': '1',
        },
      );

      print(
        "📝 [OCR] Extracted text: ${text.substring(0, text.length > 50 ? 50 : text.length)}...",
      );

      if (text.trim().isEmpty) {
        throw Exception('No text found in image');
      }

      // Cleanup processed file if it's temporary
      if (preprocessImage && processedFile.path != imageFile.path) {
        await processedFile.delete();
      }

      return text.trim();
    } catch (e) {
      print("❌ [OCR] Error extracting text: $e");
      throw Exception('Failed to extract text: $e');
    }
  }

  /// Preprocess image for better OCR results
  static Future<File> _preprocessImage(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final original = img.decodeImage(bytes);

      if (original == null) {
        throw Exception("Failed to decode image");
      }

      // Apply preprocessing steps
      var processed = original;

      // 1. Convert to grayscale
      processed = img.grayscale(processed);

      // 2. Increase contrast
      processed = img.adjustColor(processed, contrast: 1.5);

      // 3. Apply slight blur to reduce noise
      processed = img.gaussianBlur(processed, radius: 1);

      // 4. Normalize brightness
      processed = img.normalize(processed, min: 0, max: 255);

      // Save processed image
      final dir = await getTemporaryDirectory();
      final processedPath =
          '${dir.path}/ocr_processed_${DateTime.now().millisecondsSinceEpoch}.png';
      final processedFile = File(processedPath);
      await processedFile.writeAsBytes(img.encodePng(processed));

      print("✅ [OCR] Image preprocessed: $processedPath");

      return processedFile;
    } catch (e) {
      print("❌ [OCR] Preprocessing failed: $e");
      throw Exception('Image preprocessing failed: $e');
    }
  }

  /// Extract text from multiple images (for batch processing)
  static Future<Map<String, String>> extractTextFromMultipleImages({
    required List<File> images,
    String language = 'ara',
    bool preprocessImage = true,
  }) async {
    Map<String, String> results = {};

    for (var i = 0; i < images.length; i++) {
      try {
        print("\n📄 [OCR] Processing image ${i + 1}/${images.length}");
        final text = await extractText(
          imageFile: images[i],
          language: language,
          preprocessImage: preprocessImage,
        );
        results[images[i].path] = text;
      } catch (e) {
        print("❌ [OCR] Failed to process image ${i + 1}: $e");
        results[images[i].path] = '';
      }
    }

    return results;
  }
}
