import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ScannerScreen(),
    );
  }
}

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController cameraController = MobileScannerController();
  bool isFlashOn = false;
  bool isScanned = false;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _onBarcodeDetected(BarcodeCapture capture) {
    if (!isScanned) {
      isScanned = true;
      final List<Barcode> barcodes = capture.barcodes;
      if (barcodes.isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pop(context, barcodes.first.rawValue ?? "Unknown");
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: MobileScanner(
              controller: cameraController,
              onDetect: _onBarcodeDetected,
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: ScannerOverlayPainter(borderRadius: 0),
            ),
          ),
          Positioned(
              top: 53,
              left: 40,
              right: 40,
              child: Text(
                'Scan Barcode',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
          Positioned(
              top: 40,
              left: 22,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 25,
                  color: Colors.white,
                ),
              )),
          Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: Icon(
                  color: Colors.white,
                  isFlashOn ? Icons.flash_on : Icons.flash_off,
                ),
                onPressed: () {
                  setState(() {
                    isFlashOn = !isFlashOn;
                  });
                  cameraController.toggleTorch();
                },
              )),
          Positioned(
            bottom: 245, // Jarak dari bawah
            left: 50,
            right: 50,
            child: Center(
              child: Text(
                "Sejajarkan barcode dengan bingkai untuk memindai",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  final double borderRadius;

  ScannerOverlayPainter({this.borderRadius = 0});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint overlayPaint = Paint()
      ..color = Colors.black.withOpacity(0.7) // Warna overlay gelap
      ..style = PaintingStyle.fill;

    final Paint cornerPaint = Paint()
      ..color = Colors.white // Warna border di sudut
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final double scanBoxWidth = 260;
    final double scanBoxHeight = 150;
    final double cornerLength = 20; // Panjang garis sudut
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
