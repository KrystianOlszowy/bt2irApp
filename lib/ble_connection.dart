import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:location/location.dart';
import 'dart:typed_data';

class BLEService {
  static final BLEService _instance = BLEService._internal();
  factory BLEService() => _instance;

  bool _isBluetoothOn = false;
  bool _locationEnabled = false;
  bool _alreadyAsked = false;
  bool _isScanning = false;
  List<BluetoothDevice> availableDevices = [];
  BluetoothDevice? connectedDevice;

  BluetoothCharacteristic? _characteristicButtonType;
  BluetoothCharacteristic? _characteristicIrCode;

  static const String _serviceUiid = "0f761ee5-3da9-40ef-9eb9-702db7e13037";
  static const String _characteristicButtonTypeUiid =
      "c7e55ae3-855b-4d3b-be0e-f5153a8830c4";
  static const String _characteristicIrCodeUiid =
      "84cbc1dd-b84d-4c8f-9df2-602152b3c2e2";

  BLEService._internal();

  Future<void> initCheckingBleDependencies() async {
    _alreadyAsked = false;

    FlutterBluePlus.adapterState.listen((state) {
      _isBluetoothOn = state == BluetoothAdapterState.on;
      if (!_isBluetoothOn) {
        FlutterBluePlus.stopScan();
        if (!_alreadyAsked) {
          _alreadyAsked = true;
          FlutterBluePlus.turnOn();
          scanBleDevices();
        }
      } else {
        _alreadyAsked = false;
      }
    });

    _locationEnabled = await Location().serviceEnabled();
    if (!_locationEnabled) {
      Location().requestService();
    }
  }

  Future<void> scanBleDevices() async {
    FlutterBluePlus.scanResults.listen((results) {
      availableDevices = results
          .map((scanResult) => scanResult.device)
          .where(
              (device) => device.platformName.contains("Bluetooth2IR for TV"))
          .toList();
    });

    if (!_isScanning && _isBluetoothOn && _locationEnabled) {
      _isScanning = true;
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 3));
      await FlutterBluePlus.isScanning.where((value) => value == false).first;
      _isScanning = false;
    }
  }

  void updateConnectedDevice() {
    if (FlutterBluePlus.connectedDevices.isNotEmpty) {
      connectedDevice = FlutterBluePlus.connectedDevices.first;
    } else {
      connectedDevice = null;
    }
  }

  Future<void> connectToBleDevice(BluetoothDevice device) async {
    if (connectedDevice == null) {
      try {
        await device.connect();
      } on PlatformException catch (error) {
        if (error.code != "already_connected") {
          return;
        }
      }
    }

    List<BluetoothService> services = await device.discoverServices();
    for (var service in services) {
      if (service.serviceUuid.toString() == _serviceUiid) {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid.toString() == _characteristicButtonTypeUiid) {
            _characteristicButtonType = characteristic;
          } else if (characteristic.uuid.toString() ==
              _characteristicIrCodeUiid) {
            _characteristicIrCode = characteristic;
          }
        }
      }
    }

    if (_characteristicButtonType != null && _characteristicIrCode != null) {
      updateConnectedDevice();
    } else {
      disconnectFromBleDevice(device);
    }
  }

  Future<void> sendButtonIdToDevice(int buttonId) async {
    Uint8List buttonIdUint64List = Uint8List(8);
    buttonIdUint64List.buffer
        .asByteData()
        .setUint64(0, buttonId, Endian.little);
    await _characteristicButtonType?.write(buttonIdUint64List,
        withoutResponse: false);
  }

  Future<void> sendIrCodeToDevice(int irCode) async {
    Uint8List irCodeUint64List = Uint8List(8);
    irCodeUint64List.buffer.asByteData().setUint64(0, irCode, Endian.little);
    await _characteristicIrCode?.write(irCodeUint64List,
        withoutResponse: false);
  }

  Future<void> disconnectFromBleDevice(BluetoothDevice device) async {
    await device.disconnect();
    _characteristicIrCode = null;
    _characteristicButtonType = null;
    connectedDevice = null;
  }
}
