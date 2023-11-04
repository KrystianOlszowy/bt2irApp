import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'ble_connection.dart';

class BLEScreen extends StatefulWidget {
  const BLEScreen({super.key});

  @override
  BLEScreenState createState() => BLEScreenState();
}

class BLEScreenState extends State<BLEScreen> {
  static final BLEService bleService = BLEService();
  bool _isLoadingDevices = false;
  static bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    bleService.initCheckingBleDependencies();
    setState(() {
      bleService.updateConnectedDevice();
    });
    _scanForDevices();
  }

  void _scanForDevices() async {
    setState(() {
      _isLoadingDevices = true;
      isProcessing = true;
    });

    await bleService.scanBleDevices();

    setState(() {
      _isLoadingDevices = false;
      isProcessing = false;
    });
  }

  void _connectToBleDevice(BluetoothDevice device) async {
    setState(() {
      isProcessing = true;
    });
    await bleService.connectToBleDevice(device);
    setState(() {
      isProcessing = false;
    });
  }

  void _disconnectFromBleDevice(BluetoothDevice device) async {
    if (bleService.connectedDevice == device) {
      setState(() {
        isProcessing = true;
      });

      await bleService.disconnectFromBleDevice(device);

      setState(() {
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
      body: _isLoadingDevices
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: bleService.availableDevices.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(bleService.availableDevices[index].platformName),
                  subtitle: Text(
                      bleService.availableDevices[index].remoteId.toString() +
                          (bleService.connectedDevice == null).toString()),
                  isThreeLine: true,
                  onTap: () {
                    if (!isProcessing) {
                      if (bleService.connectedDevice == null) {
                        _connectToBleDevice(bleService.availableDevices[index]);
                      } else if (bleService.connectedDevice ==
                          bleService.availableDevices[index]) {
                        _disconnectFromBleDevice(
                            bleService.availableDevices[index]);
                      }
                    }
                  },
                );
              },
            ),
    );
  }
}
