import 'package:flutter/material.dart';

void main() => runApp(const Bt2IrApp());

class Bt2IrApp extends StatelessWidget {
  const Bt2IrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;
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
      appBar: AppBar(
        title: const Text('Bluetooth2IR for TV'),
      ),
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

class BLEScreen extends StatelessWidget {
  const BLEScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLE connection'),
      ),
      body: const Center(
        child: Text('Lista dostępnych urządzeń'),
      ),
    );
  }
}

class ModeScreen extends StatelessWidget {
  const ModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TV type settings'),
      ),
      body: const Center(
        child: Text('Lista i edytor kodów IR'),
      ),
    );
  }
}

class ButtonsScreen extends StatelessWidget {
  const ButtonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Common buttons'),
      ),
      body: const Center(
        child: Text('Zwykłe przyciski'),
      ),
    );
  }
}

class NumericScreen extends StatelessWidget {
  const NumericScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Numeric'),
      ),
      body: const Center(
        child: Text('Przyciski numeryczne'),
      ),
    );
  }
}
