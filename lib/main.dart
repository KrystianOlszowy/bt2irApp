import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'homepage.dart';

void main() => runApp(const Bt2IrApp());

class Bt2IrApp extends StatelessWidget {
  const Bt2IrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: GoogleFonts.varelaRound().fontFamily,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Colors.grey[850], // Set your desired primary color here
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}
