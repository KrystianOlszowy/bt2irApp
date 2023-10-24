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
  bool isLoading = false;
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    _scanForDevices();
  }

  void _scanForDevices() async {
    setState(() {
      isLoading = true;
    });

    List<BluetoothDevice> foundDevices = await widget.bleService.scanDevices();

    if (mounted) {
      setState(() {
        devices = foundDevices;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista Urządzeń BLE'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: devices.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(devices[index].name),
                  subtitle: Text(devices[index].id.toString()),
                  onTap: () {
                    // Tutaj możesz zaimplementować logikę po naciśnięciu elementu listy
                  },
                );
              },
            ),
    );
  }
}
