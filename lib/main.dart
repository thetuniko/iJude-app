import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const IJudeApp());
}

class IJudeApp extends StatelessWidget {
  const IJudeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'iJude',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00897B)),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}