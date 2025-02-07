import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BarcodeScannerPage extends StatelessWidget {
  final String result;

  const BarcodeScannerPage({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0f0f0f),
      appBar: AppBar(
        backgroundColor: Color(0xff0f0f0f),
        title: const Text(
          'Hasil Scan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); 
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: SelectableText(            
            result,
            style: const TextStyle(              
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
