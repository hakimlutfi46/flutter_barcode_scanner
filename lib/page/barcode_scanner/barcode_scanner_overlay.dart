import 'package:flutter/material.dart';

class BarcodeScannerOverlayPainter extends CustomPainter {
  final double borderRadius;

  BarcodeScannerOverlayPainter({this.borderRadius = 0});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint overlayPaint = Paint()
      ..color = Colors.black.withOpacity(0.7) 
      ..style = PaintingStyle.fill;

    final Paint cornerPaint = Paint()
      ..color = Colors.white 
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final double scanBoxWidth = 260;
    final double scanBoxHeight = 150;
    final double cornerLength = 20; 
    final Offset scanBoxTopLeft = Offset(
      (size.width - scanBoxWidth) / 2,
      (size.height - scanBoxHeight) / 2,
    );

    final Rect scanBoxRect = Rect.fromLTWH(
      scanBoxTopLeft.dx,
      scanBoxTopLeft.dy,
      scanBoxWidth,
      scanBoxHeight,
    );

    final RRect roundedScanBox =
        RRect.fromRectAndRadius(scanBoxRect, Radius.circular(borderRadius));

    final Path backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(roundedScanBox)
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(backgroundPath, overlayPaint);

    // Menggambar garis sudut
    drawCorner(canvas, scanBoxTopLeft, cornerLength, cornerPaint,
        isTopLeft: true);
    drawCorner(canvas, scanBoxTopLeft + Offset(scanBoxWidth, 0), cornerLength,
        cornerPaint,
        isTopRight: true);
    drawCorner(canvas, scanBoxTopLeft + Offset(0, scanBoxHeight), cornerLength,
        cornerPaint,
        isBottomLeft: true);
    drawCorner(canvas, scanBoxTopLeft + Offset(scanBoxWidth, scanBoxHeight),
        cornerLength, cornerPaint,
        isBottomRight: true);
  }

  void drawCorner(Canvas canvas, Offset position, double length, Paint paint,
      {bool isTopLeft = false,
      bool isTopRight = false,
      bool isBottomLeft = false,
      bool isBottomRight = false}) {
    if (isTopLeft) {
      canvas.drawLine(position, position + Offset(length, 0), paint);
      canvas.drawLine(position, position + Offset(0, length), paint);
    } else if (isTopRight) {
      canvas.drawLine(position, position + Offset(-length, 0), paint);
      canvas.drawLine(position, position + Offset(0, length), paint);
    } else if (isBottomLeft) {
      canvas.drawLine(position, position + Offset(length, 0), paint);
      canvas.drawLine(position, position + Offset(0, -length), paint);
    } else if (isBottomRight) {
      canvas.drawLine(position, position + Offset(-length, 0), paint);
      canvas.drawLine(position, position + Offset(0, -length), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
