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
  BluetoothDevice? connectingDevice;
  BluetoothDevice? disconnectingDevice;
  static bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    initBleScreen();
  }

  void initBleScreen() async {
    await bleService.initCheckingBleAdapter();
    bleService.updateConnectedDevice();
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
      connectingDevice = device;
    });
    await bleService.connectToBleDevice(device);
    setState(() {
      isProcessing = false;
      connectingDevice = null;
    });
  }

  void _disconnectFromBleDevice(BluetoothDevice device) async {
    if (bleService.connectedDevice == device) {
      setState(() {
        isProcessing = true;
        disconnectingDevice = device;
      });

      await bleService.disconnectFromBleDevice(device);

      setState(() {
        isProcessing = false;
        disconnectingDevice = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text(
          'Tap on listed device to connect:',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Column(children: [
        Expanded(
          child: _isLoadingDevices
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: bleService.availableDevices.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      tileColor: getListTrailingColor(index),
                      leading: const Icon(Icons.router_outlined, size: 40),
                      title:
                          Text(bleService.availableDevices[index].platformName),
                      subtitle: Text(bleService.availableDevices[index].remoteId
                          .toString()),
                      trailing: getListTrailingIcon(index),
                      onTap: () {
                        if (!isProcessing &&
                            bleService.connectedDevice == null) {
                          _connectToBleDevice(
                              bleService.availableDevices[index]);
                        }
                      },
                      onLongPress: () {
                        if (!isProcessing &&
                            bleService.connectedDevice ==
                                bleService.availableDevices[index]) {
                          _disconnectFromBleDevice(
                              bleService.availableDevices[index]);
                        }
                      },
                    );
                  },
                ),
        ),
        const Padding(
            padding: EdgeInsets.all(5.0),
            child: Text(
              'Long press on connected device to disconnect.',
            )),
        Padding(
            padding: const EdgeInsets.all(5.0),
            child: ElevatedButton(
              onPressed: () {
                if (!isProcessing && !_isLoadingDevices) {
                  _scanForDevices();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 12.0),
                minimumSize: const Size(double.infinity, 20),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Refresh ", style: TextStyle(fontSize: 20)),
                    Icon(Icons.refresh_rounded)
                  ]),
            ))
      ]),
    );
  }

  Widget? getListTrailingIcon(int index) {
    if (bleService.availableDevices[index] == connectingDevice) {
      return const SizedBox(
        height: 28.0,
        width: 28.0,
        child: CircularProgressIndicator(),
      );
    } else if (bleService.availableDevices[index] == disconnectingDevice) {
      return const Icon(Icons.bluetooth_disabled_rounded, size: 25);
    } else if (bleService.connectedDevice ==
        bleService.availableDevices[index]) {
      return const Icon(Icons.bluetooth_connected_rounded, size: 25); //
    }
    return null;
  }

  getListTrailingColor(int index) {
    if (bleService.availableDevices[index] == connectingDevice) {
      return Colors.blue[900];
    } else if (bleService.availableDevices[index] == disconnectingDevice) {
      return Colors.red[900];
    } else if (bleService.connectedDevice ==
        bleService.availableDevices[index]) {
      return Colors.green[800];
    }
    return null;
  }
}
