import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'ble_connection.dart';

class BLEScreen extends StatefulWidget {
  const BLEScreen({super.key});

  @override
  BLEScreenState createState() => BLEScreenState();
}

class BLEScreenState extends State<BLEScreen> {
  static final BLEService bleService = BLEService();
  List<BluetoothDevice> devices = [];
  BluetoothDevice? connectedDevice;
  bool isLoadingDevices = false;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    connectedDevice = bleService.connectedDevice;
    _scanForDevices();
  }

  void _scanForDevices() async {
    setState(() {
      isLoadingDevices = true;
      isProcessing = true;
    });

    List<BluetoothDevice> foundDevices = await bleService.scanDevices();

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
      await bleService.connectToBleDevice(device);
    }
    setState(() {
      connectedDevice = bleService.connectedDevice;
      isProcessing = false;
    });
  }

  void _disconnectFromBleDevice(BluetoothDevice device) async {
    setState(() {
      isProcessing = true;
    });

    if (connectedDevice == device) {
      await bleService.disconnectFromBleDevice(device);

      setState(() {
        connectedDevice = bleService.connectedDevice;
        isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available devices'),
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
