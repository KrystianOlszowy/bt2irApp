import 'package:flutter_blue/flutter_blue.dart';

class BLEService {
  static final BLEService _instance = BLEService._internal();
  factory BLEService() => _instance;

  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> availableDevices = [];
  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? characteristicButtonType;
  BluetoothCharacteristic? characteristicIrCode;
  String serviceUiid = "0f761ee5-3da9-40ef-9eb9-702db7e13037";
  String characteristicButtonTypeUiid = "c7e55ae3-855b-4d3b-be0e-f5153a8830c4";
  String characteristicIrCodeUiid = "84cbc1dd-b84d-4c8f-9df2-602152b3c2e2";
  bool isScanning = false;

  BLEService._internal();

  Future<List<BluetoothDevice>> scanDevices() async {
    flutterBlue.scanResults.listen((results) {
      availableDevices = results
          .map((scanResult) => scanResult.device)
          .where((device) => device.name.contains("Bluetooth2IR for TV"))
          .toList();
    });

    if (!isScanning) {
      isScanning = true;
      await flutterBlue.startScan(timeout: const Duration(seconds: 3));
      isScanning = false;
    }
    return availableDevices;
  }

  Future<void> connectToBleDevice(BluetoothDevice device) async {
    await device.connect();
    List<BluetoothService> services = await device.discoverServices();
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.uuid.toString() == characteristicButtonTypeUiid) {
          characteristicButtonType = characteristic;
        } else if (characteristic.uuid.toString() == characteristicIrCodeUiid) {
          characteristicIrCode = characteristic;
        }
      }
    }

    if (characteristicButtonType != null && characteristicIrCode != null) {
      connectedDevice = device;
    } else {
      device.disconnect();
      connectedDevice = null;
    }
  }

  Future<void> disconnectFromBleDevice(BluetoothDevice device) async {
    await device.disconnect();
    connectedDevice = null;
  }
}
