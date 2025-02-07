import 'package:barcode_scanner/page/qr_scanner/qr_scanner_overlay.dart';
import 'package:barcode_scanner/page/scan_result.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({super.key});

  @override
  _QrScannerState createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  final MobileScannerController cameraController = MobileScannerController();
  bool isFlashOn = false;
  bool isScanned = false;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _onQrDetected(BarcodeCapture capture) {
    if (!isScanned) {
      setState(() {
        isScanned = true;
      });

      final List<Barcode> barcodes = capture.barcodes;
      if (barcodes.isNotEmpty) {
        String scannedResult = barcodes.first.rawValue ?? "Unknown";
        scannedResult = scannedResult.replaceAll(';', '\n');

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
              onDetect: _onQrDetected, 
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: QrScannerOverlayPainter(borderRadius: 0),
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
            child: const Text(
              'Scan QR Code',
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
                isFlashOn ? Icons.flash_on : Icons.flash_off,
                color: Colors.white,
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
            bottom: 195,
            left: 50,
            right: 50,
            child: const Center(
              child: Text(
                "Sejajarkan QR Code dengan bingkai untuk memindai",
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
