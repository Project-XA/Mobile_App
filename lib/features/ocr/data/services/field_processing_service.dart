import 'dart:io';
import 'package:mobile_app/features/ocr/data/helpers/field_type_helpers.dart';
import 'package:mobile_app/features/ocr/data/model/cropped_field.dart';
import 'package:mobile_app/features/ocr/data/model/ml_models/id_service_model.dart';
import 'package:mobile_app/features/ocr/data/services/digital_recognition_service.dart';
import 'package:mobile_app/features/ocr/data/services/ocr_service.dart';

class FieldProcessingService {
  final IdServiceModel _idModel;

  FieldProcessingService(this._idModel);

  Future<Map<String, String>> extractText(
    List<CroppedField> croppedFields,
  ) async {
    final results = <String, String>{};

    for (final field in croppedFields) {
      if (FieldTypeHelper.isInvalidField(field.fieldName)) continue;

      try {
        final language = FieldTypeHelper.getLanguageForField(field.fieldName);
        final text = await _extractWithOCR(field.imagePath, language);
        results[field.fieldName] = text;
      } catch (e) {
        results[field.fieldName] = '';
      }
    }

    return results;
  }

  Future<Map<String, String>> extractFinalData(
    List<CroppedField> croppedFields,
  ) async {
    final results = <String, String>{};

    for (final field in croppedFields) {
      if (FieldTypeHelper.isPhotoField(field.fieldName)) {
        results['photo'] = field.imagePath; 
        continue;
      }

      if (FieldTypeHelper.isInvalidField(field.fieldName)) continue;

      try {
        final fieldType = FieldTypeHelper.getFieldType(field.fieldName);
        final text = await _extractByFieldType(field.imagePath, fieldType);
        results[field.fieldName] = text;
      } catch (e) {
        results[field.fieldName] = '';
      }
    }

    return results;
  }

  Future<String> _extractByFieldType(String imagePath, String fieldType) async {
    if (FieldTypeHelper.shouldUseDigitRecognition(fieldType)) {
      return await DigitRecognitionService.extractDigits(
        imagePath: imagePath,
        interpreterAddress: _idModel.interpreterAddress,
        confidenceThreshold: 0.1,
      );
    } else {
      return await _extractWithOCR(imagePath, 'ara');
    }
  }

  Future<String> _extractWithOCR(String imagePath, String language) async {
    return await OcrService.extractText(
      imageFile: File(imagePath),
      language: language,
      preprocessImage: true,
    );
  }
}