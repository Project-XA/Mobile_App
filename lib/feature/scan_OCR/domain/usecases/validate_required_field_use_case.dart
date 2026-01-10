import 'package:mobile_app/feature/scan_OCR/data/model/detection_model.dart';

class ValidateRequiredFieldsUseCase {
  static const List<String> _requiredLabels = [
    'photo',        
    'firstName',   
    'lastName',    
  ];

  static const List<String> _invalidLabels = [
    'invalid_address',
    'invalid_barcode',
    'invalid_demo',
    'invalid_dob',
    'invalid_expiry',
    'invalid_firstName',
    'invalid_issue',
    'invalid_job',
    'invalid_lastName',
    'invalid_logo',
    'invalid_nid',
    'invalid_nid_back',
    'invalid_photo',
    'invalid_poe',
    'invalid_serial',
    'invalid_watermark_tut',
  ];

  /// التحقق من وجود جميع الـ fields المطلوبة
  /// Returns true إذا كانت كل الـ fields موجودة وصحيحة
  Future<ValidationResult> execute(List<DetectionModel> detections) async {
    try {
      // التحقق من وجود detections
      if (detections.isEmpty) {
        return ValidationResult(
          isValid: false,
          missingFields: _requiredLabels,
          reason: 'No fields detected',
        );
      }

      // التحقق من عدم وجود invalid labels
      final invalidDetections = detections
          .where((d) => _invalidLabels.contains(d.className))
          .toList();

      if (invalidDetections.isNotEmpty) {
        return ValidationResult(
          isValid: false,
          invalidFields: invalidDetections.map((d) => d.className).toList(),
          reason: 'Invalid fields detected: ${invalidDetections.map((d) => d.className).join(", ")}',
        );
      }

      final detectedLabels = detections
          .map((detection) => detection.className)
          .toSet();

      final missingLabels = _requiredLabels
          .where((label) => !detectedLabels.contains(label))
          .toList();

      if (missingLabels.isNotEmpty) {
        print('❌ Missing required labels: $missingLabels');
        print('📋 Detected labels: $detectedLabels');
        
        return ValidationResult(
          isValid: false,
          missingFields: missingLabels,
          detectedFields: detectedLabels.toList(),
          reason: 'Missing required fields: ${missingLabels.join(", ")}',
        );
      }

      // التحقق من الـ confidence للـ required labels
      final lowConfidenceFields = <String>[];
      
      for (final requiredLabel in _requiredLabels) {
        final detection = detections.firstWhere(
          (d) => d.className == requiredLabel,
        );

        if (detection.confidence < 0.5) {
          lowConfidenceFields.add(
            '$requiredLabel (${(detection.confidence * 100).toStringAsFixed(1)}%)',
          );
        }
      }

      if (lowConfidenceFields.isNotEmpty) {
        print('⚠️ Low confidence fields: $lowConfidenceFields');
        
        return ValidationResult(
          isValid: false,
          lowConfidenceFields: lowConfidenceFields,
          reason: 'Low confidence in fields: ${lowConfidenceFields.join(", ")}',
        );
      }

      print('✅ All required fields detected successfully');
      print('📋 Detected fields: $detectedLabels');
      
      return ValidationResult(
        isValid: true,
        detectedFields: detectedLabels.toList(),
        reason: 'All required fields detected',
      );

    } catch (e) {
      print('❌ Error validating fields: $e');
      return ValidationResult(
        isValid: false,
        reason: 'Validation error: $e',
      );
    }
  }
}

/// نتيجة التحقق من الـ fields
class ValidationResult {
  final bool isValid;
  final List<String>? missingFields;
  final List<String>? invalidFields;
  final List<String>? lowConfidenceFields;
  final List<String>? detectedFields;
  final String reason;

  ValidationResult({
    required this.isValid,
    this.missingFields,
    this.invalidFields,
    this.lowConfidenceFields,
    this.detectedFields,
    required this.reason,
  });

  @override
  String toString() {
    return 'ValidationResult(isValid: $isValid, reason: $reason)';
  }
}