import 'package:flutter/material.dart';
import 'homepage.dart';

void main() => runApp(const Bt2IrApp());

class Bt2IrApp extends StatelessWidget {
  const Bt2IrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}
