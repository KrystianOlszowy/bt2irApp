import 'package:flutter/material.dart';
import 'ble_screen.dart';
import 'buttons_screen.dart';
import 'numeric_screen.dart';
import 'model_settings_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    const BLEScreen(),
    const ModelScreen(),
    const ButtonsScreen(),
    const NumericScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      if (!BLEScreenState.isProcessing) {
        _currentIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Center(child: Text('Bluetooth2IR for TV')),
          backgroundColor: Colors.blue[900]),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white54,
        showUnselectedLabels: true,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth_audio_rounded),
            label: 'Connection',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv_rounded),
            label: ' TV Model',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smartphone_rounded),
            label: 'Main buttons',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.numbers_rounded),
            label: 'Numeric',
          ),
        ],
      ),
    );
  }
}
