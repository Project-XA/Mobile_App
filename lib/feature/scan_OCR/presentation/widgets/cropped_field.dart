import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/feature/scan_OCR/data/model/cropped_field.dart';

class CroppedFieldsViewer extends StatelessWidget {
  final List<CroppedField> croppedFields;
  final Map<String, String>? extractedText;
  const CroppedFieldsViewer({
    super.key,
    required this.croppedFields,
    this.extractedText,
  });

  @override
  Widget build(BuildContext context) {
    if (croppedFields.isEmpty) {
      return const Center(child: Text("No fields detected"));
    }

    final validFields = croppedFields
        .where((f) => !f.fieldName.startsWith('invalid_'))
        .toList();
    final invalidFields = croppedFields
        .where((f) => f.fieldName.startsWith('invalid_'))
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (validFields.isNotEmpty) ...[
            const Text(
              "✅ Valid Fields",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            ...validFields.map((field) => _buildFieldCard(field)),
            const SizedBox(height: 24),
          ],
          if (invalidFields.isNotEmpty) ...[
            const Text(
              "❌ Invalid Fields",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            ...invalidFields.map((field) => _buildFieldCard(field)),
          ],
        ],
      ),
    );
  }

  Widget _buildFieldCard(CroppedField field) {
    final extractedValue = extractedText?[field.fieldName]; // ✅ جديد

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  field.fieldName.toUpperCase().replaceAll('INVALID_', ''),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: field.fieldName.startsWith('invalid_')
                        ? Colors.red.shade100
                        : Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "${(field.confidence * 100).toStringAsFixed(1)}%",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: field.fieldName.startsWith('invalid_')
                          ? Colors.red.shade700
                          : Colors.green.shade700,
                    ),
                  ),
                ),
              ],
            ),
            verticalSpace(8),

            if (extractedValue != null && extractedValue.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "📝 Extracted Text:",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      extractedValue,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            Text(
              "BBox: [${field.bbox.x1}, ${field.bbox.y1}] → [${field.bbox.x2}, ${field.bbox.y2}]",
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(field.imagePath),
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 100,
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(Icons.error, color: Colors.red),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
