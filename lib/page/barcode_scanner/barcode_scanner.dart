import 'package:barcode_scanner/page/scan_result.dart';
import 'package:barcode_scanner/page/barcode_scanner/barcode_scanner_overlay.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerScreenBarcode extends StatefulWidget {
  const ScannerScreenBarcode({super.key});

  @override
  _ScannerScreenBarcodeState createState() => _ScannerScreenBarcodeState();
}

class _ScannerScreenBarcodeState extends State<ScannerScreenBarcode> {
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
        final scannedResult = barcodes.first.rawValue ?? "Unknown";

        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BarcodeScannerPage(result: scannedResult),
            ),
          ).then((_) {
            setState(() {
              isScanned = false;
            });
          });
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
              painter: BarcodeScannerOverlayPainter(borderRadius: 0),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: Icon(
                color: Colors.white,
                Ionicons.arrow_back,
                size: 25,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
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
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
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
            ),
          ),
          Positioned(
            bottom: 245,
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
