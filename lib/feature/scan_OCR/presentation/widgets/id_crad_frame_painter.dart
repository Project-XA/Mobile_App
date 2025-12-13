
import 'package:flutter/material.dart';

class IdCardFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final cardWidth = size.width * 0.85;
    final cardHeight = cardWidth / 1.586;

    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: cardWidth,
      height: cardHeight,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      paint,
    );
    final cornerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;

    const cornerLength = 20.0;

    // Top-left corner
    canvas.drawLine(
      rect.topLeft,
      rect.topLeft + const Offset(cornerLength, 0),
      cornerPaint,
    );
    canvas.drawLine(
      rect.topLeft,
      rect.topLeft + const Offset(0, cornerLength),
      cornerPaint,
    );

    canvas.drawLine(
      rect.topRight,
      rect.topRight + const Offset(-cornerLength, 0),
      cornerPaint,
    );
    canvas.drawLine(
      rect.topRight,
      rect.topRight + const Offset(0, cornerLength),
      cornerPaint,
    );

    canvas.drawLine(
      rect.bottomLeft,
      rect.bottomLeft + const Offset(cornerLength, 0),
      cornerPaint,
    );
    canvas.drawLine(
      rect.bottomLeft,
      rect.bottomLeft + const Offset(0, -cornerLength),
      cornerPaint,
    );

    // Bottom-right corner
    canvas.drawLine(
      rect.bottomRight,
      rect.bottomRight + const Offset(-cornerLength, 0),
      cornerPaint,
    );
    canvas.drawLine(
      rect.bottomRight,
      rect.bottomRight + const Offset(0, -cornerLength),
      cornerPaint,
    );

    final centerLinePaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(size.width / 2, rect.top),
      Offset(size.width / 2, rect.bottom),
      centerLinePaint,
    );

    canvas.drawLine(
      Offset(rect.left, size.height / 2),
      Offset(rect.right, size.height / 2),
      centerLinePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}