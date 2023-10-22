import 'package:flutter/material.dart';

class BLEScreen extends StatelessWidget {
  const BLEScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLE connection'),
      ),
      body: const Center(
        child: Text('Lista dostępnych urządzeń'),
      ),
    );
  }
}
