import 'package:bt2ir/tv_model.dart';
import 'package:flutter/material.dart';
import 'ble_connection.dart';

class ButtonsScreen extends StatefulWidget {
  const ButtonsScreen({super.key});

  @override
  State<ButtonsScreen> createState() => _ButtonsScreenState();
}

class _ButtonsScreenState extends State<ButtonsScreen> {
  static final bleService = BLEService();
  bool isSending = false;
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
            onPressed: () async {
              if (!isSending) {
                isSending = true;
                await bleService.sendButtonIdToDevice(
                    TVModelHandle.selectedTVModel.zero.getId());
                await bleService.sendIrCodeToDevice(
                    TVModelHandle.selectedTVModel.zero.getIrCode());
                isSending = false;
              }
            },
            child: const Text('ZERO'),
          ),
        ],
      )),
    );
  }
}
