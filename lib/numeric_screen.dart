import 'package:flutter/material.dart';

class NumericScreen extends StatelessWidget {
  const NumericScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Numeric'),
      ),
      body: const Center(
        child: Text('Przyciski numeryczne'),
      ),
    );
  }
}
