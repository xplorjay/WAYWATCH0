import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const WayWatchApp());
}

class WayWatchApp extends StatelessWidget {
  const WayWatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WayWatch',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}
