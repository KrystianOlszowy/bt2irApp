import 'package:flutter_blue/flutter_blue.dart';

class BLEService {
  static final BLEService _instance = BLEService._internal();
  factory BLEService() => _instance;

  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> availableDevices = [];
  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? characteristicButtonType;
  BluetoothCharacteristic? characteristicIrCode;
  String serviceId = "0f761ee5-3da9-40ef-9eb9-702db7e13037";
  bool isScanning = false;

  BLEService._internal();

  Future<List<BluetoothDevice>> scanDevices() async {
    flutterBlue.scanResults.listen((results) {
      availableDevices = results
          .map((scanResult) => scanResult.device)
          .where((device) => device.name.isNotEmpty)
          .toList();
    });

    if (!isScanning) {
      isScanning = true;
      await flutterBlue.startScan(timeout: const Duration(seconds: 3));
      isScanning = false;
    }

    return availableDevices;
  }
}
