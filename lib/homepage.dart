import 'package:flutter/material.dart';
import 'ble_screen.dart';
import 'buttons_screen.dart';
import 'numeric_screen.dart';
import 'mode_screen.dart';
import 'ble_connection.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  BLEService bleService = BLEService();
  final List<Widget> _children = [
    const BLEScreen(),
    const ModeScreen(),
    const ButtonsScreen(),
    const NumericScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('Bluetooth2IR for TV'))),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth),
            label: 'BLE',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Mode',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Buttons',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.keyboard),
            label: 'Numeric',
          ),
        ],
      ),
    );
  }
}
