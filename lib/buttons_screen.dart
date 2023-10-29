import 'package:flutter/material.dart';
import 'ble_connection.dart';

class ButtonsScreen extends StatefulWidget {
  const ButtonsScreen({super.key});

  @override
  State<ButtonsScreen> createState() => _ButtonsScreenState();
}

class _ButtonsScreenState extends State<ButtonsScreen> {
  static final bleService = BLEService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main buttons'),
      ),
      body: Center(
          child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              bleService.sendButtonIdToDevice(0);
            },
            child: const Text('ZERO'),
          ),
        ],
      )),
    );
  }
}
