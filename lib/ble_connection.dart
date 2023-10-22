import 'package:flutter_blue/flutter_blue.dart';

class BLEService {
  BluetoothDevice? device;
  BluetoothCharacteristic? characteristic;

  Future<void> connectToDevice() async {
    List<BluetoothDevice> devices = await FlutterBlue.instance.connectedDevices;
    if (devices.isEmpty) {
      List<ScanResult> results = (FlutterBlue.instance
          .scan(timeout: const Duration(seconds: 4))) as List<ScanResult>;
      device = results[0].device;
    } else {
      device = devices[0];
    }
    if (device != null) {
      await device!.connect();
      List<BluetoothService> services = await device!.discoverServices();
      for (BluetoothService service in services) {
        for (BluetoothCharacteristic c in service.characteristics) {
          if (c.properties.write) {
            characteristic = c;
          }
        }
      }
    }
  }

  Future<void> sendData(int data) async {
    if (characteristic != null) {
      List<int> bytes = _intToBytes(data);
      await characteristic!.write(bytes);
    }
  }

  List<int> _intToBytes(int data) {
    List<int> bytes = [];
    for (int i = 0; i < 4; i++) {
      bytes.add((data >> (i * 8)) & 0xFF);
    }
    return bytes;
  }
}
