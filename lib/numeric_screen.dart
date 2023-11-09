import 'package:bt2ir/ble_connection.dart';
import 'package:bt2ir/tv_model.dart';
import 'package:flutter/material.dart';

class NumericScreen extends StatefulWidget {
  const NumericScreen({super.key});

  @override
  State<NumericScreen> createState() => _NumericScreenState();
}

class _NumericScreenState extends State<NumericScreen> {
  final BLEService _bleService = BLEService();
  bool isSending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Center(child: Text('Numeric buttons')),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(30),
                    ),
                    onPressed: () async {
                      if (!isSending) {
                        isSending = true;
                        await _bleService.sendButtonIdToDevice(
                            TVModelHandle.selectedTVModel.one.getId());
                        await _bleService.sendIrCodeToDevice(
                            TVModelHandle.selectedTVModel.one.getIrCode());
                        isSending = false;
                      }
                    },
                    child: const Text(
                      '1',
                      style: TextStyle(fontSize: 40),
                    )),
              ),
              Expanded(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(30), // text color
                    ),
                    onPressed: () async {
                      if (!isSending) {
                        isSending = true;
                        await _bleService.sendButtonIdToDevice(
                            TVModelHandle.selectedTVModel.two.getId());
                        await _bleService.sendIrCodeToDevice(
                            TVModelHandle.selectedTVModel.two.getIrCode());
                        isSending = false;
                      }
                    },
                    child: const Text(
                      '2',
                      style: TextStyle(fontSize: 40),
                    )),
              ),
              Expanded(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(30), // text color
                    ),
                    onPressed: () async {
                      if (!isSending) {
                        isSending = true;
                        await _bleService.sendButtonIdToDevice(
                            TVModelHandle.selectedTVModel.three.getId());
                        await _bleService.sendIrCodeToDevice(
                            TVModelHandle.selectedTVModel.three.getIrCode());
                        isSending = false;
                      }
                    },
                    child: const Text(
                      '3',
                      style: TextStyle(fontSize: 40),
                    )),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(30),
                      ),
                      onPressed: () async {
                        if (!isSending) {
                          isSending = true;
                          await _bleService.sendButtonIdToDevice(
                              TVModelHandle.selectedTVModel.four.getId());
                          await _bleService.sendIrCodeToDevice(
                              TVModelHandle.selectedTVModel.four.getIrCode());
                          isSending = false;
                        }
                      },
                      child: const Text(
                        '4',
                        style: TextStyle(fontSize: 40),
                      )),
                ),
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(30), // text color
                      ),
                      onPressed: () async {
                        if (!isSending) {
                          isSending = true;
                          await _bleService.sendButtonIdToDevice(
                              TVModelHandle.selectedTVModel.five.getId());
                          await _bleService.sendIrCodeToDevice(
                              TVModelHandle.selectedTVModel.five.getIrCode());
                          isSending = false;
                        }
                      },
                      child: const Text(
                        '5',
                        style: TextStyle(fontSize: 40),
                      )),
                ),
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(30), // text color
                      ),
                      onPressed: () async {
                        if (!isSending) {
                          isSending = true;
                          await _bleService.sendButtonIdToDevice(
                              TVModelHandle.selectedTVModel.six.getId());
                          await _bleService.sendIrCodeToDevice(
                              TVModelHandle.selectedTVModel.six.getIrCode());
                          isSending = false;
                        }
                      },
                      child: const Text(
                        '6',
                        style: TextStyle(fontSize: 40),
                      )),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(30),
                      ),
                      onPressed: () async {
                        if (!isSending) {
                          isSending = true;
                          await _bleService.sendButtonIdToDevice(
                              TVModelHandle.selectedTVModel.seven.getId());
                          await _bleService.sendIrCodeToDevice(
                              TVModelHandle.selectedTVModel.seven.getIrCode());
                          isSending = false;
                        }
                      },
                      child: const Text(
                        '7',
                        style: TextStyle(fontSize: 40),
                      )),
                ),
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(30), // text color
                      ),
                      onPressed: () async {
                        if (!isSending) {
                          isSending = true;
                          await _bleService.sendButtonIdToDevice(
                              TVModelHandle.selectedTVModel.eight.getId());
                          await _bleService.sendIrCodeToDevice(
                              TVModelHandle.selectedTVModel.eight.getIrCode());
                          isSending = false;
                        }
                      },
                      child: const Text(
                        '8',
                        style: TextStyle(fontSize: 40),
                      )),
                ),
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(30), // text color
                      ),
                      onPressed: () async {
                        if (!isSending) {
                          isSending = true;
                          await _bleService.sendButtonIdToDevice(
                              TVModelHandle.selectedTVModel.nine.getId());
                          await _bleService.sendIrCodeToDevice(
                              TVModelHandle.selectedTVModel.nine.getIrCode());
                          isSending = false;
                        }
                      },
                      child: const Text(
                        '9',
                        style: TextStyle(fontSize: 40),
                      )),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(30),
                      ),
                      onPressed: () async {
                        if (!isSending) {
                          isSending = true;
                          await _bleService.sendButtonIdToDevice(
                              TVModelHandle.selectedTVModel.zero.getId());
                          await _bleService.sendIrCodeToDevice(
                              TVModelHandle.selectedTVModel.zero.getIrCode());
                          isSending = false;
                        }
                      },
                      child: const Text(
                        '0',
                        style: TextStyle(fontSize: 40),
                      )),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
