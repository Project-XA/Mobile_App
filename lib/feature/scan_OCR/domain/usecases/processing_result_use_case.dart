import 'package:mobile_app/feature/scan_OCR/data/model/cropped_field.dart';

class CardProcessingResult {
  final List<CroppedField> croppedFields;
  final Map<String, String> finalData;

  CardProcessingResult({
    required this.croppedFields,
    required this.finalData,
  });
}