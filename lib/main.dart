import 'package:flutter/material.dart';

import 'screens/converter_screen.dart';

void main() {
  runApp(const RadixConverterApp());
}

class RadixConverterApp extends StatelessWidget {
  const RadixConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'baseshift',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Avenir',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00A9D8),
          brightness: Brightness.light,
        ),
      ),
      home: const ConverterScreen(),
    );
  }
}
