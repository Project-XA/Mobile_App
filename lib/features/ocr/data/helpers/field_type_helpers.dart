class FieldTypeHelper {
  // ========== Field Categories ==========
  
  static const List<String> _numericFields = [
    'serial',
    'dob',
    'expiry',
    'issue',
  ];

  static const List<String> _invalidPrefixes = [
    'invalid_',
  ];

static bool isPhotoField(String fieldName) {
    final lowerName = fieldName.toLowerCase();
    return lowerName.contains('photo') ||
           lowerName.contains('image') ||
           lowerName.contains('picture') ||
           lowerName.contains('face') ||
           lowerName.contains('portrait') ||
           lowerName == 'صورة' ||
           lowerName == 'صوره';
  }
  // ========== Validation Methods ==========

  static bool isInvalidField(String fieldName) {
    return _invalidPrefixes.any((prefix) => fieldName.startsWith(prefix));
  }

  static bool isNumericField(String fieldName) {
    return _numericFields.any((field) => fieldName.contains(field));
  }

  static bool isNIDField(String fieldName) {
    return fieldName == 'nid';
  }

  // ========== Type Detection ==========

  static String getFieldType(String fieldName) {
    if (isNIDField(fieldName)) return 'nid';
    if (isNumericField(fieldName)) return 'model3';
    return 'text';
  }

  static String getLanguageForField(String fieldName) {
    return isNumericField(fieldName) ? 'ara_number' : 'ara';
  }

  // ========== Processing Decision ==========

  static bool shouldUseDigitRecognition(String fieldName) {
    final fieldType = getFieldType(fieldName);
    return fieldType == 'nid' || fieldType == 'model3';
  }

  static bool shouldUseOCR(String fieldName) {
    return !shouldUseDigitRecognition(fieldName);
  }
}
