import 'package:flutter/material.dart';

class ModeScreen extends StatelessWidget {
  const ModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TV type settings'),
      ),
      body: const Center(
        child: Text('Lista i edytor kodów IR'),
      ),
    );
  }
}
