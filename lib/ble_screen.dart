import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'ble_connection.dart';

class BLEScreen extends StatefulWidget {
  final BLEService bleService = BLEService();
  BLEScreen({super.key});

  @override
  BLEScreenState createState() => BLEScreenState();
}

class BLEScreenState extends State<BLEScreen> {
  List<BluetoothDevice> devices = [];
  BluetoothDevice? connectedDevice;
  bool isLoadingDevices = false;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    connectedDevice = widget.bleService.connectedDevice;
    _scanForDevices();
  }

  void _scanForDevices() async {
    setState(() {
      isLoadingDevices = true;
      isProcessing = true;
    });

    List<BluetoothDevice> foundDevices = await widget.bleService.scanDevices();

    if (mounted) {
      setState(() {
        devices = foundDevices;
        isLoadingDevices = false;
        isProcessing = false;
      });
    }
  }

  void _connectToBleDevice(BluetoothDevice device) async {
    setState(() {
      isProcessing = true;
    });
    if (connectedDevice == null) {
      await widget.bleService.connectToBleDevice(device);
    }
    setState(() {
      connectedDevice = widget.bleService.connectedDevice;
      isProcessing = false;
    });
  }

  void _disconnectFromBleDevice(BluetoothDevice device) async {
    setState(() {
      isProcessing = true;
    });

    if (connectedDevice == device) {
      await widget.bleService.disconnectFromBleDevice(device);

      setState(() {
        connectedDevice = widget.bleService.connectedDevice;
        isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista Urządzeń BLE'),
      ),
      body: isLoadingDevices
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: devices.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(devices[index].name),
                  subtitle: Text(devices[index].id.toString() +
                      (connectedDevice == null).toString()),
                  onTap: () {
                    // Tutaj możesz zaimplementować logikę po naciśnięciu elementu listy
                    if (!isProcessing) {
                      if (connectedDevice == null) {
                        _connectToBleDevice(devices[index]);
                      } else if (connectedDevice == devices[index]) {
                        _disconnectFromBleDevice(devices[index]);
                      }
                    }
                  },
                );
              },
            ),
    );
  }
}
