import 'package:flutter/material.dart';

class ButtonsScreen extends StatelessWidget {
  const ButtonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main buttons'),
      ),
      body: const Center(
        child: Text('Zwykłe przyciski'),
      ),
    );
  }
}
